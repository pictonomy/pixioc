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
	final public class PXContextAttributeList
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
				
		static public const ID 								: String = "id";
		static public const TYPE 							: String = "type";
		static public const NAME 							: String = "name";
		static public const REF 							: String = "ref";
		static public const VALUE 							: String = "value";
		static public const FACTORY 						: String = "factory";
		static public const URL 							: String = "url";
		static public const VISIBLE 						: String = "visible";
		static public const SINGLETON_ACCESS 				: String = "singleton-access";
		static public const METHOD 							: String = "method";
		static public const DELAY 							: String = "delay";		static public const DESERIALIZER_CLASS 				: String = "deserializer-class";		static public const LOCATOR 						: String = "locator";
		public static const ROOT_REF 						: String = "root-ref";		
		//Loader callbacks attributes
		static public const START_CALLBACK					: String = "start-callback";		static public const NAME_CALLBACK 					: String = "name-callback";
		static public const LOAD_CALLBACK	 				: String = "load-callback";			static public const PROGRESS_CALLBACK	 			: String = "progress-callback";			static public const TIMEOUT_CALLBACK 				: String = "timeout-callback";			static public const ERROR_CALLBACK 					: String = "error-callback";			static public const INIT_CALLBACK 					: String = "init-callback";	
		static public const PARSED_CALLBACK 				: String = "parsed-callback";	
		static public const OBJECTS_BUILT_CALLBACK 			: String = "objects-built-callback";	
		static public const CHANNELS_ASSIGNED_CALLBACK 		: String = "channels-assigned-callback";	
		static public const METHODS_CALL_CALLBACK 			: String = "methods-call-callback";	
		static public const COMPLETE_CALLBACK 				: String = "complete-callback";	
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
				
		
		/** @private */
		function PXContextAttributeList( )
		{
			
		}
	}
}