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
package net.pixlib.ioc.structures
{
	import net.pixlib.log.PXDebug;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXMethodCallResult 
	{
		/** @private */
		private var _result : *;

		
		/**
		 * Returns stored method result.
		 */
		public function get result( ) : *
		{
			return _result;	
		}

		/**
		 * 
		 * @param	func 	Function to execute
		 * @param	...agrs	arguments to pass to method execution
		 */
		public function PXMethodCallResult( func : Function, ...args)
		{
			try
			{
				_result = func.apply(null, args);
			}
			catch(e : Error)
			{
				PXDebug.ERROR("Call failed." + e.message, this);
				_result = null;
			}
		}
	}
}
