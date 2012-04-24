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
 
package net.pixlib.ioc.display 
{
	import net.pixlib.ioc.load.PXApplicationLoaderEvent;
	import net.pixlib.ioc.load.PXApplicationLoaderListener;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.log.PXStringifier;

	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;

	/**	 * <p>Proxy to allow connection between <code>ApplicationLoaderListener</code> and 
	 * a generic Display Loader object.</p>
	 * 
	 * @see DisplayLoader
	 * @see AbstractDisplayLoader
	 * 
	 * @author Romain Ecarnot	 */	public class PXDisplayLoaderProxy implements PXApplicationLoaderListener
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _oTarget : Object;
		private var _oInfo : PXDisplayLoaderInfo;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance
		 * 
		 * @param	target	Display Loader object
		 * @param	info	Informations about Display loader callbacks.
		 */
		public function PXDisplayLoaderProxy( target : DisplayObjectContainer, info : PXDisplayLoaderInfo )
		{
			_oTarget = target;
			_oInfo = info;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onApplicationState(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.nameCallback, event.state );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onApplicationLoadStart(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.startCallback, cleanURL( event.applicationLoader.request ), event.applicationLoader.displayObjectBuilder.length );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onApplicationParsed(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.parsedCallback );
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationObjectsBuilt(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.objectsBuiltCallback );
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationChannelsAssigned(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.channelsAssignedCallback );
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationMethodsCalled(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.methodsCallCallback );
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationInit(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.completeCallback );
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadStart(event : PXLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.loadCallback, cleanURL( event.loader.request ) );
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadInit(event : PXLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.initCallback, cleanURL( event.loader.request ) );
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadProgress(event : PXLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.progressCallback, cleanURL( event.loader.request ), event.percentLoaded );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onLoadTimeOut(event : PXLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.timeoutCallback, cleanURL( event.loader.request )  + " timeout" );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onLoadError(event : PXLoaderEvent) : void
		{
			event.stopImmediatePropagation();
			
			call( _oInfo.errorCallback, event.errorMessage );
		}
		
		/**
		 * Returns string representation.
		 */
		public function toString(  ) : String
		{
			return PXStringifier.process( this ) + "\n" + _oInfo.toString( );
		}	
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Call passed-in callback on Display Loader target.
		 * 
		 * @param	callback	Method to call on target
		 * @param	...			Methods arguments
		 */
		protected function call( callback : String, ...args ) : void
		{
			if( callback.length > 0 && _oTarget.hasOwnProperty( callback ) )
			{
				_oTarget[callback].apply( _oTarget, args );
			}
		}
		
		/**
		 * Cleans passed-in <code>request</code> url removing anticache 
		 * informations if any.
		 */
		protected function cleanURL( request : URLRequest ) : String
		{
			return request.url.substring( 0, request.url.indexOf( "?" ) );
		}
	}}