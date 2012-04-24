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
package net.pixlib.ioc.parser.factory.processor 
{
	import net.pixlib.commands.PXAbstractCommand;
	import net.pixlib.log.PXDebug;

	import flash.events.Event;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXAbstractContextProcessor extends PXAbstractCommand
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** */
		protected var oEvent : PXContextProcessorEvent; 
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Releases instance.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		public function release() : void
		{
			oEvent = null;
			oEB.removeAllListeners();
			oEB = null;
		}

		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 *
		 */
		final protected function setContext(context : *) : void
		{
			oEvent.setContext(context);	
			
			fireCommandEndEvent();
		}

		/**
		 *
		 */
		final protected function getContext() : *
		{
			return oEvent.getContext();
		}

		/**
		 * @inheritDoc
		 */
		final override protected function onExecute( event : Event = null ) : void
		{
			if( event is PXContextProcessorEvent)
			{
				try
				{
					oEvent = PXContextProcessorEvent(event);
					processContext();
				}
				catch(e : Error)
				{
					PXDebug.ERROR( "processing error :: " + e.message, this);
					fireCommandEndEvent();
				}
			}
			else
			{
				logger.error("Processor event is not compliant", this);
				fireCommandEndEvent();
			}
		}
		
		/**
		 *
		 */
		protected function processContext() : void
		{
			var msg : String = this + ".processContext() must be implemented in concrete class, either processing is bypassed.";
			logger.error(msg, this);
			
			setContext(getContext());
		}
				
		//--------------------------------------------------------------------
		// Private methods
		//--------------------------------------------------------------------

		function PXAbstractContextProcessor() 
		{
			super();
		}		
	}
}
