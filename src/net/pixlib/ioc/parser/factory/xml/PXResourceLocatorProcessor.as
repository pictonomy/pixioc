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
package  net.pixlib.ioc.parser.factory.xml
{
	import net.pixlib.core.pixlib_internal;
	import net.pixlib.ioc.core.PXContextAttributeList;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.parser.factory.processor.PXAbstractContextProcessor;
	import net.pixlib.load.PXResourceLocator;

	/**
	 * @author Romain Ecarnot
	 */
	public class PXResourceLocatorProcessor extends PXAbstractContextProcessor 
	{
		public function PXResourceLocatorProcessor()
		{
			super();
		}

		override protected function processContext() : void
		{
			var xml : XML = getContext() is XML ? getContext() as XML : new XML(getContext());
			var resources : XMLList = xml[PXContextNameList.RSC];
			
			for(var i : uint = 0;i < resources.length(); i++)
			{
				var resource : XML = resources[i];
				var id : String = resource.@[PXContextAttributeList.ID];
				var locator : String = resource.@[PXContextAttributeList.LOCATOR];
				
				if(locator != null && locator.length > 0 )
				{
					resource.@[PXContextAttributeList.ID] = PXResourceLocator.pixlib_internal::buildResourceID(locator, id);
				}
			}
			
			setContext(xml);
		}
	}
}
