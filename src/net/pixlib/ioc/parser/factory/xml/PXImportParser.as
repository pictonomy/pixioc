/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package net.pixlib.ioc.parser.factory.xml 
{
	import net.pixlib.ioc.assembler.locator.PXImport;
	import net.pixlib.ioc.assembler.locator.PXImportExpert;
	import net.pixlib.ioc.core.PXContextAttributeList;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.PXXMLLoader;
	import net.pixlib.load.collection.PXLoaderCollectionEvent;
	import net.pixlib.load.collection.PXQueueLoader;
	import net.pixlib.log.PXDebug;
	import net.pixlib.utils.PXFlashVars;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * The ImportParser class allow to inject IoC context into another 
	 * IoC context. ( import feature )
	 * 
	 * @example How to import context
	 * <pre class="prettyprint">
	 * 
	 * &lt;beans&gt;
	 * 	&lt;import url="config/context.xml" root-ref="container" /&gt;
	 * 
	 * 	&lt;root id="root"&gt;
	 * 		&lt;child id="container" /&gt;
	 * 	&lt;/root&gt;
	 * &lt;/beans&gt; 
	 * </pre>
	 * 
	 * <p><code>sandbox</code> url parsing are checked to enable full 
	 * plugin structure management.</p>
	 * @example In imported XML context
	 * <pre class="prettyprint">
	 * 
	 * &lt;beans&gt;
	 * 	&lt;rsc id="logo" url="sandbox://bitmap.png" type="binary" /&gt;
	 * &lt;/beans&gt; 
	 * </pre>
	 * <p>Here, the <code>bitmap.png</code> url are relative to the imported 
	 * xml context file.<br />
	 * Note : only <code>sandbox</code> url are threated, all others types 
	 * ( flashvars replacement for example ) are threated later with the global 
	 * <code>PathParser</code> context processing.</p>
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXImportParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _loader : PXQueueLoader;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>XMLImportParser</code> instance.
		 */
		public function PXImportParser(   )
		{
			_loader = new PXQueueLoader();
		}

		/**
		 * Starts include job.
		 */
		override public function parse() : void
		{
			parseImport(getXMLContext());
			
			executeQueue();
		}
		

		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.IMPORT_PARSE_STATE;
		}

		/**
		 * @private
		 */
		protected function executeQueue( ) : void
		{
			if( !_loader.empty )
			{
				_loader.addEventListener(PXLoaderCollectionEvent.onItemLoadInitEVENT, onImportLoadInit);
				_loader.addEventListener(PXLoaderCollectionEvent.onLoadProgressEVENT, onImportLoadProgress);
				_loader.addEventListener(PXLoaderCollectionEvent.onLoadTimeOutEVENT, onImportLoadError);
				_loader.addEventListener(PXLoaderCollectionEvent.onLoadErrorEVENT, onImportLoadError);
				_loader.addEventListener(PXLoaderCollectionEvent.onLoadInitEVENT, onLoadQueueInit);
				_loader.execute();
			}
			else fireOnCompleteEvent();
		}

		/**
		 * @private
		 */
		protected function release() : void
		{
			_loader.removeEventListener(PXLoaderCollectionEvent.onItemLoadInitEVENT, onImportLoadInit);
			_loader.removeEventListener(PXLoaderCollectionEvent.onLoadProgressEVENT, onImportLoadProgress);
			_loader.removeEventListener(PXLoaderCollectionEvent.onLoadTimeOutEVENT, onImportLoadError);
			_loader.removeEventListener(PXLoaderCollectionEvent.onLoadErrorEVENT, onImportLoadError);
			_loader.removeEventListener(PXLoaderCollectionEvent.onLoadInitEVENT, onLoadQueueInit);
			_loader.release();
			_loader = null;
		}

		/**
		 * @private
		 */
		protected function parseImport( xml : XML ) : void
		{
			var incXML : XMLList = xml.child(PXContextNameList.IMPORT);
			var length : int = incXML.length();
			
			for ( var i : int = 0;i < length; i++ ) 
			{
				var node : XML = incXML[ i ];
				var info : PXImport = new PXImport(new URLRequest(PXAttributeUtils.getURL(node)), PXAttributeUtils.getRootRef(node));
				
				var identifier : String = info.url.url;
				
				PXImportExpert.getInstance().register(identifier, info);
				
				var xLoader : PXXMLLoader = new PXXMLLoader();
				
				_loader.add(xLoader, identifier, info.url, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			
			delete xml[ PXContextNameList.IMPORT ];
		}

		/**
		 * @private
		 */
		protected function onImportLoadInit( event : PXLoaderEvent ) : void
		{
			PXDebug.DEBUG( "[" + getState( ) + "] " + event.loader.request.url + " loaded", this );
			
			var xml : XML = PXXMLLoader(event.loader).xml;
			var info : PXImport = PXImportExpert.getInstance().locate(event.name) as PXImport;
			
			checkImportSandbox(xml, event.loader.request.url);
			checkImportDomain(xml);
			
			parseImport(xml);
			
			try
			{
				var container : XMLList = getXMLContext().descendants().(  hasOwnProperty("@id") && @id == info.rootRef );
				
				if( xml.hasOwnProperty(PXContextNameList.ROOT) )
				{
					container.appendChild(xml.child(PXContextNameList.ROOT).children());
					
					delete xml[ PXContextNameList.ROOT ];
				}
			}
			catch( e : Error ) 
			{
				PXDebug.ERROR(this + "::no rootref for " + info.url.url + " -> " + info.rootRef, this);
			}
			finally 
			{
				for each (var node : XML in xml.children() ) 
				{
					getXMLContext().appendChild(node);
				}
				
				PXImportExpert.getInstance().unregister(info.url.url);
			}
		}

		/**
		 * @private
		 */
		protected function onImportLoadProgress( event : PXLoaderEvent ) : void
		{
		}

		/**
		 * @private
		 */
		protected function onImportLoadError( event : PXLoaderEvent ) : void
		{
			PXDebug.ERROR( "load(" + event.loader.request.url + ")" + ":: " + event.errorMessage, this );
			
			fireOnCompleteEvent();
		}

		/**
		 * @private
		 */
		protected function onLoadQueueInit( event : Event ) : void
		{
			release();
			
			fireOnCompleteEvent();
		}

		/**
		 * Triggered when all context pre processors are completed. 
		 */
		protected function fireOnCompleteEvent( ) : void
		{
			fireCommandEndEvent();
		}
		
		/**
		 * Resolve "sandbox" url type for imported XML content.
		 * 
		 * @param	imported	Imported XML data
		 * @param	contextURL	URL of imported file
		 */
		protected function checkImportSandbox( imported : XML, contextURL : String ) : void
		{
			var result : XMLList = imported..*.( hasOwnProperty(getAttributeName(PXContextAttributeList.URL)) && String(@[PXContextAttributeList.URL]).length > 0 );
			
			for each (var node : XML in result)
			{
				var separator : String = "://";
				var url : String = node.@url;
				var key : String = url.substring(0, url.indexOf(separator));
				
				if( key == "sandbox" )
				{
					node.@url = _createCleanRelativeURL(contextURL, url.substr(url.indexOf(separator) + separator.length));
				}
				else if(PXFlashVars.getInstance().isRegistered(key))
				{
					node.@url = url.replace(key + separator, PXFlashVars.getInstance().getString(key));
				}
			}
		}
		
		protected function checkImportDomain( imported : XML ) : void
		{
			if( imported.hasOwnProperty(getAttributeName("domain")) )
			{
				var domain : String = imported.@domain;
				
				if( domain.length > 0 )
				{
					var node : XML;
					
					//ID process
					var nodes : XMLList = imported..*.( hasOwnProperty(getAttributeName(PXContextAttributeList.ID)) && String(@[PXContextAttributeList.ID]).length > 0 );
					for each ( node in nodes ) 
					{
						node.@id = domain + "_" + node.@id;
					}
					
					//REF process
					nodes = imported..*.( hasOwnProperty(getAttributeName(PXContextAttributeList.REF)) && String(@[PXContextAttributeList.REF]).length > 0 );
					for each (node  in nodes ) 
					{
						if( String(node.@ref).indexOf("/") == 0 )
						{
							node.@ref = String(node.@ref).substr(1);	
						}
						else
						{
							node.@ref = domain + "_" + node.@ref;
						}
					}
				}
			}
		}

		/**
		 * Returns XML attribute full qualified name.
		 */
		protected function getAttributeName( name : String ) : String
		{
			return "@" + name;		
		}

		/**
		 * Parses url.
		 */
		protected function getSandboxURL( url : String, contextURL : String  ) : String
		{
			var cURL : String = contextURL.substring(0, getApplicationLoader().request.url.indexOf("?"));
			var contextPath : String = cURL.substring(0, contextURL.lastIndexOf("/"));
			
			if( contextPath.length > 0 ) contextPath += "/";
			
			return contextPath + url;
		}
		
		private static function _createCleanRelativeURL( baseURL : String, fileURL : String ) : String
		{
			var absoluteURL : String = fileURL;
			
			if (!(fileURL.indexOf(":") > -1 || fileURL.indexOf("/") == 0 || fileURL.indexOf("\\") == 0))
			{
				if (baseURL)
				{
					var lastIndex : int = Math.max(baseURL.lastIndexOf("\\"), baseURL.lastIndexOf("/"));
					
					if (fileURL.indexOf("./") == 0)
					{
						fileURL = fileURL.substring(2);
					}
					else
					{
						while (fileURL.indexOf("../") == 0)
						{
							fileURL = fileURL.substring(3);
							var parentIndex : int = Math.max(baseURL.lastIndexOf("\\", lastIndex - 1), baseURL.lastIndexOf("/", lastIndex - 1));
							lastIndex = parentIndex;
						}
					}
                                            
					if (lastIndex != -1)
                    	absoluteURL = baseURL.substr(0, lastIndex + 1) + fileURL;
				}
			}
			
			return absoluteURL;
		}
	}
}
