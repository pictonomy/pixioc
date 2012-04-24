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

	/**
	 * @author Francis Bourre
	 */
	final public class PXContextTypeList
	{
		static public var DEFAULT 		: String = "Default";
		static public var STRING 		: String = "String";
		static public var NUMBER 		: String = "Number";
		static public var INT 			: String = "int";
		static public var UINT 			: String = "uint";
		static public var BOOLEAN 		: String = "Boolean";
		static public var ARRAY 		: String = "Array";
		static public var OBJECT 		: String = "Object";
		static public var INSTANCE 		: String = "Instance";
		static public var SPRITE 		: String = "flash.display.Sprite";
		static public var MOVIECLIP 	: String = "flash.display.MovieClip";		static public var TEXTFIELD 	: String = "flash.text.TextField";
		static public var NULL 			: String = "null";		static public var DICTIONARY 	: String = "Dictionary";		static public var CLASS 		: String = "Class";		static public var XML 			: String = "XML";		static public var FUNCTION 		: String = "Function";
		
		function PXContextTypeList()
		{
		}
	}
}