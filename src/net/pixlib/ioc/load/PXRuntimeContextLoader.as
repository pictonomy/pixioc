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
package net.pixlib.ioc.load 
{
	import net.pixlib.ioc.assembler.locator.PXPluginExpert;
	import net.pixlib.load.PXLoaderLocator;

	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * RuntimeContextLoader class allow to load / unload IoC 
	 * context at runtime.
	 * 
	 * @example Loads IoC context
	 * <listing>
	 * 
	 * var loader : RuntimeContextLoader = new RuntimeContextLoader("myContext", this, new URLRequest("runtime.xml"));
	 * loader.addEventListener(ApplicationLoaderEvent.onApplicationInitEVENT, testRuntime);
	 * loader.execute();
	 * </listing>
	 * 
	 * @example Unloads IoC context
	 * <listing>
	 * 
	 * RuntimeContextLoader(LoaderLocator.getInstance().getLoader("myContext")).unload();
	 * </listing>
	 * 
	 * TODO Check IoC DisplayLoader management
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXRuntimeContextLoader extends PXApplicationLoader
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function PXRuntimeContextLoader(	runtimeID : String,
												rootTarget : DisplayObjectContainer, 
												loadingRequest : URLRequest = null )
		{
			super(rootTarget, false, loadingRequest);
			
			name = runtimeID;
		}

		/**
		 * @inheritDoc
		 */
		override public function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{	
			addProcessor(new RuntimeGCProcessor(RuntimeGCLocator.getInstance(name, displayObjectBuilder)));
			
			super.load(url, context);
		}

		/**
		 * Unloads context components.
		 */
		public function unload() : void
		{
			RuntimeGCLocator.getInstance(name).release();
			
			if ( bMustUnregister ) 
			{
				PXLoaderLocator.getInstance().unregister(name);
				bMustUnregister = false;
			}
			
			oLoadStrategy.release();
			oEB.removeAllListeners();
		}

		/**
		 * @private
		 */
		override public function release() : void
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function fireOnApplicationInit() : void 
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationInitEVENT, this));
			
			fireOnApplicationState(PXApplicationLoaderState.COMPLETE_STATE);
			
			if( oDLoader != null ) removeListener(oDLoader);
			
			onInitialize();
			
			PXPluginExpert.getInstance().notifyAllPlugins();
		}
	}
}

import net.pixlib.collections.PXHashMap;
import net.pixlib.collections.PXIterator;
import net.pixlib.collections.PXSet;
import net.pixlib.core.PXCoreFactory;
import net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilder;
import net.pixlib.ioc.core.PXContextAttributeList;
import net.pixlib.ioc.parser.factory.processor.PXAbstractContextProcessor;
import net.pixlib.plugin.PXPlugin;

import flash.display.DisplayObject;

internal class RuntimeGCProcessor extends PXAbstractContextProcessor
{
	private var _oLocator : RuntimeGCLocator;

	
	public function RuntimeGCProcessor( cgLocator : RuntimeGCLocator )
	{
		_oLocator = cgLocator;
	}

	public function process(context : *) : *
	{
		var xml : XML = context is XML ? context as XML : new XML(context);
		var list : XMLList = xml..*.( hasOwnProperty(getAttributeName(PXContextAttributeList.ID)) );
		var length : uint = list.length();
		
		for( var i : uint = 0;i < length; i++ )
		{
			_oLocator.register(list[i].@id);	
		}
		
		return xml;
	}

	private function getAttributeName( name : String ) : String
	{
		return "@" + name;		
	}
}

internal class RuntimeGCLocator
{
	private static var _MAP : PXHashMap = new PXHashMap();

	private var _aID : PXSet;
	private var _oDisplayBuilder : PXDisplayObjectBuilder;

	
	public static function getInstance( context : String, displayObjectBuilder : PXDisplayObjectBuilder = null ) : RuntimeGCLocator
	{
		if( !_MAP.containsKey(context) )
		{
			_MAP.put(context, new RuntimeGCLocator(displayObjectBuilder));
		}
		
		return _MAP.get(context);
	}

	public function register( id : String ) : void
	{
		if( !_aID.contains(id) ) _aID.add(id);			
	}

	public function release() : void
	{
		var iter : PXIterator = _aID.iterator();
		var cFactory : PXCoreFactory = PXCoreFactory.getInstance();
		
		while( iter.hasNext() )
		{
			var key : String = iter.next();
			
			if( cFactory.isRegistered(key) )
			{
				var bean : * = cFactory.locate(key);
				
				if(bean is PXPlugin)
				{
					PXPlugin(bean).release();
				}
				else if(bean is DisplayObject)
				{
					var dpo : DisplayObject = bean as DisplayObject;
						
					if( _oDisplayBuilder && dpo != _oDisplayBuilder.rootTarget )
					{
						if( dpo.parent ) dpo.parent.removeChild(dpo);
							else dpo = null;
					}
				}
				else
				{
					var val : * = PXCoreFactory.getInstance().locate(key);
					val = null;
						
					PXCoreFactory.getInstance().unregister(key);
				}
			}
		}
	}

	function RuntimeGCLocator( displayObjectBuilder : PXDisplayObjectBuilder = null )
	{
		_aID = new PXSet(String);
		_oDisplayBuilder = displayObjectBuilder;
	}
}