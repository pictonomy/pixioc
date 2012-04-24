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
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.commands.PXBatch;
	import net.pixlib.ioc.core.PXContextAttributeList;
	import net.pixlib.ioc.core.PXContextNameList;
	import net.pixlib.ioc.parser.factory.processor.PXAbstractContextProcessor;

	/**
	 * Transforms node attributes value to IoC property node.
	 * 
	 * @example Simple context
	 * <pre class="prettyprint">
	 * 
	 * &lt;beans&gt;
	 * 	&lt;heading id="test1" fontFamily="Arial" fontSize="100" type="Object"&gt;
	 *		&lt;property name="rank" value="First" /&gt;
	 * 	&lt;/heading&gt;
	 * &lt;/beans&gt;
	 * </pre>
	 * 
	 * @example Adds processor to context loader.
	 * <pre class="prettyprint">
	 * 	
	 * 	loader.addProcessor( new AttributeAsPropertyProcessor( "test1" ) );
	 * </pre>
	 * 
	 * @example Processing result.
	 * <pre class="prettyprint">
	 * 	
	 * &lt;beans&gt;
	 * 	&lt;heading id="test1" type="Object"&gt;
	 *		&lt;property name="rank" value="First" /&gt;
	 *		&lt;property name="fontFamily" value="Arial" /&gt;
	 *		&lt;property name="fontSize" value="100" /&gt;
	 * 	&lt;/heading&gt;
	 * &lt;/beans&gt;
	 * </pre>
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXAttributeAsPropertyProcessor extends PXAbstractContextProcessor
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _mName : PXHashMap;
		private var _aID : Array;
		private var _oContext : XML;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new <code>AttributeAsPropertyProcessor</code> instance.
		 * 
		 * @param	id	Node identifier to search for
		 * @param	...	Additionnal nodes identifiers
		 */
		public function PXAttributeAsPropertyProcessor( id : String, ...args )
		{
			init();
			
			_aID = args.concat( [ id ] );
		}
		
		override protected function processContext() : void
		{
			_oContext = new XML( getContext() );
			
			PXBatch.process( processNode, _aID );
			
			setContext(_oContext);
		}
		
		override public function release() : void
		{
			super.release();
			
			_mName = null;
			_aID = null;
			_oContext = null;
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Initializes attribute names hashmap with default values.
		 */
		protected function init() : void
		{
			_mName = new PXHashMap( );
			
			addAttributeName( PXContextAttributeList.ID, "" );
			addAttributeName( PXContextAttributeList.TYPE, "" );		}
		
		/**
		 * Adds a new attribute name.
		 * 
		 * @param	attributeName	Attribute name to add.
		 * @param	value			Value associated with new attribute name.
		 */
		protected function addAttributeName( attributeName : String, value : * ) : void
		{
			_mName.put( attributeName, value );
		}
		
		/**
		 * Returns <code>true</code> if passed-in <code>attributeName</code> 
		 * is a protected attribute name.
		 */
		protected function isReserved( attributeName : * ) : Boolean
		{
			return _mName.containsKey( attributeName );
		}
		
		protected function processNode( id : String ) : void
		{
			var node : XMLList = _oContext..*.( hasOwnProperty( getAttributeName( PXContextAttributeList.ID ) ) && @[PXContextAttributeList.ID] == id );
			
			var atts : XMLList = node.attributes( );
			for each (var o : XML in atts) 
			{
				var nodeName : String = PXContextNameList.PROPERTY;
				var attName : String = o.name( ).toString( );
				
				if( !isReserved( attName ) )
				{
					var property : XML = new XML("<" + nodeName + "/>");//<{nodeName} />;
					property.@[PXContextAttributeList.NAME] = attName;
					property.@[PXContextAttributeList.VALUE] = o.toString( );
					
					node.appendChild( property );
				}
			}
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------

		private static function getAttributeName( name : String ) : String
		{
			return "@" + name;		
		}		
	}
}
