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
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.ioc.assembler.locator.PXConstructorExpert;
	import net.pixlib.utils.PXObjectUtils;

	import flash.events.Event;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildRef extends PXAbstractCommand
	{
		override protected function onExecute( event : Event = null ) : void
		{
			var constructor : PXConstructor = (event as PXValueObjectEvent).value as PXConstructor;

			var key : String = constructor.ref;
			
			if ( key.indexOf(".") != -1 ) key = String((key.split(".")).shift());
			
			if ( !(PXCoreFactory.getInstance().isRegistered(key)) )
			{
				PXConstructorExpert.getInstance().buildObject(key);
			}		
			constructor.result = PXCoreFactory.getInstance().locate(key);
			
			if ( constructor.ref.indexOf(".") != -1 )
			{
				var args : Array = constructor.ref.split(".");
				args.shift();
	                
				var tmp : Object = PXObjectUtils.evalFromTarget(constructor.result, args.join("."));
				var result : * = tmp;
	               
				constructor.result = result;
			}
			
			fireCommandEndEvent();
		}
	}
}