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
 
package net.pixlib.ioc.display 
{
	/**	 * Display loader interface.
	 * 
	 * <p>This interface use loader callback definition in xml 
	 * context file as :
	 * <pre class="prettyprint lang-xml">
	 * &lt;application-loader url="loader.swf" 
	 *		start-callback="onStartApplication" 
	 *		name-callback="onNameCallback"
	 *	
	 *		load-callback="onLoadCallback"
	 *		progress-callback="onProgressCallback"
	 *		timeout_callback="onTimeoutCallback"
	 *		error-callback="onErrorCallback"
	 *		init-callback="onInitCallback"
	 *	
	 *		parsed-callback="onParsedCallback"
	 *		objects-built-callback="onBuiltCallback"
	 *		channels-assigned-callback="onChannelsCallback"
	 *		methods-call-callback="onMethodsCallback"
	 *	
	 *		complete-callback="onCompleteCallback"
	 * /&gt;</pre>
	 * </p>
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @see AbstractDisplayLoader
	 * @see DisplayLoaderProxy	 */	public interface PXDisplayLoader
	{
		/**
		 * Triggered when 'start-callback' is called from IoC engine.
		 * 	
		 * @param	url		Context file currently in use
		 * @pram	size	Elements queues size
		 */
		function onStartApplication( url : String, size : uint = 0 ) : void;
		
		/**
		 * Triggered when 'name-callback' is called from IoC engine.
		 * 	
		 * @param	state	IoC engine state<br />
		 * Possible values are : 
		 * <dl>
		 * 	<dt>PARSE</dt>
		 * 	<dd>Engine parse the xml context file</dd>
		 * 	
		 * 	<dt>DLL</dt>
		 * 	<dd>DLL section starts loading</dd>
		 * 	
		 * 	<dt>RSC</dt>
		 * 	<dd>Resources section starts loading</dd>
		 * 	
		 * 	<dt>GFX</dt>
		 * 	<dd>Display tree starts loading</dd>
		 * 	
		 * 	<dt>BUILD</dt>
		 * 	<dd>Engine build objects, assign channels, and call method-call</dd>
		 * 	
		 * 	<dt>RUN</dt>
		 * 	<dd>Loading, parsing, building are finished; application is ready.</dd>
		 * </dl>
		 */
		function onNameCallback( state : String ) : void;
		
		/**
		 * Triggered when 'load-callback' is called from IoC engine.
		 * 	
		 * @param	url		File loaded
		 */
		function onLoadCallback( url : String ) : void;
		
		/**
		 * Triggered when 'progress-callback' is called from IoC engine.
		 * 	
		 * @param	url			File loaded		 * @param	percent		Loading progression
		 */
		function onProgressCallback( url : String, percent : Number ) : void;
		
		/**
		 * Triggered when 'timeout-callback' is called from IoC engine.
		 * 	
		 * @param	message		Error message
		 */
		function onTimeoutCallback( message : String ) : void;
		
		/**
		 * Triggered when 'error-callback' is called from IoC engine.
		 * 	
		 * @param	message		Error message
		 */
		function onErrorCallback( message : String ) : void;
		
		/**
		 * Triggered when 'init-callback' is called from IoC engine.
		 * 	
		 * @param	url		File loaded
		 */
		function onInitCallback( url : String ) : void;
		
		/**
		 * Triggered when 'parsed-callback' is called from IoC engine.
		 */
		function onParsedCallback( ) : void;
		
		/**
		 * Triggered when 'objects-built-callback' is called from IoC engine.
		 */
		function onBuiltCallback( ) : void;
		
		/**
		 * Triggered when 'channels-assigned-callback' is called from IoC engine.
		 */
		function onChannelsCallback( ) : void;
		
		/**
		 * Triggered when 'methods-call-callback' is called from IoC engine.
		 */
		function onMethodsCallback( ) : void;
		
		/**
		 * Triggered when 'complete-callback' is called from IoC engine.
		 */
		function onCompleteCallback( ) : void;
	}}