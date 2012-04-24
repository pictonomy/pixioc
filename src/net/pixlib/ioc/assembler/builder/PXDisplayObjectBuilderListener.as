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
package net.pixlib.ioc.assembler.builder 
{
	import net.pixlib.load.PXLoaderListener;		

	/**
	 * Display object builder listeners must implement this interface.
	 *  
	 * @author Francis Bourre
	 */
	public interface PXDisplayObjectBuilderListener extends PXLoaderListener
	{
		/**
		 * Triggered when context files starts processing.
		 */
		function onDisplayObjectBuilderLoadStart( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a DLL file starts loading.
		 */
		function onDLLLoadStart( event : PXDisplayObjectBuilderEvent ) : void;	

		/**
		 * Triggered when a DLL file loading is finished.
		 */
		function onDLLLoadInit( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a resource file loading is finished.
		 */
		function onRSCLoadInit( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a resource file starts loading.
		 */
		function onRSCLoadStart( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a graphic file starts loading.
		 */
		function onDisplayObjectLoadStart( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a graphic file loading is finished.
		 */
		function onDisplayObjectLoadInit( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * All files in xml context are loaded.
		 */
		function onDisplayObjectBuilderLoadInit( event : PXDisplayObjectBuilderEvent ) : void;

		/**
		 * Triggered when a display object is built.
		 */
		function onBuildDisplayObject( event : PXDisplayObjectEvent ) : void;
	}
}
