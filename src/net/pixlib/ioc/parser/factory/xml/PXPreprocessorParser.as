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
	import net.pixlib.commands.PXCommand;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.ioc.assembler.locator.PXConstructorExpert;
	import net.pixlib.ioc.assembler.locator.PXProperty;
	import net.pixlib.ioc.assembler.locator.PXPropertyExpert;
	import net.pixlib.ioc.control.PXBuildFactory;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.core.PXContextTypeList;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.ioc.parser.factory.processor.PXContextProcessorBatch;
	import net.pixlib.ioc.parser.factory.processor.PXContextProcessorEvent;
	import net.pixlib.load.PXGraphicLoader;
	import net.pixlib.load.collection.PXLoaderCollectionEvent;
	import net.pixlib.load.collection.PXQueueLoader;
	import net.pixlib.log.PXDebug;
	import net.pixlib.utils.PXHashCode;

	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * The PreprocessorParser class allow xml context pre processing 
	 * from xml context nodes.
	 * 
	 * <p>Context preprocessing order is :
	 * <ul>
	 * 	<li>ApplicationLoader.addProcessingMethod() job</li>
	 * 	<li>ApplicationLoader.addProcessor() job</li>
	 * 	<li>ContextPreprocessorLoader job</li>
	 * </ul></p>  
	 * 
	 * @example Basic Processor to insert a node into xml context
	 * <pre class="prettyprint">
	 * 
	 * package com.project
	 * {
	 * 	import net.pixlib.ioc.context.processor.ContextProcessor;
	 * 	
	 * 	public class TestProcessor implements ContextProcessor 
	 * 	{
	 * 		public function TestProcessor( ...args )
	 * 		{
	 * 		
	 * 		}
	 * 		
	 * 		public function process( context : * ) : *
	 * 		{			
	 * 			//do preprocessing here
	 * 			
	 * 			return context;
	 * 		}
	 * 		
	 * 		public function customMethod( context : * ) : *
	 * 		{
	 * 			return process( context );
	 * 		}
	 * 	}
	 * }
	 * </pre>
	 * 
	 * <p>Define preprocessing using xml context node</p>
	 * 
	 * @example Preprocessor class is in current application domain and processor is 
	 * <code>ContextProcessor</code> implementation :
	 * <pre class="prettyprint">
	 * 
	 * &lt;preprocessor type="com.project.TestProcessor" /&gt; 
	 * </pre>
	 * 
	 * @example Preprocessor class is not in current application domain, loads it 
	 * from passed-in url ( like DLL library ) :
	 * <pre class="prettyprint">
	 * 
	 * &lt;preprocessor type="com.project.TestProcessor" url="TestProcessorDLL.swf" /&gt; 
	 * </pre>
	 * 
	 * <p>Instance arguments are allowed, also <code>factory</code> and <code>singleton-access</code> too.</p>
	 * 
	 * @see net.pixlib.ioc.context.processor.ContextProcessor
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPreprocessorParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _loader : PXQueueLoader;		private var _mPreprocessor : PreprocessorMap;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** */
		protected var oBatch : PXContextProcessorBatch; 

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>ContextPreprocessorLoader</code>.
		 */
		public function PXPreprocessorParser( )
		{
			oBatch = new PXContextProcessorBatch();
			oBatch.addCommand(new PXResourceLocatorProcessor());
		}

		/**
		 * @inheritDoc
		 */
		override public function parse( ) : void
		{
			var processors : XMLList = getXMLContext().child(PXContextNameList.PREPROCESSOR).copy();
			delete getXMLContext()[ PXContextNameList.PREPROCESSOR ];
			
			_mPreprocessor = new PreprocessorMap();
			
			_loader = new PXQueueLoader();
			_loader.anticache = getApplicationLoader().anticache;
			
			var length : int = processors.length();
			for ( var i : int = 0;i < length; i++ ) _parseProcessor(processors[ i ]);
			
			if( _loader.empty )
			{
				fireOnCompleteEvent();
			}
			else
			{
				_loader.addEventListener(PXLoaderCollectionEvent.onItemLoadInitEVENT, onProcessorInit);
				_loader.addEventListener(PXLoaderCollectionEvent.onLoadErrorEVENT, onProcessorError);
				_loader.addEventListener(PXLoaderCollectionEvent.onLoadInitEVENT, onProcessorComplete);
				_loader.execute();
			}
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.PREPROCESSOR_PARSE_STATE;
		}

		/**
		 * Triggered when a pre processor dll is loaded.
		 */
		protected function onProcessorInit( event : PXLoaderCollectionEvent ) : void
		{
			event.stopImmediatePropagation();
			
			var identifier : String = event.loader.name;
			
			_activePreprocessor(identifier, _mPreprocessor.getNode(event.loader.name));
		}

		/**
		 * Triggered when error occurs during pre processor dll loading.
		 */
		protected function onProcessorError( event : PXLoaderCollectionEvent ) : void
		{
			event.stopImmediatePropagation();
			
			PXDebug.ERROR(this + ":: " + event.errorMessage);
		}

		/**
		 * Triggered when all context pre processors are loaded. 
		 */
		protected function onProcessorComplete( event : PXLoaderCollectionEvent ) : void
		{
			event.stopImmediatePropagation();
			
			if( oBatch.size() > 0)
			{
				oBatch.addEventListener(PXCommandEvent.onCommandEndEVENT, onBatchCompleteHandler);
				oBatch.execute(new PXContextProcessorEvent(PXContextProcessorEvent.onProcessEVENT, null, getXMLContext()));
			}
			else fireOnCompleteEvent();
		}

		/**
		 * Triggered when All processor Batch is complete.
		 */
		protected function onBatchCompleteHandler(event : PXContextProcessorEvent) : void
		{
			event.stopImmediatePropagation();
			
			oBatch.removeEventListener(PXCommandEvent.onCommandEndEVENT, onBatchCompleteHandler);
			oBatch.removeAll();
			
			setContextData(oBatch.getContext());
			
			fireOnCompleteEvent();
		}

		/**
		 * Triggered when all context pre processors are completed. 
		 */
		protected function fireOnCompleteEvent( ) : void
		{
			PXConstructorExpert.getInstance().clear();
			
			if( _loader )
			{
				_loader.removeEventListener(PXLoaderCollectionEvent.onItemLoadInitEVENT, onProcessorInit);
				_loader.removeEventListener(PXLoaderCollectionEvent.onLoadErrorEVENT, onProcessorError);
				_loader.removeEventListener(PXLoaderCollectionEvent.onLoadInitEVENT, onProcessorComplete);
				_loader.release();
			}
						if( _mPreprocessor ) _mPreprocessor.release();
			
			fireCommandEndEvent();
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------

		private function _parseProcessor( node : XML ) : void
		{
			var identifier : String = PXContextNameList.PREPROCESSOR + PXHashCode.nextKey;
			var url : String = PXAttributeUtils.getURL(node);
			
			_buildObject(identifier, node);
			
			if( url.length > 0 )
			{
				_mPreprocessor.registrer(identifier, node);
				
				var request : URLRequest = new URLRequest(url);
				var gLoader : PXGraphicLoader = new PXGraphicLoader(null, -1, false);
				
				_loader.add(gLoader, identifier, request, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			else
			{
				_activePreprocessor(identifier, node);
			}
		}	
		
		private function _activePreprocessor( id : String, node : XML ) : void
		{
			try
			{
				var cons : PXConstructor = PXConstructorExpert.getInstance().locate(id) as PXConstructor;
				if ( cons.arguments != null )  cons.arguments = PXPropertyExpert.getInstance().deserializeArguments(cons.arguments);
				
				var obj : Object = PXBuildFactory.getInstance().build(cons);
				
				if( obj is PXCommand )
				{
					oBatch.addCommand(obj as PXCommand);
				}
				else 
				{
					PXDebug.ERROR(this + ":: preprocessor type is not compliant : " + PXAttributeUtils.getType(node));
				}
			}
			catch( e : Error )
			{
				PXDebug.ERROR(this + "::" + e.message);
			}
			finally
			{
				PXConstructorExpert.getInstance().unregister(id);
			}
		}

		private function _buildObject( id : String, node : XML ) : void
		{
			var type : String = PXAttributeUtils.getType(node);
			var args : Array = PXXMLUtils.getArguments(node, PXContextNameList.ARGUMENT, type);
			var factory : String = PXAttributeUtils.getFactoryMethod(node);
			var singleton : String = PXAttributeUtils.getSingletonAccess(node);
			
			if(type == PXContextTypeList.STRING) PXDebug.ERROR( "Preprocessor node must have 'type' attribute", this);
			
			if ( args != null )
			{
				var length : int = args.length;
				
				for ( var i : uint = 0;i < length; i++ )
				{
					var obj : Object = args[ i ];
					var prop : PXProperty = PXPropertyExpert.getInstance().buildProperty(id, obj.name, obj.value, obj.type, obj.ref, obj.method);
					args[ i ] = prop;
				}
			}
			
			PXConstructorExpert.getInstance().register(id, new PXConstructor(id, type, args, factory, singleton));
		}
	}
}

import net.pixlib.collections.PXHashMap;

internal class PreprocessorMap
{
	private var _map : PXHashMap;

	
	public function PreprocessorMap( )
	{
		_map = new PXHashMap();
	}

	public function registrer( id : String, node : XML ) : void
	{
		_map.put(id, node);
	}

	public function getNode( id : String ) : XML
	{
		return _map.get(id);
	}

	public function release( ) : void
	{
		_map.clear();
		_map = null;
	}
}
