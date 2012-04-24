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
package net.pixlib.ioc.assembler.locator 
{
	import net.pixlib.events.PXBasicEvent;

	/**
	 * @author Francis Bourre
	 */
	public class PXPropertyEvent 
		extends PXBasicEvent
	{
		static public const onBuildPropertyEVENT : String = "onBuildProperty";

		protected var sID 			: String;		protected var oProperty 	: PXProperty;

		public function PXPropertyEvent( eventType : String, id : String, property : PXProperty = null )
		{
			super( eventType );

			sID = id;
			oProperty = property;
		}
		
		public function getExpertID() : String
		{
			return sID;
		}

		public function getProperty() : PXProperty
		{
			return oProperty;
		}

		public function getPropertyOwnerID() : String
		{
			return oProperty.ownerID;
		}
		
		public function getPropertyName() : String
		{
			return oProperty.name;
		}
		
		public function getPropertyValue() : String
		{
			return oProperty.value;
		}
		
		public function getPropertyType() : String
		{
			return oProperty.type;
		}

		public function getPropertyRef() : String
		{
			return oProperty.ref;
		}
		
		public function getPropertyMethod() : String
		{
			return oProperty.method;
		}
	}
}