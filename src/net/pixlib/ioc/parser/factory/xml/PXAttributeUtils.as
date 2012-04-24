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
	import net.pixlib.ioc.core.PXContextAttributeList;
	import net.pixlib.ioc.core.PXContextTypeList;

	/**
	 * @author Francis Bourre
	 */
	public class PXAttributeUtils
	{	
		static public function getID( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.ID );
		}
		
		static public function getType( xml : XML ) : String
		{
			var type : String = xml.attribute( PXContextAttributeList.TYPE );
			return type ? type : PXContextTypeList.STRING;
		}
		
		static public function getDisplayType( xml : XML ) : String
		{
			var type : String = xml.attribute( PXContextAttributeList.TYPE );
			return type ? type : PXContextTypeList.SPRITE;
		}

		static public function getName( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.NAME );
		}

		static public function getRef( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.REF );
		}

		static public function getValue( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.VALUE ) || null;
		}

		static public function getURL( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.URL );
		}

		static public function getVisible( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.VISIBLE );
		}

		static public function getFactoryMethod( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.FACTORY ) || null;
		}

		static public function getSingletonAccess( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.SINGLETON_ACCESS ) || null;
		}

		static public function getMethod( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.METHOD );
		}
		
		static public function getDelay( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.DELAY );
		}

		static public function getDeserializerClass( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.DESERIALIZER_CLASS ) || null;
		}		
		
		static public function getLocator( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.LOCATOR ) || null;
		}
		
		/**
		 * Returns <code>root-ref</code> attibute value.
		 */
		public static function getRootRef( xml : XML ) : String
		{
			return xml.attribute( PXContextAttributeList.ROOT_REF );
		}
		
		/**
		 * 
		 */
		public static function getAttribute( xml : XML, attName : String ) : String
		{
			return xml.attribute( attName );	
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
			
		/** @private */
		function PXAttributeUtils()
		{
		}
	}
}

internal class ConstructorAccess{}