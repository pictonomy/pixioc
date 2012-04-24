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
	import net.pixlib.commands.PXCommand;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXValueObjectEvent;
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.plugin.PXChannelExpert;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginChannel;
	import net.pixlib.utils.PXClassUtils;

	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Francis Bourre
	 */
	public class PXBuildInstance extends PXAbstractCommand
	{
		override protected function onExecute( event : Event = null ) : void
		{
			var constructor : PXConstructor = (event as PXValueObjectEvent).value as PXConstructor;

			if ( constructor.ref )
			{
				var cmd : PXCommand = new PXBuildRef();
				cmd.execute(event);
			} 
			else
			{
				try
				{
					var isPlugin : Boolean = PXClassUtils.inherit(getDefinitionByName(constructor.type) as Class, PXPlugin);
	
					if ( isPlugin && constructor.ID != null && constructor.ID.length > 0 ) 
						PXChannelExpert.getInstance().registerChannel(PXPluginChannel.getInstance(constructor.ID));
				} catch ( error1 : Error )
				{
					// do nothing as expected
				}

				PXBuildInstance.buildConstructor(constructor);
			}

			fireCommandEndEvent();
		}

		static public function buildConstructor( cons : PXConstructor ) : void
		{
			try
			{
				cons.result = PXCoreFactory.getInstance().buildInstance(cons.type, cons.arguments, cons.factory, cons.singleton);
			} catch ( e : Error )
			{
				throw e;
			}
		}
	}
}