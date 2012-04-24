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
	import net.pixlib.core.PXValueObject;
	import net.pixlib.log.PXStringifier;

	import flash.net.URLRequest;

	/**
	 * <p>Value object to store resource configuration defined in 
	 * xml context.</p>
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXResource implements PXValueObject
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Resource identifier.
		 * 
		 * @default null
		 */
		public var ID : String;
		
		/**
		 * Resource file url.
		 * 
		 * @default null
		 */
		public var url 	: URLRequest;
		
		/**
		 * Resource type.
		 * 
		 * @default null
		 */
		public var type	: String;
		
		/**
		 * Resource deserializer.
		 * 
		 * @default null
		 */
		public var deserializerClass : String;
		
		/**
		 * Resource locator to target for registration.
		 * 
		 * @default null
		 */
		public var locator : String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */			
		public function PXResource(	id 					: String, 
									url 				: URLRequest, 
									type 				: String 	= null,
									deserializerClass 	: String 	= null,
									locator				: String 	= null )
		{
			this.ID = id;
			this.url = url;			this.type = type;			this.deserializerClass = deserializerClass;			this.locator = locator;		}
		
		/**
		 * Returns <code>true</code> if a deserializer is associated with 
		 * current resource.
		 */
		public function hasDeserializer(  ) : Boolean
		{
			return deserializerClass != null;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PXStringifier.process( this ) 	+ "("
			+ "id:" 			+ ID 					+ ", "
			+ "url:" 			+ url 					+ ", "			+ "type:" 			+ url 					+ ", "			+ "deserializer:" 	+ deserializerClass		+ ")";
		}
	}
}