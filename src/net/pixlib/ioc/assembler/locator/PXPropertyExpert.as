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
	import net.pixlib.core.PXCoreFactoryEvent;
	import net.pixlib.core.PXCoreFactoryListener;
	import net.pixlib.ioc.control.PXBuildFactory;
	import net.pixlib.ioc.core.PXContextTypeList;

	/**
	 * @author Francis Bourre
	 */
	public class PXPropertyExpert 
		extends PXAbstractLocator
		implements PXCoreFactoryListener
	{
		static private var _oI : PXPropertyExpert;

		static public function getInstance() : PXPropertyExpert
		{
			if (!_oI) _oI = new PXPropertyExpert();
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
		
		function PXPropertyExpert()
		{
			super( Array, null, null );
			
			PXCoreFactory.getInstance().addListener( this );
		}

		public function setPropertyValue( property : PXProperty, target : Object ) : void
		{
			target[ property.name ] = getValue( property );
		}

		public function getValue( property : PXProperty ) : *
		{
			if ( property.method ) 
			{
				return PXBuildFactory.getInstance().build( new PXConstructor( null, PXContextTypeList.FUNCTION, [ property.method ] ) );

			} else if ( property.ref )
			{
				return PXBuildFactory.getInstance().build( new PXConstructor( null, PXContextTypeList.INSTANCE, null, null, null, property.ref ) );

			} else
			{
				var type : String = property.type/* && p.type != ContextTypeList.CLASS */? property.type : PXContextTypeList.STRING;
				return PXBuildFactory.getInstance().build( new PXConstructor( property.ownerID, type, [ property.value ] ) );
			}
		}

		public function deserializeArguments( arguments : Array ) : Array
		{
			var result : Array;
			var length : Number = arguments.length;

			if ( length > 0 ) result = new Array();

			for ( var i : int; i < length; i++ ) 
			{
				var obj : * = arguments[i];
				if ( obj is PXProperty )
				{
					result.push( getValue( obj as PXProperty ) );

				} 
				else if ( obj is PXDictionaryItem )
				{
					var dico : PXDictionaryItem = obj as PXDictionaryItem;
					dico.key = getValue( dico.getPropertyKey() );					dico.value = getValue( dico.getPropertyValue() );
					result.push( dico );
				}
			}

			return result;
		}
		
		public function buildProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null  ) : PXProperty
		{
			var prop : PXProperty = new PXProperty( ownerID, name, value, type, ref, method );
			broadcastEvent( new PXPropertyEvent( PXPropertyEvent.onBuildPropertyEVENT, null, prop ) );
			return prop;
		}
		
		public function addProperty( 	ownerID : String, 
										name 	: String = null, 
										value 	: String = null, 
										type 	: String = null, 
										ref 	: String = null, 
										method 	: String = null  ) : PXProperty
		{
			var prop : PXProperty = buildProperty( ownerID, name, value, type, ref, method );

			if ( isRegistered( ownerID ) )
			{
				( locate( ownerID ) as Array ).push( prop );
			} 
			else
			{
				register( ownerID, [ prop ] );
			}

			return prop;
		}
		
		public function onRegisterBean( event : PXCoreFactoryEvent ) : void
		{
			var identifier : String = event.id;
			if ( isRegistered( identifier ) ) PXBatch.process( setPropertyValue, locate( identifier ) as Array, event.bean );
		}

		public function onUnregisterBean( event : PXCoreFactoryEvent ) : void {}
	}
}
