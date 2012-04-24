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
package net.pixlib.ioc.parser.factory.xml
{
	import net.pixlib.events.PXApplicationBroadcaster;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.core.PXContextTypeList;
	import net.pixlib.ioc.exceptions.PXNullChannelException;
	import net.pixlib.ioc.exceptions.PXNullIDException;
	import net.pixlib.ioc.load.PXApplicationLoaderState;

	/**
	 * @author Francis Bourre
	 */
	public class PXObjectParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		public function PXObjectParser( )
		{
		}
		
		override public function parse( ) : void
		{
			for each ( var node : XML in getXMLContext( ).* ) parseNode( node );
			
			fireCommandEndEvent();
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.OBJECT_PARSE_STATE;
		}

		protected function parseNode( xml : XML ) : void
		{
			var identifier : String = PXAttributeUtils.getID( xml );
			if ( !identifier )
			{
				throw new PXNullIDException(" encounters parsing error with '" + xml.name( ) + "' node. You must set an id attribute.", this);
			}
			
			getAssembler( ).registerID( identifier );
			
			var type : String;
			var args : Array;
			var factory : String;
			var singleton : String;

			// Build object.
			type = PXAttributeUtils.getType( xml );

			if ( type == PXContextTypeList.XML )
			{
				args = new Array( );
				args.push( {ownerID:identifier, value:xml.children( )} );
				factory = PXAttributeUtils.getDeserializerClass( xml );
				getAssembler( ).buildObject( identifier, type, args, factory );
			} 
			else
			{
				args = (type == PXContextTypeList.DICTIONARY) ? PXXMLUtils.getItems( xml ) : PXXMLUtils.getArguments( xml, PXContextNameList.ARGUMENT, type );
				factory = PXAttributeUtils.getFactoryMethod( xml );
				singleton = PXAttributeUtils.getSingletonAccess( xml );

				getAssembler( ).buildObject( identifier, type, args, factory, singleton );
	
				// register each object to system channel.
				getAssembler( ).buildChannelListener( identifier, PXApplicationBroadcaster.getInstance().SYSTEM_CHANNEL.toString( ) );
				
				// Build property.
				for each ( var property : XML in xml[ PXContextNameList.PROPERTY ] )
				{
					getAssembler( ).buildProperty( 
						identifier, 
						PXAttributeUtils.getName( property ), 
						PXAttributeUtils.getValue( property ), 
						PXAttributeUtils.getType( property ), 
						PXAttributeUtils.getRef( property ), 
						PXAttributeUtils.getMethod( property ) 
					);
				}
	
				// Build method call.
				for each ( var method : XML in xml[ PXContextNameList.METHOD_CALL ] )
				{
					getAssembler( ).buildMethodCall( identifier, PXAttributeUtils.getName( method ), PXXMLUtils.getArguments( method, PXContextNameList.ARGUMENT ) );
				}

				// Build channel listener.
				for each ( var listener : XML in xml[ PXContextNameList.LISTEN ] )
				{
					var channelName : String = PXAttributeUtils.getRef( listener );

					if ( channelName )
					{
						var listenerArgs : Array = PXXMLUtils.getArguments( listener, PXContextNameList.EVENT );
						getAssembler( ).buildChannelListener( identifier, channelName, listenerArgs );
					} 
					else
					{
						throw new PXNullChannelException(" encounters parsing error with '" + xml.name( ) + "' node, 'ref' attribute is mandatory in a 'listen' node.", this);
					}
				}
			}
		}
	}
}