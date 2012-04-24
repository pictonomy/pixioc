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
	import net.pixlib.core.PXValueObject;
	import net.pixlib.log.PXStringifier;

	import flash.net.URLRequest;

	/**
	 * <p>Value object to store import configuration defined in 
	 * IoC context.</p>
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXImport implements PXValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Include file url.
		 * 
		 * @default null
		 */
		public var url : URLRequest;

		/**
		 * Include based container for display tree.
		 * 
		 * @default null
		 */
		public var rootRef : String;

		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */			
		public function PXImport(	url : URLRequest, rootRef : String ) 
		{
			this.url = url;			this.rootRef = rootRef;		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PXStringifier.process( this ) + "(" + "url:" + url + ", " + "rootRef:" + rootRef + ") ";		}
	}
}