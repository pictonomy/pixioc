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
package net.pixlib.ioc.load 
{
	import net.pixlib.commands.PXCommand;
	import net.pixlib.commands.PXCommandListener;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.ioc.assembler.PXApplicationAssembler;
	import net.pixlib.ioc.assembler.PXDefaultApplicationAssembler;
	import net.pixlib.ioc.assembler.builder.PXDefaultDisplayObjectBuilder;
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilder;
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderEvent;
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectBuilderListener;
	import net.pixlib.ioc.assembler.builder.PXDisplayObjectEvent;
	import net.pixlib.ioc.assembler.locator.PXChannelListenerExpert;
	import net.pixlib.ioc.assembler.locator.PXConstructorExpert;
	import net.pixlib.ioc.assembler.locator.PXImportExpert;
	import net.pixlib.ioc.assembler.locator.PXMethodExpert;
	import net.pixlib.ioc.assembler.locator.PXPluginExpert;
	import net.pixlib.ioc.assembler.locator.PXPropertyExpert;
	import net.pixlib.ioc.assembler.locator.PXResourceExpert;
	import net.pixlib.ioc.display.PXDisplayLoaderInfo;
	import net.pixlib.ioc.display.PXDisplayLoaderProxy;
	import net.pixlib.ioc.parser.PXContextParser;
	import net.pixlib.ioc.parser.PXParserCollection;
	import net.pixlib.ioc.parser.PXXMLCollection;
	import net.pixlib.load.PXAbstractLoader;
	import net.pixlib.load.PXFileLoader;
	import net.pixlib.load.PXLoader;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.PXLoaderListener;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * IoC Application context loader.
	 * 
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	public class PXApplicationLoader extends PXAbstractLoader
		implements PXLoaderListener, PXDisplayObjectBuilderListener, PXCommandListener
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * Default IoC context file name.
		 * 
		 * @default "applicationContext.xml"
		 */
		static public const DEFAULT_NAME : String = "applicationContext.xml";

		/**
		 * Default IoC context file URL.
		 * 
		 * @default "applicationContext.xml" request
		 */
		static public const DEFAULT_REQUEST : URLRequest = new URLRequest(DEFAULT_NAME);

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
				
		/** @private */
		protected var oRootTarget : DisplayObjectContainer;

		/** @private */
		protected var oDisplayObjectBuilder : PXDisplayObjectBuilder;

		/** @private */
		protected var oApplicationAssembler : PXApplicationAssembler;

		/** @private */
		protected var oParserCollection : PXParserCollection;

		/** @private */
		protected var oDLoader : PXDisplayLoaderProxy;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * <code>ApplicationAssembler</code> used in by this loader.
		 */
		public function get applicationAssembler() : PXApplicationAssembler
		{
			return oApplicationAssembler;
		}

		/**
		 * @private
		 */
		public function set applicationAssembler(value : PXApplicationAssembler) : void
		{
			oApplicationAssembler = value;
		}
		
		/**
		 * Parser collection used by assembler.
		 */
		public function get parserCollection() : PXParserCollection
		{
			return oParserCollection;
		}

		/**
		 * @private
		 */
		public function set parserCollection(value : PXParserCollection) : void
		{
			oParserCollection = value;
		}
		
		/**
		 * The <code>DisplayObjectBuilder</code> used by this loader 
		 * to load and build all context elements.
		 */
		public function get displayObjectBuilder() : PXDisplayObjectBuilder
		{
			return oDisplayObjectBuilder;
		}
		
		/**
		 * @private
		 */
		public function set displayObjectBuilder(value : PXDisplayObjectBuilder) : void
		{
			oDisplayObjectBuilder = value;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates loader instance.
		 * 
		 * @param	rootTarget	Main sprite target for display tree creation.
		 * @param	autoExecute	(optional) <code>true</code> to start loading 
		 * 						just after loader instanciation.
		 * @param	url			URL request for 'applicationContext' file 
		 * 						to load.
		 */
		public function PXApplicationLoader( 	rootTarget : DisplayObjectContainer, 
											autoExecute : Boolean = false, 
											loadingRequest : URLRequest = null )
		{
			super();
			
			setListenerType(PXApplicationLoaderListener);
			
			oRootTarget = rootTarget;
			
			request = loadingRequest ? loadingRequest : PXApplicationLoader.DEFAULT_REQUEST;
			
			applicationAssembler = new PXDefaultApplicationAssembler();
			displayObjectBuilder = new PXDefaultDisplayObjectBuilder();
			parserCollection = new PXXMLCollection();
				
			if ( autoExecute ) execute();
		}

		/**
		 * Sets new pair name / value for variable replacement when context 
		 * file will be laoded.
		 * 
		 * @param	name	Name of the variable to replace.
		 * @param	value	New value for this variable.
		 * 
		 * @example Variable definition somewhere in the xml context :
		 * <pre class="prettyprint">
		 * 
		 * ${POSITION_X}
		 * </pre>
		 * 
		 * @example Setting this variable using setVariable() method :
		 * <pre class="prettyprint">
		 * 
		 * rtLoader.addProcessingVariable( "POSITION_X", 200 );
		 * </pre>
		 */
		public function addProcessingVariable( name : String, value : *, flashvarName : String = null ) : void
		{
			parserCollection.getASPreProcessor().addVariable(name, value, flashvarName);
		}

		/**
		 * Adds new preprocessing method.
		 * 
		 * <p>Preprocessing act after xml loading and before context parsing.<br />
		 * Used to transform context data on fly.</p>
		 * 
		 * @param	processingMethod	Method to call.<br/>
		 * 								Method must accept an XML object as first argument 
		 * 								and return an XML object when completed.
		 * 	@param	...					Additionals parameters to pass to method when 
		 * 								executing.
		 * 								
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var oLoader : ApplicationLoader = new ApplicationLoader( this, false );
		 * oLoader.addProcessingMethod( XMLProcessingHelper.changeObjectAttribute, "cross", "visible", "false" );
		 * oLoader.addProcessingMethod( XMLProcessingHelper.changePropertyValue, "cross", "x", 600 );
		 * oLoader.addProcessingMethod( XMLProcessingHelper.addResource, "newStyle", "myStyle.css" );
		 * </pre>
		 * 
		 * @see net.pixlib.ioc.context.processor.ProcessingHelper 
		 */
		public function addProcessingMethod( processingMethod : Function, ...args ) : void
		{
			parserCollection.getASPreProcessor().addMethod(processingMethod, args);
		}

		/**
		 * Adds new pre processing processor.
		 * 
		 * <p>Preprocessing act after xml loading and before context parsing.<br />
		 * Used to transform context data on fly.</p>
		 * 
		 * @example
		 * <pre class="prettyprint">
		 * 
		 * var loader : ApplicationLoader = new ApplicationLoader( this, false );
		 * loader.addProcessor( new LocalisationProcessor() );
		 * </pre>
		 */
		public function addProcessor( processor : PXCommand ) : void
		{
			parserCollection.getASPreProcessor().addProcessor(processor);
		}
		
		/**
		 * Adds the passed-in <code>listener</code> as listener for all 
		 * events dispatched by loader.
		 * 
		 * @param	listener	<code>ApplicationLoaderListener</code> instance.
		 */
		public function addApplicationLoaderListener( listener : PXApplicationLoaderListener ) : Boolean
		{
			return addListener(listener);
		}

		/**
		 * Removes the passed-in <code>listener</code> object from loader. 
		 * 
		 * @param	listener	<code>ApplicationLoaderListener</code> instance.
		 */
		public function removeApplicationLoaderListener( listener : PXApplicationLoaderListener ) : Boolean
		{
			return removeListener(listener);
		}

		/**
		 * Attaches IoC DisplayLoader now.
		 */
		public function setDisplayLoader( mc : DisplayObjectContainer, info : PXDisplayLoaderInfo ) : void
		{
			if( oDLoader ) removeListener(oDLoader);
			
			oDLoader = new PXDisplayLoaderProxy(mc, info);
			addListener(oDLoader);
		}

		/**
		 * Returns IoC DisplayLoader ( if exist ).
		 */
		public function getDisplayLoader( ) : PXDisplayLoaderProxy
		{
			return oDLoader;
		}

		/**
		 * Starts context loading.
		 * 
		 * @param	url		(optional) URL request for 'applicationContext' file 
		 * 					to load.
		 * @param	context	(optional) <code>LoaderContext</code> definition.
		 */
		override public function load( loadingRequest : URLRequest = null, loadingContext : LoaderContext = null ) : void
		{
			if ( loadingRequest != null ) request = loadingRequest;
			if ( loadingContext != null ) context = loadingContext;

			execute();
		}

		override protected function onExecute( event : Event = null ) : void
		{
			if ( request.url.length > 0 )
			{
				var loader : PXLoader = getContextLoader();
				loader.request = request;
				loader.addEventListener(PXLoaderEvent.onLoadInitEVENT, onContextLoaderLoadInit);
				loader.addEventListener(PXLoaderEvent.onLoadProgressEVENT, this);
				loader.addEventListener(PXLoaderEvent.onLoadTimeOutEVENT, this);
				loader.addEventListener(PXLoaderEvent.onLoadErrorEVENT, this);
				
				loader.load(request, context);
			} 
			else
			{
				throw new PXNullPointerException(".load() can't retrieve file url.", this);
			}
		}

		/**
		 * Parse raw data without loading.
		 * 
		 * @param	rawData	Data to parse (ex: XML data) 
		 */
		public function parseContext( rawData : * ) : void
		{
			clearExperts();
			initParsing();
			runParsing(rawData);	
		}

		/**
		 * Triggered when Ioc Parsing is beginning.
		 * 
		 * @param	e	event dispatched by the command
		 */
		public function onCommandStart( event : PXCommandEvent ) : void
		{
			// do nothing.
		}

		/**
		 * Triggered when Ioc Parsing is complete.
		 * 
		 * @param	e	event dispatched by the command
		 */
		public function onCommandEnd( event : PXCommandEvent ) : void
		{
			try
			{
				PXCommand(event.target).removeCommandListener(this);
			}
			catch( e : Error ) 
			{
				//
			}
			finally
			{
				displayObjectBuilder.addListener(this);
				displayObjectBuilder.execute();
			}
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationStartEVENT</code> 
		 * event type when xml is parsed.
		 */
		public function fireOnApplicationStart() : void
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationLoadStartEVENT, this));
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationStateEVENT</code> when IOC engine 
		 * processing change his state ( DLL, Resources, GFX, etc. )
		 */
		public function fireOnApplicationState( state : String ) : void
		{
			var event : PXApplicationLoaderEvent = new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationStateEVENT, this);
			event.state = state;	
			
			fireEvent(event);
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationParsedEVENT</code> 
		 * event type when xml is parsed.
		 */
		public function fireOnApplicationParsed() : void
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationParsedEVENT, this));
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationObjectsBuiltEVENT</code> 
		 * event type when all elements in xml are built.
		 */
		public function fireOnObjectsBuilt() : void
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationObjectsBuiltEVENT, this));
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationChannelsAssignedEVENT</code> 
		 * event type when all plugin channels are initialized.
		 */
		public function fireOnChannelsAssigned() : void
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationChannelsAssignedEVENT, this));
		}

		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationMethodsCalledEVENT</code> 
		 * event type when all <code>method-call</code> are executed.
		 */
		public function fireOnMethodsCalled() : void
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationMethodsCalledEVENT, this));
		}
		
		/**
		 * Broadcasts <code>ApplicationLoaderEvent.onApplicationInitEVENT</code> 
		 * event type when application is ready.
		 */
		public function fireOnApplicationInit() : void 
		{
			fireEvent(new PXApplicationLoaderEvent(PXApplicationLoaderEvent.onApplicationInitEVENT, this));
			
			fireOnApplicationState(PXApplicationLoaderState.COMPLETE_STATE);
			
			if( oDLoader != null ) removeListener(oDLoader);
			
			release();
			
			PXPluginExpert.getInstance().notifyAllPlugins();
			
			PXChannelListenerExpert.release();
			PXConstructorExpert.release();
			PXMethodExpert.release();
			PXPropertyExpert.release();			PXImportExpert.release();			PXResourceExpert.release();
		}

		/**
		 * @inheritdoc
		 */
		public function onLoadStart( event : PXLoaderEvent ) : void
		{
			fireEvent(event);
		}

		/**
		 * @inheritdoc
		 */
		public function onLoadInit( event : PXLoaderEvent ) : void
		{
			fireEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadProgress( event : PXLoaderEvent ) : void
		{
			fireEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadTimeOut( event : PXLoaderEvent ) : void
		{
			fireOnLoadTimeOut();
		}

		/**
		 * @inheritDoc
		 */
		public function onLoadError( event : PXLoaderEvent ) : void
		{
			fireOnLoadErrorEvent(event.errorMessage);
		}

		/**
		 * DisplayObjectExpert callbacks
		 */
		public function onBuildDisplayObject( event : PXDisplayObjectEvent ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectBuilderLoadStart( event : PXDisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationStart();
		}

		/**
		 * @inheritDoc
		 */
		public function onDLLLoadStart( event : PXDisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationState(PXApplicationLoaderState.DLL_LOAD_STATE);
		}

		/**
		 * @inheritDoc
		 */
		public function onDLLLoadInit( event : PXDisplayObjectBuilderEvent ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onRSCLoadStart( event : PXDisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationState(PXApplicationLoaderState.RSC_LOAD_STATE);
		}

		/**
		 * @inheritDoc
		 */
		public function onRSCLoadInit( event : PXDisplayObjectBuilderEvent ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectLoadStart( event : PXDisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationState(PXApplicationLoaderState.GFX_LOAD_STATE);
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectLoadInit( event : PXDisplayObjectBuilderEvent ) : void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onDisplayObjectBuilderLoadInit( event : PXDisplayObjectBuilderEvent ) : void
		{
			fireOnApplicationParsed();
			
			fireOnApplicationState(PXApplicationLoaderState.BUILD_STATE);
			
			PXConstructorExpert.getInstance().buildAllObjects();
			fireOnObjectsBuilt();
			
			PXChannelListenerExpert.getInstance().assignAllChannelListeners();
			fireOnChannelsAssigned();
			
			PXMethodExpert.getInstance().callAllMethods();
			fireOnMethodsCalled();
			
			applicationAssembler = null;
			displayObjectBuilder = null;
			
			parserCollection.release();
			parserCollection = null;
			
			fireOnApplicationInit();
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Returns context Loader.
		 */
		protected function getContextLoader( ) : PXLoader
		{
			return new PXFileLoader(PXFileLoader.TEXT);
		}

		/**
		 * Triggered when the context file is loaded.
		 */
		protected function onContextLoaderLoadInit( event : PXLoaderEvent ) : void
		{
			event.loader.removeListener(this);
			
			clearExperts();
			initParsing();
			runParsing(getContextContent(event.loader));		}
		
		/**
		 * Returns loaded content.
		 * 
		 * <p>Overrides to customize loaded context content before 
		 * running IoC parsers.</p>
		 * 
		 * @param	loader	Context loader instance.
		 */
		protected function getContextContent( loader : PXLoader ) : *
		{
			return loader.content;
		}
		
		/**
		 * Clears all agregators.
		 */
		protected function clearExperts( ) : void
		{
			PXChannelListenerExpert.getInstance().clear();
			PXConstructorExpert.getInstance().clear();
			PXImportExpert.getInstance().clear();
			PXMethodExpert.getInstance().clear();
			PXPropertyExpert.getInstance().clear();				PXResourceExpert.getInstance().clear();	
		}
		
		/**
		 * Inits parsing engine.
		 */
		protected function initParsing() : void
		{
			if ( displayObjectBuilder == null ) displayObjectBuilder = new PXDefaultDisplayObjectBuilder();
			if ( anticache ) displayObjectBuilder.anticache = true;
			
			displayObjectBuilder.rootTarget = oRootTarget;
			applicationAssembler.displayObjectBuilder = displayObjectBuilder;
		}
		
		/**
		 * Starts content parsing.
		 * 
		 * @param	rawData	The context content
		 */
		protected function runParsing( rawData : * ) : void
		{
			var cParser : PXContextParser = new PXContextParser(parserCollection);			cParser.setApplicationLoader(this);
			cParser.setContextData(rawData);
			cParser.addCommandListener(this);
			cParser.execute();	
		}

		/**
		 * @inheritDoc
		 */
		override protected function getLoaderEvent( type : String, errorMessage : String = "" ) : PXLoaderEvent
		{
			return new PXApplicationLoaderEvent(type, this, errorMessage);
		}
	}
}