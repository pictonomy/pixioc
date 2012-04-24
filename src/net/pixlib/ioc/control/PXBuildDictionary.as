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
	import net.pixlib.ioc.assembler.locator.PXDictionaryItem;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildDictionary extends PXAbstractCommand
	{
		override protected function onExecute( event : Event = null ) : void
		{
			var constructor : PXConstructor = (event as PXValueObjectEvent).value as PXConstructor;

			var dico : Dictionary = new Dictionary();
			var args : Array = constructor.arguments;

			if ( args.length <= 0 ) 
			{
				logger.warn( this + ".build(" + args + ") returns an empty Dictionary.", this );

			} else
			{
				var length : int = args.length;

				for ( var i : int = 0; i < length; i++ )
				{
					var item : Object = args[ i ] as PXDictionaryItem;

					if (item.key != null)
					{
						dico[ item.key ] = item.value;

					} else
					{
						logger.warn( this + ".build() adds item with a 'null' key for '"  + item.value +"' value.", this );
					}
				}
			}

			constructor.result = dico;
			fireCommandEndEvent();
		}
	}
}