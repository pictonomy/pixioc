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
	import net.pixlib.commands.PXBatch;
	import net.pixlib.events.PXCommandEvent;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXContextProcessorBatch extends PXBatch 
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function PXContextProcessorBatch()
		{
			super();
		}
		
		/**
		 * Returns parsed context.
		 */
		public function getContext() : *
		{
			return PXContextProcessorEvent(eEvent).getContext();
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		final override protected function broadcastCommandEndEvent() : void
		{
			oEB.broadcastEvent(new PXContextProcessorEvent(PXCommandEvent.onCommandEndEVENT, this, PXContextProcessorEvent(eEvent).getContext()));
		}		
	}
}
