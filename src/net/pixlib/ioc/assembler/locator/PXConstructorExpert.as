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
	import net.pixlib.ioc.control.PXBuildFactory;
	import net.pixlib.plugin.PXPlugin;

	/**
	 * @author Francis Bourre
	 */
	public class PXConstructorExpert 
		extends PXAbstractLocator
	{
		static private var _oI : PXConstructorExpert;

		static public function getInstance() : PXConstructorExpert 
		{
			if (!_oI) _oI = new PXConstructorExpert(); 

			return _oI;
		}

		static public function release() : void
		{
			if (_oI)
			{
				_oI.release();
				_oI = null;
			}
		}

		function PXConstructorExpert()
		{
			super( PXConstructor, null, null );
		}

		public function buildObject( id : String ) : void
		{
			if ( isRegistered( id ) )
			{
				var cons : PXConstructor = locate( id ) as PXConstructor;
				
				if ( cons.arguments != null )  cons.arguments = PXPropertyExpert.getInstance().deserializeArguments( cons.arguments );
				
				var obj : * = PXBuildFactory.getInstance().build( cons, id );
				if( obj is PXPlugin ) PXPluginExpert.getInstance().register( id, obj );
				
				unregister( id );
			}
		}

		public function buildAllObjects() : void
		{
			PXBatch.process( buildObject, keys );
		}
	}
}
