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

package net.pixlib.ioc.runner 
{
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.ioc.load.PXApplicationLoaderEvent;
	import net.pixlib.ioc.load.PXApplicationLoaderListener;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.log.PXLogManager;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXTraceLayout;

	/**
	 * IoC Application runner.
	 * 
	 * <p>This dedicated runner adds Logging rules.</p>
	 * 
	 * @see #initLogger()
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXDefaultApplicationRunner extends PXBasicApplicationRunner implements PXApplicationLoaderListener
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** IoC engine state name. */
		protected var oState : String = "IoC";

		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function PXDefaultApplicationRunner() 
		{
			
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationState(event : PXApplicationLoaderEvent) : void
		{
			oState = event.state;
			
			PXDebug.DEBUG("[IoC] run " + oState + " task", this);
			
			if( oState == PXApplicationLoaderState.COMPLETE_STATE )
			{
				if(oLoader) oLoader.removeListener(this);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function onCommandStart( event : PXCommandEvent ) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onCommandEnd( event : PXCommandEvent ) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationLoadStart(event : PXApplicationLoaderEvent) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationParsed(event : PXApplicationLoaderEvent) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationObjectsBuilt(event : PXApplicationLoaderEvent) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationChannelsAssigned(event : PXApplicationLoaderEvent) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationMethodsCalled(event : PXApplicationLoaderEvent) : void
		{
			logStep(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onApplicationInit(event : PXApplicationLoaderEvent) : void
		{
			logStep(event);
			
			onApplicationInitHandler(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadStart(event : PXLoaderEvent) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadInit(event : PXLoaderEvent) : void
		{
			PXDebug.DEBUG(getLoaderString(event), this);
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadProgress(event : PXLoaderEvent) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadTimeOut(event : PXLoaderEvent) : void
		{
			PXDebug.ERROR("[" + oState + "] " + event.errorMessage, this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function onLoadError(event : PXLoaderEvent) : void
		{
			PXDebug.ERROR("[" + oState + "] " + event.errorMessage, this);
		}

		
		//-------------------------------------------------------------------------
		// Protected methods
		//-------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function preprocess() : void
		{
			super.preprocess();
			
			initLogger();
			
			oLoader.addListener(this);
		}
		
		/**
		 * Adds <code>TraceLayout</code> logging target to Palmer LogManager.
		 * 
		 * <p>Overrides this method to define own logging logic.</p>
		 */
		protected function initLogger() : void
		{
			PXLogManager.getInstance().addLogListener(PXTraceLayout.getInstance());
		}
		
		/**
		 * @private
		 */
		protected function logStep( event : PXCommandEvent ) : void
		{
			PXDebug.DEBUG("[IoC] pass " + event.type, this);
		}

		/**
		 * @private
		 */
		protected function getLoaderString( event : PXLoaderEvent ) : String
		{
			return "[" + oState + "] " + event.type + "( " + formatURL(event) + " ) ";	
		}

		/**
		 * @private
		 */
		protected function formatURL( event : PXLoaderEvent ) : String
		{
			if( event.loader != null )
			{
				var url : String = event.loader.request.url;
				
				if(url.indexOf("?") > -1) return  url.substring(0, url.indexOf("?"));
				return url;
			}
			else return "";	
		}
		
		/**
		 * @private
		 */
		protected function formatPercent( event : PXLoaderEvent ) : String
		{
			var num : Number = event.percentLoaded;
			var diff : Number = 3 - num.toString().length;
			var result : String = "";
			if( diff > 0 ) for( var i : Number = 0;i < diff; i++ ) result += "0";
			return result + num;
		}
	}
}	