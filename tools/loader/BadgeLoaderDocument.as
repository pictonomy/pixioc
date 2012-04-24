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
 
package
{
	import com.bourre.ioc.display.AbstractDisplayLoader;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * Simple IoC Display Loader UI implementation.
	 * 
	 * @example IoC definition
	 * <pre class="prettyprint">
	 * 
	 * &lt;application-loader url="BadgeLoader.swf"
	 * 		    start-callback="onStartApplication"
	 * 		    name-callback="onNameCallback"
	 * 		    
	 * 		    load-callback="onLoadCallback"
	 * 		    progress-callback="onProgressCallback"
	 * 		    timeout-callback="onTimeoutCallback"
	 * 		    error-callback="onErrorCallback"
	 * 		    init-callback="onInitCallback"
	 * 		    
	 * 		    parsed-callback="onParsedCallback"
	 * 		    objects-built-callback="onBuiltCallback"
	 * 		    channels-assigned-callback="onChannelsCallback"
	 * 		    methods-call-callback="onMethodsCallback"
	 * 		    
	 * 		    complete-callback="onCompleteCallback" 
	 * /&gt;
	 * </pre>
	 * 
	 * @author Romain Ecarnot
	 */
	public class BadgeLoaderDocument extends AbstractDisplayLoader 
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/** Item progression bar. */
		public var mcItem : Sprite;
		
		/** Total progression bar. */
		public var mcTotal : Sprite;
		
		/** total / loaded items ratio textfield. */		public var txCount : TextField;				
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Contructor.
		 */		
		public function BadgeLoaderDocument()
		{
			super( );
			
			mcItem.scaleX = 0;
			mcTotal.scaleX = 0;
			
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}
		
		/**
		 * Triggered loading IoC engine step begin.
		 * 
		 * @param	url		Context url.
		 * @param	size	Total of item to load
		 */
		override public function onStartApplication( url : String, size : uint = 0 ) : void
		{
			super.onStartApplication( url, size );
			
			updateProgressText( );
		}
		
		/**
		 * Triggered when an item loading was finished.
		 * 
		 * @param	url	Current loaded item url.
		 */
		override public function onInitCallback( url : String ) : void
		{
			super.onInitCallback( url );
			
			updateProgressText( );
		}
		
		/**
		 * Triggered when 'complete-callback' is called from IoC engine.
		 */
		override public function onCompleteCallback( ) : void
		{
			super.onCompleteCallback( );
			
			stage.removeEventListener( Event.RESIZE, onResize );
			
			parent.removeChild( this );
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Updates total / loaded ratio textfield.
		 */
		protected function updateProgressText( ) : void
		{
			txCount.text = nLoaded + "/" + nTotal;			}
		
		/**
		 * Triggered when the current item loading state change.
		 * 
		 * @param	value	The current item loading progression value
		 */
		override protected function fireOnItemProgress( value : uint ) : void
		{
			mcItem.scaleX = value / 100;
		}
		
		/**
		 * Triggered when the total loading state change.
		 * 
		 * @param	value	The total loading progression value
		 */
		override protected function fireOnTotalProgress( value : uint ) : void
		{
			mcTotal.scaleX = value / 100;
		}		
		
		/**
		 * Triggered when the loader UI is added to main stage.
		 */
		protected function onAdded( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
						stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
				
			onResize();
			stage.addEventListener( Event.RESIZE, onResize );
		}
		
		/**
		 * Triggered when stage is resized.
		 */
		protected function onResize( event : Event = null ) : void
		{
			if( stage )
			{
				x = stage.stageWidth * 0.5 - width * 0.5;				y = stage.stageHeight * 0.5 - height * 0.5;
			}
		}
	}
}
