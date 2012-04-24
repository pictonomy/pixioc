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
package net.pixlib.ioc.assembler.locator 
{
	import net.pixlib.log.PXStringifier;
	/**
	 * @author Francis Bourre
	 */
	public class PXDictionaryItem 
	{
		protected var pKey : PXProperty;
		protected var pValue : PXProperty;
		
		public var key : Object;
		public var value : Object;

		public function PXDictionaryItem ( key : PXProperty, value : PXProperty ) 
		{
			pKey = key;
			pValue = value;
		}

		public function getPropertyKey() : PXProperty
		{
			return pKey;
		}

		public function getPropertyValue() : PXProperty
		{
			return pValue;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PXStringifier.process( this ) + " [key:" + getPropertyKey() + ", value:" + getPropertyValue() + "]";
		}
	}
}
