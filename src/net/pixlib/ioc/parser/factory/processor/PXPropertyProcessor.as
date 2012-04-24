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
	import net.pixlib.log.PXDebug;
	import net.pixlib.utils.PXFlashVars;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXPropertyProcessor extends PXAbstractContextProcessor 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _name : String;
		private var _value : Object;		private var _varID : String;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		public function PXPropertyProcessor(name : String, value : *, flashvarName : String = null)
		{
			super();
			
			_name = "${" + name + "}";
			_value = value;
			_varID = flashvarName;
		}

		/**
		 * @inheritDoc
		 */
		override protected function processContext() : void
		{
			var src : String = String(oEvent.getContext());
			
			var replaceWith : String = String(_value);
			
			if( _varID != null )
			{
				if( PXFlashVars.getInstance().isRegistered(_varID))
				{
					replaceWith = PXFlashVars.getInstance().getString(_varID);
				}
				else
				{
					PXDebug.ERROR( "Flashvar named '" + _varID + "' is not registered.", this);
				}
			}
			
			src = src.split(_name).join(replaceWith);
			
			setContext(src);
			
			fireCommandEndEvent();
		}
	}
}
