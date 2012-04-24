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
 
package net.pixlib.ioc.parser.factory 
{
	import net.pixlib.commands.PXCommand;
	import net.pixlib.ioc.load.PXApplicationLoader;	

	/**
	 * @author Romain Ecarnot
	 */
	public interface PXParserCommand extends PXCommand
	{
		/**
		 * Returns application loader used in current application.
		 * 
		 * @return The application loader used in current application.
		 */
		function getApplicationLoader( ) : PXApplicationLoader;
		
		/**
		 * Returns current application context data.
		 * 
		 * @return The current application context data.
		 */
		function getContextData(  ) : *;
		
		/**
		 * Starts context data processing.
		 */
		function parse( ) : void;
	}
}
