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
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.ioc.control.PXBuildFactory;
	import net.pixlib.ioc.core.PXContextTypeList;

	/**
	 * @author Francis Bourre
	 */
	public class PXMethodExpert 
		extends PXAbstractLocator
	{
		static private var	_oI	: PXMethodExpert;

		static public function getInstance() : PXMethodExpert
		{
			if (!_oI) _oI = new PXMethodExpert(); 

			return _oI;
		}

		static public function release() : void
		{
			if(_oI) _oI.release();
			_oI = null;
		}

		function PXMethodExpert()
		{
			super( PXMethod, null, null );
		}

		public function callMethod( id : String ) : void
		{
			var msg : String;

			var method : PXMethod = locate( id ) as PXMethod;
			var cons : PXConstructor = new PXConstructor( null, PXContextTypeList.FUNCTION, [ method.ownerID + "." + method.name ] );
			var func : Function = PXBuildFactory.getInstance().build( cons );

			var args : Array = PXPropertyExpert.getInstance().deserializeArguments( method.arguments );

			try
			{
				func.apply( null, args );

			} catch ( error2 : Error )
			{
				msg = error2.message;
				msg += " " + this + ".callMethod() failed on instance with id '" + method.ownerID + "'. ";
				msg += "'" + method.name + "' method can't be called with these arguments: [" + args + "]";
				throw new PXIllegalArgumentException( msg, this );
			}
		}
		
		/**
		 * Methods are called in same order as they defined in IoC context.
		 */
		public function callAllMethods() : void
		{
			var keys : Array = keys;
			keys.sort();
			
			PXBatch.process( callMethod, keys );
		}
	}
}
