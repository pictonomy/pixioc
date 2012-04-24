/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */package net.pixlib.ioc.parser.factory.xml {	import net.pixlib.ioc.core.PXContextNameList;	
	
	/**	 * XML Utilities methods.	 * 	 * @author Romain Ecarnot	 */	public final class PXXMLUtils 	{		//--------------------------------------------------------------------		// Public API		//--------------------------------------------------------------------						public static function getArguments( xml : XML, nodeName : String, type : String = null ) : Array		{			var args : Array = new Array( );			var argList : XMLList = xml.child( nodeName );			var length : int = argList.length( );			if ( length > 0 )			{				for ( var i : int = 0; i < length ; i++ ) 				{					var xmlList : XMLList = argList[ i ].attributes( );					if ( xmlList.length( ) > 0 ) args.push( getAttributes( xmlList ) );				}			} 			else			{				var value : String = PXAttributeUtils.getValue( xml );				if ( value != null ) args.push( { type:type, value:value } );			}						return args;		}		public static function getItems( xml : XML ) : Array		{						var args : Array = new Array( );			var itemList : XMLList = xml.child( PXContextNameList.ITEM );			var length : int = itemList.length( );			if ( length > 0 )			{				for ( var i : int = 0; i < length ; i++ ) 				{					var keyList : XMLList = (itemList[ i ].child( PXContextNameList.KEY ) as XMLList).attributes( );					var valueList : XMLList = (itemList[ i ].child( PXContextNameList.VALUE ) as XMLList).attributes( );					if ( keyList.length( ) > 0 ) args.push( {key:getAttributes( keyList ), value:getAttributes( valueList )} );				}			}			return args;		}				public static function getAttributes( attributes : XMLList ) : Object		{			var length : int = attributes.length( );			var obj : Object = {};			for ( var j : int = 0; j < length ; j++ ) obj[ String( attributes[j].name( ) ) ] = attributes[j];			return obj;		}										//--------------------------------------------------------------------		// Private implementation		//--------------------------------------------------------------------						/**		 * @private		 */		function PXXMLUtils(  ) { 	}	}}