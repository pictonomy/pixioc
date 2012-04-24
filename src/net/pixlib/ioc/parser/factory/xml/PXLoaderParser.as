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
	import net.pixlib.ioc.core.PXContextAttributeList;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.display.PXDisplayLoaderInfo;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.load.PXGraphicLoader;
	import net.pixlib.load.PXLoader;
	import net.pixlib.load.PXLoaderEvent;

	import flash.net.URLRequest;

	/**
	 * @author Francis Bourre
	 */
	public class PXLoaderParser extends PXXMLParser
	{
		protected var bHasLoader : Boolean = false;
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		public function PXLoaderParser(  )
		{
		}
		
		override public function parse( ) : void
		{
			for each ( var node : XML in getXMLContext( )[ PXContextNameList.APPLICATION_LOADER ] ) parseNode( node );
			delete getXMLContext( )[ PXContextNameList.APPLICATION_LOADER ];
			
			if ( !bHasLoader ) fireCommandEndEvent( );
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------

		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.LOADER_PARSE_STATE;
		}

		protected function parseNode( node : XML ) : void
		{
			bHasLoader = true;
			
			var info : PXDisplayLoaderInfo = new PXDisplayLoaderInfo( 
				PXAttributeUtils.getID( node ), 
				new URLRequest( PXAttributeUtils.getURL( node ) ), 
				PXAttributeUtils.getAttribute( node, PXContextAttributeList.START_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.NAME_CALLBACK), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.LOAD_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.PROGRESS_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.TIMEOUT_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.ERROR_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.INIT_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.PARSED_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.OBJECTS_BUILT_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.CHANNELS_ASSIGNED_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.METHODS_CALL_CALLBACK ), 				PXAttributeUtils.getAttribute( node, PXContextAttributeList.COMPLETE_CALLBACK )
			);
			
			var loader : PXGraphicLoader = new PXGraphicLoader( null, -1, true );
			loader.addEventListener( PXLoaderEvent.onLoadInitEVENT, onDisplayLoaderInit, info );
			loader.addEventListener( PXLoaderEvent.onLoadErrorEVENT, onDisplayLoaderError );
			loader.addEventListener( PXLoaderEvent.onLoadTimeOutEVENT, onDisplayLoaderError );
			loader.load( info.url );
		}
		
		/**
		 * Triggered when display loader is loaded.
		 */
		protected function onDisplayLoaderInit( event : PXLoaderEvent, info : PXDisplayLoaderInfo ) : void
		{
			event.stopImmediatePropagation();
			
			var loader : PXGraphicLoader = event.loader as PXGraphicLoader;
			loader.target = getApplicationLoader( ).displayObjectBuilder.rootTarget;
			
			getApplicationLoader( ).setDisplayLoader( loader.displayObject, info );
			
			release( event );
			
			fireCommandEndEvent( );
		}
		
		protected function onDisplayLoaderError( event : PXLoaderEvent ) : void
		{
			event.stopImmediatePropagation();
			
			release( event );
			
			fireCommandEndEvent( );
		}
		
		protected function release( e : PXLoaderEvent ) : void
		{
			var loader : PXLoader = e.loader;
			loader.removeEventListener( PXLoaderEvent.onLoadInitEVENT, onDisplayLoaderInit );
			loader.removeEventListener( PXLoaderEvent.onLoadErrorEVENT, onDisplayLoaderError );
			loader.removeEventListener( PXLoaderEvent.onLoadTimeOutEVENT, onDisplayLoaderError );
		}
	}
}