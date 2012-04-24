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
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.load.PXGraphicLoader;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.collection.PXLoaderCollectionEvent;
	import net.pixlib.load.collection.PXQueueLoader;
	import net.pixlib.log.PXDebug;
	import net.pixlib.utils.PXHashCode;

	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXLibParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _oLoader : PXQueueLoader;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */	
		public function PXLibParser(  )
		{
		}

		/**
		 * 
		 */
		override public function parse( ) : void
		{
			var libXML : XMLList = getXMLContext( ).child( PXContextNameList.LIB );	
			var length : int = libXML.length( );
			
			_oLoader = new PXQueueLoader( );
			_oLoader.anticache = false;
			
			for ( var i : int = 0; i < length ; i++ ) 
			{
				var url : String = PXAttributeUtils.getURL( libXML[ i ] );
				
				_oLoader.add( new PXGraphicLoader( null, -1, false ), PXHashCode.nextKey + "_lib", new URLRequest( url ), new LoaderContext( false, ApplicationDomain.currentDomain ) );
			}
			
			if( !_oLoader.empty )
			{
				_oLoader.addEventListener( PXLoaderCollectionEvent.onItemLoadInitEVENT, onLibLoaded );
				_oLoader.addEventListener( PXLoaderCollectionEvent.onLoadErrorEVENT, onError );
				_oLoader.addEventListener( PXLoaderCollectionEvent.onLoadInitEVENT, onComplete );
				
				_oLoader.execute( );
			}
			else
			{
				onComplete( );
			}
		}
		
		/**
		 * 
		 */
		protected function onEvent( event : PXLoaderEvent ) : void
		{
			event.stopImmediatePropagation();
			
			PXDebug.FATAL( event.loader.request.url + " -> " + event.type );
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */
		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.LIB_PARSE_STATE;
		}

		/**
		 * 
		 */
		protected function onLibLoaded( event : PXLoaderCollectionEvent ) : void
		{
			event.stopImmediatePropagation();
			
			PXDebug.DEBUG( "[" + getState( ) + "] " + event.currentLoader.request.url + " loaded", this );
		}
		
		/**
		 * Triggered when error occurs during pre processor dll loading.
		 */
		protected function onError( event : PXLoaderCollectionEvent ) : void
		{
			event.stopImmediatePropagation();
			
			PXDebug.ERROR( "load(" + event.currentLoader.request.url + ")" + ":: " + event.errorMessage, this );
		}

		/**
		 * Triggered when all context pre processors are loaded. 
		 */
		protected function onComplete( event : PXLoaderEvent = null ) : void
		{
			if(event) event.stopImmediatePropagation();
			
			_oLoader.removeEventListener( PXLoaderCollectionEvent.onLoadErrorEVENT, onError );
			_oLoader.removeEventListener( PXLoaderCollectionEvent.onLoadInitEVENT, onComplete );
			_oLoader.release();
			_oLoader = null;
			
			delete getXMLContext( )[ PXContextNameList.LIB ];
			
			fireCommandEndEvent( );
		}	}}