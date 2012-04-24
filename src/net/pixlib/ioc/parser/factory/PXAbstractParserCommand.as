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
 
package net.pixlib.ioc.parser.factory 
{
	import net.pixlib.commands.PXAbstractCommand;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.exceptions.PXUnimplementedMethodException;
	import net.pixlib.ioc.assembler.PXApplicationAssembler;
	import net.pixlib.ioc.load.PXApplicationLoader;
	import net.pixlib.ioc.load.PXApplicationLoaderState;
	import net.pixlib.ioc.parser.PXContextParserEvent;

	import flash.events.Event;

	/**
	 * Abstract implementation for context parsing command.
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXAbstractParserCommand extends PXAbstractCommand implements PXParserCommand 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _oLoader : PXApplicationLoader;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Application context data. */
		protected var oContext : *;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		final public function getApplicationLoader() : PXApplicationLoader
		{
			return _oLoader;
		}

		/**
		 * @inheritDoc
		 */
		final public function getAssembler() : PXApplicationAssembler
		{
			return getApplicationLoader( ).applicationAssembler;
		}

		/**
		 * @inheritDoc
		 */
		final public function getContextData(  ) : *
		{
			return oContext;
		}

		/**
		 * @inheritDoc
		 */
		public function parse( ) : void
		{
			throw new PXUnimplementedMethodException(".parse() must be implemented in concrete class.", this);
		}
		
		/**
		 * @inheritDoc
		 */
		final override protected function onExecute( event : Event = null ) : void
		{
			if( event == null || !( event is PXContextParserEvent ) )
			{
				throw new PXNullPointerException(".execute() failed, event data is unreachable", this );
			}
			else
			{
				var evt : PXContextParserEvent = PXContextParserEvent( event );
				
				try
				{
					setApplicationLoader( evt.getApplicationLoader( ) );
					setContextData( evt.getContextData( ) );
					
					getApplicationLoader( ).fireOnApplicationState( getState( ) );
					
					parse( );				}
				catch( err : Error )
				{
					throw new PXIllegalArgumentException(".execute() failed " + err.message, this );
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		final override protected function onCancel() : void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		final override protected function broadcastCommandEndEvent() : void
		{
			oEB.broadcastEvent( new PXContextParserEvent( PXCommandEvent.onCommandEndEVENT, null, getApplicationLoader(), getContextData() ) );
		}
		

		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */
		protected function getState(  ) : String
		{
			return PXApplicationLoaderState.PARSE_STATE;	
		}

		/**
		 * 
		 */
		final protected function setApplicationLoader( loader : PXApplicationLoader = null ) : void
		{
			if( loader != null )
			{
				_oLoader = loader;
			}
			else
			{
				throw new PXIllegalArgumentException(".setApplicationLoader() failed : " + loader, this);
			}
		}

		/**
		 * 
		 */
		protected function setContextData( data : * = null ) : void
		{
			if( data != null )
			{
				oContext = data;
			}
			else
			{
				throw new PXIllegalArgumentException(".setContext() failed : " + data, this);
			}
		}
		

		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		function PXAbstractParserCommand( )
		{
			
		}		
	}
}