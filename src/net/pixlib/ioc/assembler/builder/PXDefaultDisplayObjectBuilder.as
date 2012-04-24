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
package net.pixlib.ioc.assembler.builder 
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.commands.PXCommandListener;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.core.PXValueObject;
	import net.pixlib.encoding.PXDeserializer;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXIllegalStateException;
	import net.pixlib.ioc.assembler.locator.PXResource;
	import net.pixlib.ioc.assembler.locator.PXResourceExpert;
	import net.pixlib.ioc.core.PXContextTypeList;
	import net.pixlib.load.PXFileLoader;
	import net.pixlib.load.PXGraphicLoader;
	import net.pixlib.load.PXLoader;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.PXLoaderLocator;
	import net.pixlib.load.PXResourceLocator;
	import net.pixlib.load.collection.PXLoaderCollectionEvent;
	import net.pixlib.load.collection.PXQueueLoader;
	import net.pixlib.load.pixlib_GraphicLoader;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.utils.PXFlashVars;
	import net.pixlib.utils.PXHashCode;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 *  Dispatched when a context element starts loading.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onLoadStartEVENT
	 */
	[Event(name="onLoadStart", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when a context element loading is finished.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onLoadInitEVENT
	 */
	[Event(name="onLoadInit", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched during context element loading progression.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onLoadProgressEVENT
	 */
	[Event(name="onLoadProgress", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when a timemout occurs during context element loading.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onLoadTimeOutEVENT
	 */
	[Event(name="onLoadTimeOut", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when an error occurs during context element loading.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onLoadErrorEVENT
	 */
	[Event(name="onLoadErrorEVENT", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when display list build is processing.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadStartEVENT
	 */
	[Event(name="onDisplayObjectBuilderLoadStart", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when display list build is finished.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onDisplayObjectBuilderLoadInitEVENT
	 */
	[Event(name="onDisplayObjectBuilderLoadInit", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when engine starts display list treatment.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onDisplayObjectLoadStartEVENT
	 */
	[Event(name="onDisplayObjectLoadStart", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when display list treatment is finished. 
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onDisplayObjectLoadInitEVENT
	 */
	[Event(name="onDisplayObjectLoadInit", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when engine starts DLL list treatment.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onDLLLoadStartEVENT
	 */
	[Event(name="onDLLLoadStart", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when DLL list treatment is finished. 
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onDLLLoadInitEVENT
	 */
	[Event(name="onDLLLoadInit", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when engine starts resources list treatment.
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onRSCLoadStartEVENT
	 */
	[Event(name="onRSCLoadStart", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 *  Dispatched when resources list treatment is finished. 
	 *  
	 *  @eventType net.pixlib.ioc.assembler.builder.DisplayObjectBuilderEvent.onRSCLoadInitEVENT
	 */
	[Event(name="onRSCLoadInit", type="net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent")]

	/**
	 * <p>Default display object builder implementation.</p>
	 * 
	 * @author Francis Bourre
	 */
	public class PXDefaultDisplayObjectBuilder implements PXDisplayObjectBuilder
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------

		static public const SPRITE : String = PXContextTypeList.SPRITE;
		static public const MOVIECLIP : String = PXContextTypeList.MOVIECLIP;
		static public const TEXTFIELD : String = PXContextTypeList.TEXTFIELD;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		protected var dpoTarget : DisplayObjectContainer;
		protected var sRootID : String;
		protected var oEB : PXEventBroadcaster;
		protected var qDllQueue : PXQueueLoader;		protected var qRscQueue : PXQueueLoader;
		protected var qGfxQueue : PXQueueLoader;

		protected var mDisplayObject : PXHashMap;
		protected var bIsAntiCache : Boolean;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get anticache() : Boolean
		{
			return bIsAntiCache;
		}
		
		/**
		 * @private
		 */
		public function set anticache(value : Boolean) : void
		{
			bIsAntiCache = value;
			qDllQueue.anticache = value;
			qRscQueue.anticache = value;
			qGfxQueue.anticache = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length() : uint
		{
			return qDllQueue.length + qGfxQueue.length + qRscQueue.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get rootTarget() : DisplayObjectContainer
		{
			return dpoTarget;
		}
		
		/**
		 * @private
		 */
		public function set rootTarget(value : DisplayObjectContainer) : void
		{
			if (value is DisplayObjectContainer)
			{
				dpoTarget = value;

				try
				{
					var param : Object = LoaderInfo(dpoTarget.root.loaderInfo).parameters;
					for ( var p : * in param ) 
					{
						PXFlashVars.getInstance().register(p, param[ p ]);
					}
				} 
				catch ( e : Error )
				{
					PXDebug.ERROR(this + "::" + e.message, this);
				}
			} 
			else
			{
				throw new PXIllegalStateException(".setRootTarget call failed. Argument is not a DisplayObjectContainer.", this);
			}
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 */
		public function PXDefaultDisplayObjectBuilder( rootTarget : DisplayObjectContainer = null )
		{
			if( rootTarget != null) this.rootTarget = rootTarget;
			
			qDllQueue = new PXQueueLoader();			qRscQueue = new PXQueueLoader();
			qGfxQueue = new PXQueueLoader();
			mDisplayObject = new PXHashMap();
			
			oEB = new PXEventBroadcaster(this, PXDisplayObjectBuilderListener);
			bIsAntiCache = false;
		}

		/**
		 * Returns the root registration ID.
		 */
		public function getRootID() : String
		{
			return sRootID ? sRootID : generateRootID();
		}

		/**
		 * @inheritDoc
		 */
		public function buildDLL( valueObject : PXValueObject ) : void
		{
			var info : PXDisplayObjectInfo = valueObject as PXDisplayObjectInfo;
			
			var gLoader : PXGraphicLoader = new PXGraphicLoader(null, -1, false);
			qDllQueue.add(gLoader, "DLL" + PXHashCode.nextKey, info.url, new LoaderContext(false, ApplicationDomain.currentDomain));
		}

		/**
		 * @inheritDoc
		 */
		public function buildResource( valueObject : PXValueObject) : void
		{
			var info : PXResource = valueObject as PXResource;
			var loader : PXFileLoader = new PXFileLoader();
			
			if( info.type == URLLoaderDataFormat.BINARY )
			{
				loader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			
			PXResourceExpert.getInstance().register(info.ID, info);
			
			qRscQueue.add(loader, info.ID, info.url, new LoaderContext(false, ApplicationDomain.currentDomain));
		}

		/**
		 * @inheritDoc
		 */
		public function buildDisplayObject( valueObject : PXValueObject ) : void
		{
			var info : PXDisplayObjectInfo = valueObject as PXDisplayObjectInfo;

			if ( !info.isEmptyDisplayObject() )
			{
				var gLoader : PXGraphicLoader = new PXGraphicLoader(null, -1, info.isVisible);
				qGfxQueue.add(gLoader, info.ID, info.url, new LoaderContext(false, ApplicationDomain.currentDomain));
			}
			
			mDisplayObject.put(info.ID, info);

			if ( info.parentID ) 
			{
				mDisplayObject.get(info.parentID).addChild(info);
			} 
			else
			{
				sRootID = info.ID;
			}
		}

		/**
		 * Builds display list.
		 */
		public function buildDisplayList() : void
		{
			if( !PXCoreFactory.getInstance().isBeanRegistered(dpoTarget) )
			{
				PXCoreFactory.getInstance().register(getRootID(), dpoTarget);
			}
			
			_buildDisplayList(getRootID());
			fireEvent(PXDisplayObjectBuilderEvent.onDisplayObjectBuilderLoadInitEVENT);
		}

		/**
		 * Starts processing.
		 */
		public function execute( event : Event = null ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onDisplayObjectBuilderLoadStartEVENT);
			
			loadDLLQueue();
		}

		/**
		 * Loads DLL queue.( if any ).
		 * 
		 * <p>If queue is empty, pass to <code>loadRSCQueue()</code> method.</p>
		 * 
		 * @see #loadRSCQueue()
		 */
		public function loadDLLQueue() : void
		{
			if ( !(_executeQueueLoader(qDllQueue, onDLLLoadStart, onDLLLoadInit)) ) loadRSCQueue();
		}

		/**
		 * Triggered when DLL queue starts loading.
		 */
		public function onDLLLoadStart( event : PXLoaderEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onDLLLoadStartEVENT, event.loader);
		}

		/**
		 * Triggered when DLL queue loading is finished.
		 */
		public function onDLLLoadInit( event : PXLoaderEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onDLLLoadInitEVENT, event.loader);
			loadRSCQueue();
		}

		/**
		 * Loads Resources queue.( if any ).
		 * 
		 * <p>If queue is empty, pass to <code>loadDisplayObjectQueue()</code> method.</p>
		 * 
		 * @see #loadDisplayObjectQueue()
		 */
		public function loadRSCQueue() : void
		{
			if ( !(_executeQueueLoader(qRscQueue, onRSCLoadStart, onRSCLoadInit, qlOnRSCLoadInit)) ) loadDisplayObjectQueue();
		}

		/**
		 * Triggered when Resources queue starts loading.
		 */
		public function onRSCLoadStart( event : PXLoaderEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onRSCLoadStartEVENT, event.loader);
		}

		/**
		 * Triggered when Resources queue loading is finished.
		 */
		public function onRSCLoadInit( event : PXLoaderEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onRSCLoadInitEVENT, event.loader);
			
			PXResourceExpert.release();
			
			loadDisplayObjectQueue();
		}

		/**
		 * Loads Display objects queue.( if any ).
		 * 
		 * <p>If queue is empty, pass to <code>buildDisplayList()</code> method.</p>
		 * 
		 * @see #buildDisplayList()
		 */
		public function loadDisplayObjectQueue() : void
		{
			if ( !(_executeQueueLoader(qGfxQueue, onDisplayObjectLoadStart, onDisplayObjectLoadInit)) ) buildDisplayList();
		}

		/**
		 * Triggered when Display objects queue starts loading.
		 */
		public function onDisplayObjectLoadStart( event : PXLoaderEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onDisplayObjectLoadStartEVENT, event.loader);
		}

		/**
		 * Triggered when Display objects queue loading is finished.
		 */
		public function onDisplayObjectLoadInit( event : PXLoaderEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onDisplayObjectLoadInitEVENT, event.loader);
			buildDisplayList();
		}

		// QueueLoader callbacks
		/**
		 * Triggered when an element contains in queues starts loading.
		 */
		public function qlOnLoadStart( event : PXLoaderCollectionEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onLoadStartEVENT, event.currentLoader);
		}

		/**
		 * Triggered when an element contains in queues stops loading.
		 */
		public function qlOnLoadInit( event : PXLoaderCollectionEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onLoadInitEVENT, event.currentLoader);
		}

		/**
		 * Triggered when an element ( resources only ) contains in queues stops loading.
		 */
		public function qlOnRSCLoadInit( event : PXLoaderCollectionEvent ) : void
		{
			var loader : PXFileLoader = PXFileLoader(event.currentLoader);
			var nameID : String = loader.name;
			var content : Object = loader.content;
			var resource : PXResource = PXResourceExpert.getInstance().locate(nameID) as PXResource;
			
			if( resource.hasDeserializer() )
			{
				try
				{
					var deserializer : PXDeserializer = PXCoreFactory.getInstance().buildInstance(resource.deserializerClass) as PXDeserializer;
					content = deserializer.deserialize(content, null, nameID);
				}
				catch( err : Error )
				{
					PXDebug.WARN("Deserialization error for '" + nameID + "' resource; Raw data is registered.", this);
				}
			}
			
			PXResourceLocator.getInstance(resource.locator).register(nameID, content);
			
			fireEvent(PXLoaderEvent.onLoadInitEVENT, event.currentLoader);
		}

		/**
		 * Triggered during element, contained in queues, loading progession.
		 */
		public function qlOnLoadProgress( event : PXLoaderCollectionEvent ) : void
		{
			fireEvent(PXDisplayObjectBuilderEvent.onLoadProgressEVENT, event.currentLoader);
		}

		/**
		 * Triggered when a timout occurs during element, contained in 
		 * queues, loading.
		 */
		public function qlOnLoadTimeOut( event : PXLoaderCollectionEvent ) : void
		{
			PXDebug.ERROR(event.currentLoader.request.url + " :: " + event.errorMessage, this);
			
			fireEvent(PXDisplayObjectBuilderEvent.onLoadTimeOutEVENT, event.currentLoader);
		}

		/**
		 * Triggered when an error occurs during element, contained in 
		 * queues, fail.
		 */
		public function qlOnLoadError( event : PXLoaderCollectionEvent ) : void
		{
			PXDebug.ERROR(event.currentLoader.request.url + " :: " + event.errorMessage, this);
			
			fireEvent(PXDisplayObjectBuilderEvent.onLoadErrorEVENT, event.currentLoader, event.errorMessage);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addListener( listener : PXDisplayObjectBuilderListener ) : Boolean
		{
			return oEB.addListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener( listener : PXDisplayObjectBuilderListener ) : Boolean
		{
			return oEB.removeListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return oEB.addEventListener.apply(oEB, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return oEB.removeEventListener(type, listener);
		}

		/**
		 * @inheritDoc
		 */
		public function addCommandListener(listener : PXCommandListener, ...rest) : Boolean
		{
			if(listener != null) PXDebug.WARN("'listener' argument is not used in 'addCommandListener' implementation.", this);
			
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function removeCommandListener(listener : PXCommandListener) : Boolean
		{
			if(listener != null) PXDebug.WARN("'listener' argument is not used in 'removeCommandListener' implementation.", this);
			
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function run() : void
		{
			execute();
		}

		/**
		 * @inheritDoc
		 */
		public function get running() : Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function fireCommandEndEvent() : void
		{
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------

		protected function generateRootID() : String
		{
			sRootID = PXHashCode.getKey(this);
			return sRootID;
		}

		protected function fireEvent( type : String, loader : PXLoader = null, errorMessage : String = null ) : void
		{
			var event : PXDisplayObjectBuilderEvent = new PXDisplayObjectBuilderEvent(type, loader, errorMessage);
			oEB.broadcastEvent(event);
		}

		protected function buildEmptyObject( info : PXDisplayObjectInfo ) : Boolean
		{
			try
			{
				var oParent : DisplayObjectContainer = PXCoreFactory.getInstance().locate(info.parentID) as DisplayObjectContainer;

				var oDo : DisplayObject = PXCoreFactory.getInstance().buildInstance(info.type) as DisplayObject;

				if ( !(oDo is DisplayObject) )
				{
					throw new PXIllegalArgumentException(".buildDisplayList() failed. '" + info.type + "' doesn't extend DisplayObject.", this);
				}
				
				oDo.name = info.ID;
				
				oParent.addChild(oDo);
				
				PXCoreFactory.getInstance().register(info.ID, oDo);

				oEB.broadcastEvent(new PXDisplayObjectEvent(PXDisplayObjectEvent.onBuildDisplayObjectEVENT, oDo));
				return true;
			} 
			catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}

		protected function buildObject( info : PXDisplayObjectInfo ) : Boolean
		{
			try
			{
				var gl : PXGraphicLoader = PXLoaderLocator.getInstance().pixlib_GraphicLoader::getLoader(info.ID);
				var parent : DisplayObjectContainer = PXCoreFactory.getInstance().locate(info.parentID) as DisplayObjectContainer;
				
				gl.target = parent;
				if ( info.isVisible ) gl.show();
				
				PXCoreFactory.getInstance().register(info.ID, gl.displayObject);
	
				oEB.broadcastEvent(new PXDisplayObjectEvent(PXDisplayObjectEvent.onBuildDisplayObjectEVENT, gl.displayObject));
				return true;
			} 
			catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}

		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------

		private function _executeQueueLoader( ql : PXQueueLoader, startCallback : Function, endCallback : Function, itemCallback : Function = null ) : Boolean
		{
			if ( ql.length > 0 )
			{
				var f : Function = ( itemCallback == null ) ? qlOnLoadInit : itemCallback;
				
				ql.addEventListener(PXLoaderCollectionEvent.onItemLoadStartEVENT, qlOnLoadStart);
				ql.addEventListener(PXLoaderCollectionEvent.onItemLoadInitEVENT, f);
				ql.addEventListener(PXLoaderCollectionEvent.onLoadProgressEVENT, qlOnLoadProgress);
				ql.addEventListener(PXLoaderCollectionEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut);
				ql.addEventListener(PXLoaderCollectionEvent.onLoadErrorEVENT, qlOnLoadError);
				ql.addEventListener(PXLoaderCollectionEvent.onLoadStartEVENT, startCallback);
				ql.addEventListener(PXLoaderCollectionEvent.onLoadInitEVENT, endCallback);
				ql.execute();
				
				return true;
			} 
			else
			{
				return false;
			}
		}

		private function _buildDisplayList( ID : String ) : void
		{
			var info : PXDisplayObjectInfo = mDisplayObject.get(ID);

			if ( info != null )
			{
				if ( ID != getRootID() )
				{
					if ( info.isEmptyDisplayObject() )
					{
						if ( !buildEmptyObject(info) ) return ;
					} 
					else
					{
						if ( !buildObject(info) ) return;
					}
				}
				
				// recursivity
				if ( info.hasChild() )
				{
					var aChild : Array = info.getChild();
					var length : int = aChild.length;
					for ( var i : int = 0 ;i < length; i++ ) _buildDisplayList(aChild[i].ID);
				}
			}
		}
	}
}