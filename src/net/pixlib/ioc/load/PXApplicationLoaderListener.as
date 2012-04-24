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
package net.pixlib.ioc.load
{
	import net.pixlib.load.PXLoaderListener;			

	/**
	 * <p>Application loader listener implementation.</p>
	 * 
	 * <p>All objects that want to listen to the loading of the application 
	 * must implement this interface</p>.
	 * 
	 * @see net.pixlib.ioc.DefaultApplicationRunner
	 * 
	 * @author Francis Bourre
	 */
	public interface PXApplicationLoaderListener extends PXLoaderListener
	{
		/**
		 * Triggered when IOC process change his state.
		 * 
		 * <p>Retreives state value using : <code>e.getApplicationState()</code><br />
		 * Possible values are : 
		 * <ul>
		 * 	<li>ApplicationLoaderEvent.LOAD_STATE</li>
		 * 	<li>ApplicationLoaderEvent.PARSE_STATE</li>
		 * 	<li>ApplicationLoaderEvent.DLL_STATE</li>
		 * 	<li>ApplicationLoaderEvent.RSC_STATE</li>
		 * 	<li>ApplicationLoaderEvent.GFX_STATE</li>
		 * 	<li>ApplicationLoaderEvent.BUILD_STATE</li>
		 * 	<li>ApplicationLoaderEvent.RUN_STATE</li>
		 * </ul></p>
		 * 
		 * @see ApplicationLoaderEvent
		 */
		function onApplicationState( event : PXApplicationLoaderEvent ) : void
		
		/**
		 * Triggered when xml context starts loading.
		 */
		function onApplicationLoadStart( event : PXApplicationLoaderEvent ) : void
		
		/**
		 * Triggered when xml context is loaded and parsed.
		 */
		function onApplicationParsed( event : PXApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when objects are created.
		 */
		function onApplicationObjectsBuilt( event : PXApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when communication channels are created.
		 */
		function onApplicationChannelsAssigned( event : PXApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when all methods defined in xml context are called on 
		 * their respective owner instance.
		 */
		function onApplicationMethodsCalled( event : PXApplicationLoaderEvent ) : void;
		
		/**
		 * Triggered when application is ready.
		 * 
		 * <p>All is loaded, parsed, created and linked.<br />
		 * Depedencies are resolved</p>
		 */
		function onApplicationInit( event : PXApplicationLoaderEvent ) : void;
	}
}