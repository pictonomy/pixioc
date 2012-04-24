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
	import net.pixlib.commands.PXCommand;
	import net.pixlib.core.PXValueObject;

	import flash.display.DisplayObjectContainer;

	/**
	 * <p>All Display object builder must implement this interface.</p>
	 * 
	 * @author Francis Bourre
	 * 
	 * @see DefaultDisplayObjectBuilder
	 */
	public interface PXDisplayObjectBuilder extends PXCommand
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The root target for display list creation.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		function get rootTarget() : DisplayObjectContainer;
		
		/**
		 * @private
		 * 
		 */
		function set rootTarget(value : DisplayObjectContainer) : void;
		
		/**
		 * Indicates the <code>Anti cache system</code> to <code>true</code> 
		 * or <code>false</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		function get anticache() : Boolean;
		
		/**
		 * @private
		 */
		function set anticache(value : Boolean) : void;
		
		/**
		 * Returns all elements queue size.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		function get length() : uint;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Builds a DLL object using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildDLL( o : PXValueObject ) : void;
		
		/**
		 * Builds a Resource object using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildResource( o : PXValueObject ) : void;
		
		/**
		 * Builds a Display object using passed-in <code>ValueObject</code> 
		 * configuration object.
		 * 
		 * @param	o	<code>ValueObject</code> containing building parameters
		 */
		function buildDisplayObject( o : PXValueObject ) : void;
		
		/**
		 * Adds the passed-in listener as listener for all events dispatched
		 * by this builder. The function returns <code>true</code>
		 * if the listener have been added at the end of the call. If the
		 * listener is already registered in this event broadcaster the function
		 * returns <code>false</code>.
		 * 
		 * @param	listener	the listener object to add as builder listener.
		 * @return	<code>true</code> if the listener have been added during this call
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			listener doesn't match the listener type supported by this event
		 * 			broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		function addListener( listener : PXDisplayObjectBuilderListener ) : Boolean;
		
		/**
		 * Removes the passed-in listener object from this event
		 * broadcaster. The object is removed as listener for all
		 * events the broadcaster may dispatch.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this event broadcaster
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in listener
		 * 			is a function
		 */
		function removeListener( listener : PXDisplayObjectBuilderListener ) : Boolean;
		
		/**
		 * Adds an event listener for the specified event type.
		 * There is two behaviors for the <code>addEventListener</code>
		 * function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object must
		 * have a function with the same name than <code>type</code> or at least a
		 * <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type. There is no restriction on the name of 
		 * the function. If the <code>rest</code> is not empty, all elements in it is 
		 * used as additional arguments into the delegate object.</li> 
		 * </ol>
		 * 
		 * @param	type		name of the event for which register the listener
		 * @param	listener	object or function which will receive this event
		 * @param	rest		additional arguments for the function listener
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 */
		function addEventListener( type : String, listener : Object, ... rest ) : Boolean;
		
		/**
		 * Removes the passed-in listener for listening the specified event. The
		 * listener could be either an object or a function.
		 * 
		 * @param	type		name of the event for which unregister the listener
		 * @param	listener	object or function to be unregistered
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 */
		function removeEventListener( type : String, listener : Object ) : Boolean;
	}
}
