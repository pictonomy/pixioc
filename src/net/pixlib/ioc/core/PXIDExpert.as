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
package net.pixlib.ioc.core
{
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXStringifier;

	import flash.utils.Dictionary;

	/**
	 * @author Francis Bourre
	 */
	public class PXIDExpert
	{
		protected var _dico : Dictionary;

		public function PXIDExpert()
		{
			_dico = new Dictionary( true );
		}

		public function isRegistered( id : String ) : Boolean
		{
			return _dico[ id ] == true;
		}

		public function clear() : void
		{
			_dico = new Dictionary( true );
		}
		
		public function register( id : String ) : Boolean
		{
			if (  _dico[ id ] ) 
			{
				throw new PXIllegalArgumentException(".register(" + id + ") failed. This id was already registered, check conflicts in your config file.", this);

			} else
			{
				_dico[ id ] = true;
				return true;
			}

			return false;
		}
		
		public function unregister( id : String ) : Boolean
		{
			if ( isRegistered( id ) ) 
			{
				_dico[ id ] = false;
				return true;
			} 
			else
			{
				throw new PXNoSuchElementException(".unregister(" + id + ") failed.", this);
			}

			return false;
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PXStringifier.process( this );
		}
	}
}