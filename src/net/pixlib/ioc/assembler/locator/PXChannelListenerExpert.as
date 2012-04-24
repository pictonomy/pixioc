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
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.events.PXApplicationBroadcaster;
	import net.pixlib.plugin.PXPluginChannel;

	/**
	 * @author Francis Bourre
	 */
	public class PXChannelListenerExpert 
		extends PXAbstractLocator
	{
		static private var _oI : PXChannelListenerExpert;

		static public function getInstance() : PXChannelListenerExpert
		{
			if (!_oI) _oI = new PXChannelListenerExpert(); 
			
			return _oI;
		}
		
		static public function release():void
		{
			if (_oI)
			{
				_oI.release();
				_oI = null ;
			}
		}
		
		function PXChannelListenerExpert()
		{
			super( PXChannelListener, null, null );
		}

		public function assignAllChannelListeners() : void
		{
			PXBatch.process( assignChannelListener, keys );
		}
		
		public function assignChannelListener( id : String ) : Boolean
		{
			var channelListener : PXChannelListener = locate( id ) as PXChannelListener;
			var listener : Object = PXCoreFactory.getInstance().locate( channelListener.listenerID );
			var channel : PXPluginChannel = PXPluginChannel.getInstance( channelListener.channelName );

			var args : Array = channelListener.arguments;
			
			if ( args && args.length > 0 )
			{
				var length : int = args.length;
				for ( var i : int; i < length; i++ )
				{
					var obj : Object = args[ i ];
					var method : String = obj.method;
					listener = ( method && listener.hasOwnProperty(method) && listener[method] is Function) ? listener[method] : listener[obj.type];
					PXApplicationBroadcaster.getInstance().addEventListener( obj.type, listener, channel );
				}

				return true;

			} else 
			{
				return PXApplicationBroadcaster.getInstance().addListener( listener, channel );
			}
		}
	}
}
