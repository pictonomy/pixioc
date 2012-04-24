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
 
package net.pixlib.ioc.assembler.locator
{
	import net.pixlib.commands.PXBatch;
	import net.pixlib.core.PXAbstractLocator;
	import net.pixlib.plugin.PXPlugin;

	/**
	 * The PluginExpert class is a locator for 
	 * <code>Plugin</code> object.
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPluginExpert extends PXAbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
				
		private static var _oI : PXPluginExpert;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance of PluginExpert class.
		 */
		public static function getInstance() : PXPluginExpert 
		{
			if (!_oI) _oI = new PXPluginExpert(); 
			return _oI;
		}
		
		/**
		 * Release instance.
		 */
		public static  function release() : void
		{
			if(_oI) _oI.release();			_oI = null;
		}
		
		/**
		 * Notifies all registered plugins that IoC process 
		 * is finished.
		 * 
		 * <p>Batch processing throw all registered plugins></p>
		 * 
		 * <p>Locator is release after process.</p>
		 * 
		 * @see #notifyPlugin()
		 */
		public function notifyAllPlugins(  ) : void
		{
			PXBatch.process( notifyPlugin, keys );
			
			PXPluginExpert.release();
		}
		
		/**
		 * Notifies registered plugins that IoC process 
		 * is finished.
		 */
		public function notifyPlugin( id : String ) : void
		{
			if ( isRegistered( id ) )
			{
				var plugin : PXPlugin = locate( id ) as PXPlugin;
				
				plugin.onApplicationInit();
				
				unregister( id );
			}
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PXPluginExpert()
		{
			super( PXPlugin, null, null );
		}
	}
}
