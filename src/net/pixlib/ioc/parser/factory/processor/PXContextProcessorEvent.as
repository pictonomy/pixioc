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
	import net.pixlib.commands.PXCommand;
	import net.pixlib.events.PXCommandEvent;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXContextProcessorEvent extends PXCommandEvent 
	{
		//--------------------------------------------------------------------
		// Event types
		//--------------------------------------------------------------------
		
		public static const onProcessEVENT : String = "onProcess";
				public static const onCommandEndEVENT : String = PXCommandEvent.onCommandEndEVENT;
		
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _oContext : *;
				
				
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates event.
		 */
		public function PXContextProcessorEvent(eventType : String, processor : PXCommand, context : *)
		{
			super(eventType, processor);
			
			_oContext = context;
		}
		
		public function setContext(context : *) : void
		{
			_oContext = context;
		}

		/**
		 *
		 */
		public function getContext() : *
		{
			return _oContext;
		}
	}
}
