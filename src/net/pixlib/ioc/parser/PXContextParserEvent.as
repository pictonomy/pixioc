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
 
package net.pixlib.ioc.parser 
{
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.ioc.load.PXApplicationLoader;

	/**
	 * @author Francis Bourre
	 */
	public class PXContextParserEvent extends PXCommandEvent
	{
		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _oLoader : PXApplicationLoader;
		private var _oContext : *;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		public function PXContextParserEvent( eventType : String, parser : PXContextParser = null, loader : PXApplicationLoader = null, rawContext : * = null )
		{
			super( eventType, parser );
			
			_oLoader = loader;
			_oContext = rawContext;
		}
		
		public function getContextParser() :PXContextParser
		{
			return target as PXContextParser;
		}
		
		public function getApplicationLoader( ) : PXApplicationLoader
		{
			return _oLoader;
		}
		
		public function getContextData( ) : *
		{
			return _oContext;
		}
	}
}
