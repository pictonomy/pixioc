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
	import net.pixlib.events.PXBasicEvent;

	import flash.display.DisplayObject;

	/**
	 * The DisplayObjectEvent class represents the event object passed 
	 * to the event listener for <strong>DisplayObjectBuilder</strong> events.
	 * 
	 * @see DisplayObjectBuilder
	 * 
	 * @author Francis Bourre
	 */
	public class PXDisplayObjectEvent extends PXBasicEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onBuildDisplayObject</code> event.
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
	     *     	<td><code>getDisplayObject()</code>
	     *     	</td><td>The display object</td>
	     *     </tr>
	     * </table>
	     * 
		 * @eventType onBuildDisplayObject
		 */		
		public static var onBuildDisplayObjectEVENT : String = "onBuildDisplayObject" ;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		public var displayObject : DisplayObject;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>DimensionEvent</code> object.
		 * 
		 * @param	type	Name of the event type
		 * @param	d		Display object carried by this event
		 */	
		public function PXDisplayObjectEvent( eventType : String, d : DisplayObject ) 
		{
			super( eventType, d );
			
			displayObject = d;
		}
	}
}