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
{	import flash.display.MovieClip;

	/**	 * Default implementation of display loader object.
	 * 
	 * <p>This implementations use loader callback definition in xml 
	 * context file as :
	 * <pre class="prettyprint lang-xml">
	 * &lt;application-loader url="loader.swf" 
	 *		start-callback="onStartApplication" 
	 *		name-callback="onNameCallback"
	 *	
	 *		load-callback="onLoadCallback"
	 *		progress-callback="onProgressCallback"
	 *		timeout_callback="onTimeoutCallback"
	 *		error-callback="onErrorCallback"
	 *		init-callback="onInitCallback"
	 *	
	 *		parsed-callback="onParsedCallback"
	 *		objects-built-callback="onBuiltCallback"
	 *		channels-assigned-callback="onChannelsCallback"
	 *		methods-call-callback="onMethodsCallback"
	 *	
	 *		complete-callback="onCompleteCallback"
	 * /&gt;</pre>
	 * </p>
	 * 
	 * <p>Extends class to customize loading renderer.</p>
	 * 
	 * @see DisplayLoader	 * @see DisplayLoaderProxy
	 * 
	 * @author Romain Ecarnot	 */	public class PXAbstractDisplayLoader extends MovieClip implements PXDisplayLoader
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Number of IoC elements to load. */
		protected var nTotal : uint;

		/** Number of loaded IoC elements. */		protected var nLoaded : uint;

		/** Number of erro during IoC elements loading. */
		protected var nError : uint;

		/** Total loading percent progression */
		protected var nPercent : uint;
		
		/** Item loading percent progression */
		protected var nBuffer : uint;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */		
		public function PXAbstractDisplayLoader()
		{
			nTotal = 0;
			nLoaded = 0;			nError = 0;
			nPercent = 0;
			nBuffer = 0;		}

		/**
		 * @inheritDoc
		 */
		public function onStartApplication( url : String, size : uint = 0 ) : void
		{
			nTotal = size;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onNameCallback( state : String ) : void
		{
			
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadCallback( url : String ) : void
		{
			nBuffer = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onProgressCallback( url : String, percent : Number ) : void
		{
			nBuffer = Math.floor( percent / nTotal );
						fireOnItemProgress( percent );
			fireOnTotalProgress( Math.min( 100, ( nPercent + nBuffer ) ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onTimeoutCallback( url : String ) : void
		{
			onErrorCallback( url );
		}
		
		/**
		 * @inheritDoc
		 */
		public function onErrorCallback( url : String ) : void
		{
			saveBuffer( Math.floor( 100 / nTotal ) );
			
			nError++;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onInitCallback( url : String ) : void
		{
			saveBuffer( nBuffer );
						
			nLoaded++;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onParsedCallback( ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onBuiltCallback( ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onChannelsCallback( ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onMethodsCallback( ) : void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCompleteCallback( ) : void
		{
			fireOnTotalProgress( 100 );
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Returns <code>true</code> if all context items are loaded.
		 * 
		 * @return <code>true</code> if all context items are loaded.
		 */
		protected function isSuccess(  ) : Boolean
		{
			return ( nTotal - nLoaded == 0 );
		}	
		
		/** 
		 * Saves item loading buffer to total loading value.
		 * 
		 * @param	value	Item progression value
		 */
		protected function saveBuffer( value : uint ) : void
		{
			nPercent += value;	
		}
		
		/**
		 * Triggered when the current item loading state change.
		 * 
		 * @param	value	The current item loading progression value
		 */
		protected function fireOnItemProgress( value : uint ) : void
		{
			if(!isNaN(value))
			{
				
			}
		}
		
		/**
		 * Triggered when the total loading state change.
		 * 
		 * @param	value	The total loading progression value
		 */
		protected function fireOnTotalProgress( value : uint ) : void
		{
			if(!isNaN(value))
			{
				
			}
		}
	}}