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

	/**
	 * @author Romain Ecarnot
	 */
	public class PXMethodProcessor extends PXAbstractContextProcessor 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _method : Function;
		private var _arguments : Array;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		public function PXMethodProcessor(method : Function, args : Array = null)
		{
			super();
			
			_method = method;
			_arguments = args;
		}
		
		override protected function processContext() : void
		{
			setContext(_method.apply(this, [getContext()].concat(_arguments)));
		}
	}
}
