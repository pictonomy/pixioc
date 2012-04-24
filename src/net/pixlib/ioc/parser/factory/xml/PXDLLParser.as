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
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.load.PXApplicationLoaderState;

	import flash.net.URLRequest;

	/**
	 * @author Francis Bourre
	 */
	public class PXDLLParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */	
		public function PXDLLParser(  )
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse( ) : void
		{
			var list : XMLList = getXMLContext().child( PXContextNameList.DLL );	
			var length : int = list.length();
			for ( var i : int = 0; i < length; i++ ) parseNode( list[ i ] );
			delete getXMLContext()[ PXContextNameList.DLL ];
			
			fireCommandEndEvent();
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.DLL_PARSE_STATE;
		}
		
		protected function parseNode( node : XML ) : void
		{
			getAssembler().buildDLL( new URLRequest( PXAttributeUtils.getURL( node ) ) );
		}	}}