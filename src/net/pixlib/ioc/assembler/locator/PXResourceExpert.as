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
	import net.pixlib.core.PXAbstractLocator;

	/**
	 * The ResourceExpert class is a locator for 
	 * <code>Resource</code> object.
	 * 
	 * @see Resource
	 * 
	 * @author Francis Bourre
	 */
	public class PXResourceExpert extends PXAbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : PXResourceExpert;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance of ResourceExpert class.
		 */
		public static function getInstance() : PXResourceExpert 
		{
			if (!_oI) _oI = new PXResourceExpert(); 
			
			return _oI;
		}
		
		/**
		 * Release instance.
		 */
		public static  function release() : void
		{
			if(_oI) _oI.release();			_oI = null;
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PXResourceExpert()
		{
			super( PXResource, null, null );
		}
				
	}
}
