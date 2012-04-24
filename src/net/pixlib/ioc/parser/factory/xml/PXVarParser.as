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
package net.pixlib.ioc.parser.factory.xml 
{
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.ioc.control.PXBuildFactory;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.exceptions.PXNullIDException;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.utils.PXFlashVars;

	/**
	 * Parses <code>var</code> node from IoC XML Context and registers 
	 * values into the FlashVars data model.
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXVarParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
					
		/**
		 * Creates instance.
		 */
		public function PXVarParser(  )
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function parse( ) : void
		{
			var varList : XMLList = getXMLContext().child(PXContextNameList.VAR);	
			for each( var node : XML in varList )
			{
				var id : String = node.@id.toString();
				var result : *;
				
				if( id != null && id.length > 0)
				{
					result = PXBuildFactory.getInstance().build( new PXConstructor( node.@id.toString(), node.@type.toString(), [ node.@value.toString() ] ) );
					
					PXFlashVars.getInstance().register(node.@id.toString(), result);				}
				else
				{
					throw new PXNullIDException("encounters parsing error with '" + node.name() + "' node. You must set an id attribute.", this);
				}
			}
			
			delete getXMLContext()[ PXContextNameList.VAR ];
			
			fireCommandEndEvent();
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------

		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.VAR_PARSE_STATE;
		}
	}
}
