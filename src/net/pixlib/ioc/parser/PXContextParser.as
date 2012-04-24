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
package net.pixlib.ioc.parser 
{
	import net.pixlib.collections.PXIterator;
	import net.pixlib.commands.PXBatch;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.ioc.load.PXApplicationLoader;

	import flash.events.Event;

	/**
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	public class PXContextParser extends PXBatch
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		protected var oLoader : PXApplicationLoader;
		protected var oContext : *;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 */	
		public function PXContextParser( collection : PXParserCollection = null ) 
		{
			super();
			
			oLoader = null;
			oContext = null;
			
			if( collection ) setParserCollection(collection);
		}

		/**
		 *
		 */
		public function setApplicationLoader( assembler : PXApplicationLoader ) : void
		{
			oLoader = assembler;
		}

		/**
		 *
		 */
		public function getApplicationLoader(  ) : PXApplicationLoader
		{
			return oLoader;
		}

		/**
		 *
		 */
		public function setContextData( context : * ) : void
		{
			oContext = context;
		}

		/**
		 *
		 */
		public function getContextData(  ) : *
		{
			return oContext;
		}

		/**
		 *
		 */
		final public function parse( context : * = null, loader : PXApplicationLoader = null ) : void
		{
			if( context ) setContextData(context);
			if( loader ) setApplicationLoader(loader);
			
			if( getApplicationLoader() == null )
			{
				throw new PXNullPointerException(".parse() can't application assembler instance.", this);
			}
			
			if( getContextData() == null )
			{
				throw new PXNullPointerException(".parse() can't retrieve IoC context data", this);
			}
			
			super.onExecute(new PXContextParserEvent("", this, getApplicationLoader(), getContextData()));
		}

		/**
		 * 
		 */
		final override protected function onExecute( event : Event = null ) : void
		{
			parse();
		}

		/**
		 * Called when the command process is over.
		 * 
		 * @param	e	event dispatched by the command
		 */
		final override public function onCommandEnd( event : PXCommandEvent ) : void
		{
			if( hasNext() )
			{
				next().execute(event);
			} 
			else
			{
				fireCommandEndEvent();
			}
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 *
		 */
		protected function setParserCollection( collection : PXParserCollection  ) : void
		{
			removeAll();
			
			var iter : PXIterator = collection.iterator();
			while( iter.hasNext() )
			{
				addCommand(iter.next());
			}	
		}	
	}
}