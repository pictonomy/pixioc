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

package net.pixlib.ioc.runner
{
	import net.pixlib.core.PXApplication;
	import net.pixlib.core.PXBaseDocument;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.core.pixlib_internal;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.load.PXApplicationLoader;
	import net.pixlib.ioc.load.PXApplicationLoaderEvent;

	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;


	/**
	 * IoC Application runner.
	 * 
	 * <p>Basic IoC builder implementation.<br />
	 * Just need to compile this class to starts IoC processing.</p>
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXBasicApplicationRunner extends PXBaseDocument
	{
		/** Aplication loader instance. */
		protected var oLoader : PXApplicationLoader;


		/**
		 * Initializes document properties and starts IoC process.
		 * 
		 * <p>Set Stage default properties, hide context menu and 
		 * enable Mouse Wheel Helper on Mac OS Platform.</p>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final override protected function init() : void
		{
			alignStage();

			initContextMenu();
			
			registerFlashVars();
			
			loadContext();
		}

		/**
		 * Loads application context.
		 * 
		 * <p>Before loading context, you can do some preprocessing 
		 * as method <code>preprocess</code> is call just before.</p>
		 * 
		 * @see #preprocess()
		 */
		protected function loadContext() : void
		{
			oLoader = createApplicationLoader();

			preprocess();

			oLoader.execute();
		}

		/**
		 * Creates new basic ApplicationLoader instance.
		 */
		protected function createApplicationLoader() : PXApplicationLoader
		{
			var loader : PXApplicationLoader = new PXApplicationLoader(createApplicationTarget(), false);
			loader.anticache = true;

			return loader;
		}

		/**
		 * Creates the main application container.
		 * 
		 * @return The main application container.
		 */
		protected function createApplicationTarget() : DisplayObjectContainer
		{
			return this;
		}

		/**
		 * Runs actions before application loading
		 * 
		 * <p>Do nothing here, just override this method in subclass 
		 * to customize preprocessing actions.</p>
		 */
		protected function preprocess() : void
		{
			oLoader.addEventListener(PXApplicationLoaderEvent.onApplicationInitEVENT, onApplicationInitHandler);
		}

		/**
		 * Returns default relative context file url using runner path.
		 */
		protected function getRelativeContextURL() : URLRequest
		{
			var local : Boolean = new RegExp("file://").test(loaderInfo.url);
			var basePath : String = ( local ) ? "" : loaderInfo.url.substring(0, loaderInfo.url.lastIndexOf("/") + 1);
			var url : String = basePath + PXApplicationLoader.DEFAULT_NAME;

			return new URLRequest(url);
		}
		
		/**
		 * Triggered when IoC application is loaded.
		 */
		protected function onApplicationInitHandler(event : PXApplicationLoaderEvent) : void
		{
			event.stopImmediatePropagation();

			if (oLoader) oLoader.removeEventListener(PXApplicationLoaderEvent.onApplicationInitEVENT, onApplicationInitHandler);

			if (PXCoreFactory.getInstance().isRegistered(PXContextNameList.ROOT))
			{
				PXApplication.getInstance().pixlib_internal::init(PXCoreFactory.getInstance().locate(PXContextNameList.ROOT) as DisplayObjectContainer, loaderInfo);
			}

			oLoader = null;
		}
	}
}
