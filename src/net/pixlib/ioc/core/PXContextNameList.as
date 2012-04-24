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
 
package net.pixlib.ioc.core
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.log.PXStringifier;

	/**
	 * @author Francis Bourre
	 */
	final public class PXContextNameList
	{
		static private var _oI 					: PXContextNameList;
		
		static public var BEANS 				: String = "beans";
		static public var PREPROCESSOR 			: String = "preprocessor";
		static public var PROPERTY 				: String = "property";
		static public var ARGUMENT 				: String = "argument";
		static public var ROOT 					: String = "root";
		static public var APPLICATION_LOADER 	: String = "application-loader";
		static public var VAR					: String = "var";
		static public var LIB 					: String = "lib";		static public var DLL 					: String = "dll";
		static public var METHOD_CALL 			: String = "method-call";
		static public var LISTEN 				: String = "listen";
		static public var ITEM 					: String = "item";
		static public var KEY 					: String = "key";
		static public var VALUE 				: String = "value";
		static public var IMPORT 				: String = "import";
		static public var RSC 					: String = "rsc";		static public var EVENT 				: String = "event";
		
		private var _mNodeName : PXHashMap;

		static public function getInstance() : PXContextNameList
		{
			if ( !(PXContextNameList._oI is PXContextNameList) ) PXContextNameList._oI = new PXContextNameList();
			return PXContextNameList._oI;
		}

		function PXContextNameList()
		{
			init();
		}

		public function init() : void
		{
			_mNodeName = new PXHashMap();

			addNodeName( PXContextNameList.BEANS, "" );
			addNodeName( PXContextNameList.PROPERTY, "" );
			addNodeName( PXContextNameList.ARGUMENT, "" );
			addNodeName( PXContextNameList.ROOT, "" );
			addNodeName( PXContextNameList.APPLICATION_LOADER, "" );
			addNodeName( PXContextNameList.METHOD_CALL, "" );
			addNodeName( PXContextNameList.LISTEN, "" );
			
			addNodeName( PXContextNameList.VAR, "" );			addNodeName( PXContextNameList.DLL, "" );			addNodeName( PXContextNameList.RSC, "" );			addNodeName( PXContextNameList.IMPORT, "" );			addNodeName( PXContextNameList.LIB, "" );			addNodeName( PXContextNameList.PREPROCESSOR, "" );
			
			addNodeName( "attribute", "" );
		}

		public function addNodeName( nodeName : String, value:* ) : void
		{
			_mNodeName.put( nodeName, value );
		}

		public function nodeNameIsReserved( nodeName:* ) : Boolean
		{
			return _mNodeName.containsKey( nodeName );
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