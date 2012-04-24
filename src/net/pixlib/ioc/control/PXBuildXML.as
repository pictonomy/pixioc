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
	import net.pixlib.encoding.PXDeserializer;
	import net.pixlib.events.PXValueObjectEvent;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.ioc.assembler.locator.PXConstructor;

	import flash.events.Event;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildXML extends PXAbstractCommand
	{
		override protected function onExecute( event : Event = null ) : void 
		{
			var constructor : PXConstructor = (event as PXValueObjectEvent).value as PXConstructor;

			var args : Array = constructor.arguments;
			var factory : String = constructor.factory;

			if ( args != null ||  args.length > 0 ) 
			{
				var source : String = args[ 0 ] as String;

				if ( source.length > 0 )
				{
					if ( factory == null )
					{
						constructor.result = new XML(source);
					} 
					else
					{
						try
						{
							var deserialiser : PXDeserializer = PXCoreFactory.getInstance().buildInstance(factory) as PXDeserializer;
							constructor.result = deserialiser.deserialize(new XML(source));
						} 
						catch ( error : Error )
						{
							throw new PXIllegalArgumentException(".build() failed to deserialize XML with '" + factory + "' deserializer class." + error.message, this);
						}
					}
				} 
				else
				{
					logger.warn(this + ".build() returns an empty XML.", this);
					constructor.result = new XML();
				}
			} 
			else
			{
				logger.warn(this + ".build() returns an empty XML.", this);
				constructor.result = new XML();
			}

			fireCommandEndEvent();
		}
	}
}