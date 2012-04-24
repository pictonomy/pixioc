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
package net.pixlib.ioc.control 
{
	import net.pixlib.commands.PXAbstractCommand;
	import net.pixlib.events.PXValueObjectEvent;
	import net.pixlib.ioc.assembler.locator.PXConstructor;

	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildClass extends PXAbstractCommand
	{
		override protected function onExecute( event : Event = null ) : void 
		{
			var constructor : PXConstructor = (event as PXValueObjectEvent).value as PXConstructor;

			var clazz : Class;
			var msg : String;
			var args : Array = constructor.arguments;

			var qualifiedClassName : String = "";
			if ( args != null && args.length > 0 ) qualifiedClassName = ( args[0] ).toString();

			try
			{
				clazz = getDefinitionByName( qualifiedClassName ) as Class;

			} catch ( error : Error )
			{
				msg = error.message;
				msg += " '" + qualifiedClassName + "' is not available in current domain";
				logger.fatal( msg, this );
			}

			constructor.result = clazz;
			fireCommandEndEvent();
		}
	}
}