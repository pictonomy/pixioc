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
package net.pixlib.ioc.assembler
{
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilder;
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectInfo;
	import net.pixlib.ioc.assembler.locator.PXChannelListener;
	import net.pixlib.ioc.assembler.locator.PXChannelListenerExpert;
	import net.pixlib.ioc.assembler.locator.PXConstructor;
	import net.pixlib.ioc.assembler.locator.PXConstructorExpert;
	import net.pixlib.ioc.assembler.locator.PXDictionaryItem;
	import net.pixlib.ioc.assembler.locator.PXMethod;
	import net.pixlib.ioc.assembler.locator.PXMethodExpert;
	import net.pixlib.ioc.assembler.locator.PXProperty;
	import net.pixlib.ioc.assembler.locator.PXPropertyExpert;
	import net.pixlib.ioc.assembler.locator.PXResource;
	import net.pixlib.ioc.core.PXContextTypeList;
	import net.pixlib.ioc.core.PXIDExpert;
	import net.pixlib.utils.PXHashCode;

	import flash.net.URLRequest;

	/**
	 * @author Francis Bourre	 * @author Romain Ecarnot
	 */
	public class PXDefaultApplicationAssembler implements PXApplicationAssembler
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		protected var oIE : PXIDExpert;
		protected var oDOB : PXDisplayObjectBuilder;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get displayObjectBuilder() : PXDisplayObjectBuilder
		{
			return oDOB;
		}
		
		/**
		 * @private
		 */
		public function set displayObjectBuilder( displayObjectBuilder : PXDisplayObjectBuilder ) : void
		{
			oDOB = displayObjectBuilder;
			oIE = new PXIDExpert( );
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * @inheritDoc
		 */
		public function buildRoot( ID : String ) : void
		{
			displayObjectBuilder.buildDisplayObject( new PXDisplayObjectInfo( ID, null, true, null, null ) );
		}

		/**
		 * @inheritDoc
		 */
		public function buildDLL( url : URLRequest ) : void
		{
			displayObjectBuilder.buildDLL( new PXDisplayObjectInfo( null, null, false, url ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildResource( ID : String, url : URLRequest, type : String = null, deserializer : String = null, locator : String = null ) : void
		{
			displayObjectBuilder.buildResource( new PXResource( ID, url, type, deserializer, locator ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildDisplayObject( 		ID : String,
													parentID : String,
													url : URLRequest = null,
													isVisible : Boolean = true,
													type : String = null ) : void
		{
			displayObjectBuilder.buildDisplayObject( new PXDisplayObjectInfo( ID, parentID, isVisible, url, type ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildProperty( 	ownerID : String, 
										name : String = null, 
										value : String = null, 
										type : String = null, 
										ref : String = null, 
										method : String = null	) : void
		{
			PXPropertyExpert.getInstance( ).addProperty( ownerID, name, value, type, ref, method );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildObject( 	ownerID : String, 
										type : String = null, 
										args : Array = null, 
										factory : String = null, 
										singleton : String = null) : void
		{
			if ( args != null )
			{
				var length : int = args.length;
				var index : int;
				var obj : Object;

				if ( type == PXContextTypeList.DICTIONARY )
				{
					for ( index = 0; index < length ; index++ )
					{
						obj = args[ index ];
						var key : Object = obj.key;
						var value : Object = obj.value;
						var pKey : PXProperty = PXPropertyExpert.getInstance( ).buildProperty( ownerID, key.name, key.value, key.type, key.ref, key.method );
						var pValue : PXProperty = PXPropertyExpert.getInstance( ).buildProperty( ownerID, value.name, value.value, value.type, value.ref, value.method );
						args[ index ] = new PXDictionaryItem( pKey, pValue );
					}
				} 
				else
				{
					for ( index = 0; index < length ; index++ )
					{
						obj = args[ index ];
						var prop : PXProperty = PXPropertyExpert.getInstance( ).buildProperty( ownerID, obj.name, obj.value, obj.type, obj.ref, obj.method );
						args[ index ] = prop;
					}
				}
			}

			PXConstructorExpert.getInstance( ).register( ownerID, new PXConstructor( ownerID, type, args, factory, singleton ) );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildMethodCall( ownerID : String, methodCallName : String, args : Array = null ) : void
		{
			if ( args != null )
			{
				var length : int = args.length;
				for ( var i : int; i < length ; i++ )
				{
					var obj : Object = args[ i ];
					var prop : PXProperty = new PXProperty( obj.id, obj.name, obj.value, obj.type, obj.ref, obj.method );
					args[ i ] = prop;
				}
			}
			
			var method : PXMethod = new PXMethod( ownerID, methodCallName, args );
			var index : Number = PXMethodExpert.getInstance( ).keys.length++;
			PXMethodExpert.getInstance( ).register( getOrderedKey( index ), method );
		}
		
		/**
		 * @inheritDoc
		 */
		public function buildChannelListener( ownerID : String, channelName : String, args : Array = null ) : void
		{
			var channelListener : PXChannelListener = new PXChannelListener( ownerID, channelName, args );
			PXChannelListenerExpert.getInstance( ).register( PXHashCode.getKey( channelListener ), channelListener );
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerID( ID : String ) : Boolean
		{
			return oIE.register( ID );
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Returns ordered key using passed-in index value.
		 */
		protected function getOrderedKey( index : Number ) : String
		{
			var value : Number = 5 - index.toString( ).length;
			var src : String = "";
			if( value > 0 ) for( var i : Number = 0; i < value ; i++ ) src += "0";
			return src + index;
		}
	}
}