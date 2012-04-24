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
package net.pixlib.ioc.control
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.commands.PXCommand;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXValueObjectEvent;
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.ioc.core.PXContextTypeList;
	import net.pixlib.log.PXStringifier;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildFactory
	{
		static private var _oI : PXBuildFactory = null;

		/**
		 * @return singleton instance of BuildFactory
		 */
		static public function getInstance() : PXBuildFactory 
		{
			if (!_oI) _oI = new PXBuildFactory();
			return _oI;
		}

		private var _mMap : PXHashMap;

		function PXBuildFactory()
		{
			init();
		}

		public function init() : void
		{
			_mMap = new PXHashMap();

			addType( PXContextTypeList.ARRAY, PXBuildArray );
			addType( PXContextTypeList.BOOLEAN, PXBuildBoolean );
			addType( PXContextTypeList.INSTANCE, PXBuildInstance );
			addType( PXContextTypeList.INT, PXBuildInt );
			addType( PXContextTypeList.NULL, PXBuildNull );
			addType( PXContextTypeList.NUMBER, PXBuildNumber );
			addType( PXContextTypeList.OBJECT, PXBuildObject );
			addType( PXContextTypeList.STRING, PXBuildString );
			addType( PXContextTypeList.UINT, PXBuildUint );
			addType( PXContextTypeList.DEFAULT, PXBuildString );
			addType( PXContextTypeList.DICTIONARY, PXBuildDictionary );
			addType( PXContextTypeList.CLASS, PXBuildClass );
			addType( PXContextTypeList.XML, PXBuildXML );
			addType( PXContextTypeList.FUNCTION, PXBuildFunction );
		}
		
		/**
		 * Adds new command to build a new object of type paased-in.
		 *
		 * @param	type	Object type to build
		 * @param	build	Command to use to build the object
		 */
		public function addType( type : String, build : Class ) : void
		{
			_mMap.put( type, build );
		}
		
		public function build( constructor : PXConstructor, id : String = null ) : *
		{
			var type : String = constructor.type;
			var cmdClass : Class = ( _mMap.containsKey( type ) ) ? _mMap.get( type ) as Class : _mMap.get( PXContextTypeList.INSTANCE ) as Class;
			var cmd : PXCommand = new cmdClass();
			cmd.execute( new PXValueObjectEvent( type, this, constructor ) );
			
			if ( id ) PXCoreFactory.getInstance().register( id, constructor.result );
			return constructor.result;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PXStringifier.process( this );
		}
	}
}