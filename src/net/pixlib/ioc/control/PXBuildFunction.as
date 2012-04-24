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
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXValueObjectEvent;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.ioc.assembler.locator.PXConstructorExpert;
	import net.pixlib.utils.PXObjectUtils;

	import flash.events.Event;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildFunction extends PXAbstractCommand
	{
		override protected function onExecute( event : Event = null ) : void
		{
			var constructor : PXConstructor = (event as PXValueObjectEvent).value as PXConstructor;

			var method : Function;
			var msg : String;
			
			var args : Array = ( constructor.arguments[ 0 ] ).split(".");
			var targetID : String = args[ 0 ];
			var path : String = args.slice(1).join(".");
			
			if ( !PXCoreFactory.getInstance().isRegistered(targetID) )
				PXConstructorExpert.getInstance().buildObject(targetID);
			
			var target : Object = PXCoreFactory.getInstance().locate(targetID);

			try
			{
				method = PXObjectUtils.evalFromTarget(target, path) as Function;
			} catch ( error : Error )
			{
				msg = error.message;
				msg += " " + this + ".execute() failed on " + target + " with id '" + targetID + "'. ";
				msg += path + " method can't be found.";
				throw new PXNoSuchElementException(msg, this);
			}

			constructor.result = method;
			fireCommandEndEvent();
		}
	}
}