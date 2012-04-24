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
	import net.pixlib.load.PXLoaderEvent;

	/**
	 * <p>The ApplicationLoaderEvent class represents the event object passed 
	 * to the event listener for <strong>ApplicationLoader</strong> events.</p>
	 * 
	 * @see ApplicationLoader
	 * 
	 * @author Francis Bourre
	 */

	public class PXApplicationLoaderEvent extends PXLoaderEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationLoadStart
		 */	
		public static const onApplicationLoadStartEVENT : String = "onApplicationLoadStart";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationState</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     *     <tr>
	     *     	<td><code>getApplicationState()</code>
	     *     	</td><td>The application state</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationState
		 */	
		public static const onApplicationStateEVENT : String = "onApplicationState";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationParsed</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationParsed
		 */	
		public static const onApplicationParsedEVENT : String = "onApplicationParsed";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationObjectsBuilt</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationObjectsBuilt
		 */	
		public static const onApplicationObjectsBuiltEVENT : String = "onApplicationObjectsBuilt";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationMethodsCalled</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationMethodsCalled
		 */	
		public static const onApplicationMethodsCalledEVENT : String = "onApplicationMethodsCalled";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationChannelsAssigned</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationChannelsAssigned
		 */	
		public static const onApplicationChannelsAssignedEVENT : String = "onApplicationChannelsAssigned";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onApplicationInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     *     
	     *     <tr><th>Method</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>getApplicationLoader()</code>
	     *     	</td><td>The loader object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onApplicationInit
		 */	
		public static const onApplicationInitEVENT : String = "onApplicationInit";
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * State value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		public var state : String = "";
		
		/**
		 * Returns the application loader object carried by this event.
		 * 
		 * @return	The dimension value carried by this event.
		 */
		public function get applicationLoader() : PXApplicationLoader
		{
			return loader as PXApplicationLoader;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>DisplayObjectBuilderEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	al				Application loader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 */		
		public function PXApplicationLoaderEvent( eventType : String, al : PXApplicationLoader, errorMessage : String = "" )
		{
			super( eventType, al, errorMessage );
		}
	}
}