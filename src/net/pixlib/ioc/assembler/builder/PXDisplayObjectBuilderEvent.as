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
	import net.pixlib.load.PXLoader;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.collection.PXLoaderCollectionEvent;

	/**
	 * The DisplayObjectBuilderEvent class represents the event object passed 
	 * to the event listener for DisplayObjectBuilder events.
	 * 
	 * @see DisplayObjectBuilder
	 * 
	 * @author Francis Bourre
	 */
	public class PXDisplayObjectBuilderEvent extends PXLoaderEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		static public const onLoadStartEVENT 		: String = PXLoaderCollectionEvent.onLoadStartEVENT;
		static public const onLoadInitEVENT			: String = PXLoaderCollectionEvent.onLoadInitEVENT; 
		static public const onLoadProgressEVENT		: String = PXLoaderCollectionEvent.onLoadProgressEVENT; 
		static public const onLoadTimeOutEVENT		: String = PXLoaderCollectionEvent.onLoadTimeOutEVENT;
		static public const onLoadErrorEVENT 		: String = PXLoaderCollectionEvent.onLoadErrorEVENT;
		
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectBuilderLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectBuilderLoadStart
		 */
		public static const onDisplayObjectBuilderLoadStartEVENT : String = "onDisplayObjectBuilderLoadStart"; 
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayLoaderInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayLoaderInit
		 */
		public static const onDisplayLoaderInitEVENT : String = "onDisplayLoaderInit";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDLLLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDLLLoadStart
		 */
		public static const onDLLLoadStartEVENT : String = "onDLLLoadStart";	
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDLLLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDLLLoadInit
		 */
		public static const onDLLLoadInitEVENT : String = "onDLLLoadInit";	
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRSCLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRSCLoadStart
		 */
		public static const onRSCLoadStartEVENT : String = "onRSCLoadStart";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRSCLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onRSCLoadInit
		 */
		public static const onRSCLoadInitEVENT : String = "onRSCLoadInit";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectLoadStart
		 */
		public static const onDisplayObjectLoadStartEVENT : String = "onDisplayObjectLoadStart"; 
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectLoadInit
		 */
		public static const onDisplayObjectLoadInitEVENT : String = "onDisplayObjectLoadInit"; 
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onDisplayObjectBuilderLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
	     * <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr>
	     *     	<td><code>type</code></td>
	     *     	<td>Dispatched event type</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onDisplayObjectBuilderLoadInit
		 */
		public static const onDisplayObjectBuilderLoadInitEVENT : String = "onDisplayObjectBuilderLoadInit";
		
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>DisplayObjectBuilderEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	loader			Loader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 */	
		public function PXDisplayObjectBuilderEvent ( eventType : String, loader : PXLoader = null, errorMessage : String = "" ) 
		{
			super( eventType, loader, errorMessage );
		}
	}
}