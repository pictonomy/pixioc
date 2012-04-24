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
package net.pixlib.ioc.assembler.builder
{
	import net.pixlib.core.PXValueObject;
	import net.pixlib.ioc.core.PXContextTypeList;
	import net.pixlib.log.PXStringifier;

	import flash.net.URLRequest;

	/**
	 * @author Francis Bourre
	 */
	public class PXDisplayObjectInfo implements PXValueObject
	{
		public var ID : String;
		public var parentID : String;
		public var isVisible : Boolean;
		public var type : String;
		public var url : URLRequest;

		protected var aChilds : Array;

		
		public function PXDisplayObjectInfo( ID : String, 
											parentID : String = null, 
											isVisible : Boolean = true, 
											url : URLRequest = null, 
											type : String = null )
		{
			this.ID = ID;
			this.parentID = parentID;
			this.isVisible = isVisible;
			this.type = (type == null) ? PXContextTypeList.MOVIECLIP : type;
			this.url = url;
			aChilds = new Array();
		}

		public function addChild( o : PXDisplayObjectInfo ) : void
		{
			aChilds.push(o);
		}

		public function getChild() : Array
		{
			return aChilds.concat();
		}

		public function hasChild() : Boolean
		{
			return getNumChild() > 0;
		}

		public function getNumChild() : int
		{
			return aChilds.length;
		}

		public function isEmptyDisplayObject() : Boolean
		{
			return ( url == null );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			var src : String = " ";
			src += "ID:" + ID + ", ";			src += "url:" + url + ", ";
			src += "parentID:" + parentID + ", ";			src += "isVisible:" + isVisible + ", ";			src += "url:" + type + ", ";			src += "hasChild:" + hasChild() + ", ";			src += "numChild:" + getNumChild();
			
			return PXStringifier.process(this) + src;
		}
	}
}
