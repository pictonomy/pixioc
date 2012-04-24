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
	import net.pixlib.ioc.core.PXContextAttributeList;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.exceptions.PXNullChannelException;
	import net.pixlib.ioc.exceptions.PXNullIDException;
	import net.pixlib.ioc.load.PXApplicationLoaderState;

	import flash.net.URLRequest;

	/**
	 * @author Francis Bourre
	 */
	public class PXDisplayObjectParser extends PXXMLParser
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		public function PXDisplayObjectParser(  )
		{
		}

		override public function parse( ) : void
		{
			var displayXML : XMLList = getXMLContext( )[ PXContextNameList.ROOT ];

			if ( displayXML.length( ) > 0  )
			{
				var rootID : String = displayXML.attribute( PXContextAttributeList.ID );
				
				if ( rootID )
				{
					getAssembler( ).buildRoot( rootID );
				} 
				else
				{
					throw new PXNullIDException("ID attribute is mandatory with 'root' node.", this);
				}
				
				for each ( var node : XML in displayXML.* ) _parseNode( node, rootID );
				delete getXMLContext( )[ PXContextNameList.ROOT ];
			}
			
			fireCommandEndEvent();
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		override protected function getState(  ) : String
		{
			return PXApplicationLoaderState.GFX_PARSE_STATE;
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
				
		private function _parseNode( xml : XML, parentID : String = null ) : void
		{
			// Filter reserved nodes
			if ( PXContextNameList.getInstance( ).nodeNameIsReserved( xml.name( ) ) ) return;

			var identifier : String = PXAttributeUtils.getID( xml );
			if ( !identifier )
			{
				throw new PXNullIDException(" encounters parsing error with '" + xml.name( ) + "' node. You must set an id attribute.", this);
			}

			getAssembler( ).registerID( identifier );

			var url : String = PXAttributeUtils.getURL( xml );
			var visible : String = PXAttributeUtils.getVisible( xml );
			var isVisible : Boolean = visible ? (visible == "true") : true;
			var type : String = PXAttributeUtils.getDisplayType( xml );

			getAssembler( ).buildDisplayObject( 
				identifier, 
				parentID, url ? new URLRequest( url ) : null, 
				isVisible, 
				type 
			);

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
				getAssembler( ).buildMethodCall( 
					identifier, 
					PXAttributeUtils.getName( method ), 
					PXXMLUtils.getArguments( method, PXContextNameList.ARGUMENT ) 
				);
			}

			// Build channel listener.
			for each ( var listener : XML in xml[ PXContextNameList.LISTEN ] )
			{
				var channelName : String = PXAttributeUtils.getRef( listener );
				if ( channelName )
				{
					getAssembler( ).buildChannelListener( identifier, channelName );
				} 
				else
				{
					throw new PXNullChannelException(" encounters parsing error with '" + xml.name( ) + "' node, 'channel' attribute is mandatory in a 'listen' node.", this);
				}
			}

			// recursivity
			for each ( var node : XML in xml.* ) _parseNode( node, identifier );
		}
	}
}