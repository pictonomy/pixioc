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
package net.pixlib.ioc.assembler
{
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilder;

	import flash.net.URLRequest;

	/**
	 * @author Francis Bourre
	 */
	public interface PXApplicationAssembler
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		function get displayObjectBuilder() : PXDisplayObjectBuilder;
		
		function set displayObjectBuilder(value : PXDisplayObjectBuilder) : void;
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		function registerID(ID : String) : Boolean;

		function buildRoot(ID : String) : void;
		
		function buildDisplayObject(ID : String,
									parentID : String, 
									url : URLRequest = null,
									isVisible : Boolean = true,
									type : String = null	) : void;

		function buildDLL( url : URLRequest) : void;

		/**
		 * Builds <code>Resource</code> object.
		 * 
		 * @param	ID				Registration ID.
		 * @param	url				File URL.
		 * @param	type			(optional) Resource type : 'binary' or 'text'
		 * @param	deserializer	(optional) Resource content deserializer
		 */	
		function buildResource(				id : String,
											url : URLRequest,
											type : String = null,
											deserializer : String = null,											locator : String = null		) : void;

		function buildProperty( 			ownerID : String, 
											name : String = null, 
											value : String = null, 
											type : String = null, 
											ref : String = null, 
											method : String = null	) : void;

		function buildObject( 				id : String, 
											type : String = null, 
											args : Array = null, 
											factory : String = null, 
											singleton : String = null  ) : void;

		function buildMethodCall( 			id : String, 
											methodCallName : String, 
											args : Array = null 	) : void;

		function buildChannelListener( 		id : String, 
											channelName : String, 
											args : Array = null 	) : void;
	}
}