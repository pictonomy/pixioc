package pluginA
{
	import net.pixlib.core.PXApplication;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.display.css.PXCSS;
	import net.pixlib.load.PXResourceLocator;
	import net.pixlib.plugin.PXAbstractPlugin;

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	/**
	 * Plugin implementation.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 *
	 * @authorRomain Ecarnot
	 */
	public class PluginA extends PXAbstractPlugin
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * Creates a PluginA instance.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		public function PluginA()
		{
			super();
		}

		/**
		 * Triggered when IoC process is finished.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		override public function onApplicationInit() : void
		{
			logger.debug("Plugin is ready", this);
			
			initMV();
			initController();

			super.onApplicationInit();
			
			// infoText
			logger.debug(PXResourceLocator.getInstance().locate("infoText"), this);
			
			// gridObject
			var gridObject : DisplayObject = PXResourceLocator.getInstance().locateDisplayObject("gridObject");
			PXApplication.getInstance().root.addChild(gridObject);
			
			// background
			var bg : DisplayObject = PXCoreFactory.getInstance().locate("store").resource;
			PXApplication.getInstance().root.addChild(bg);
			
			// CSS
			var css : PXCSS = PXResourceLocator.getInstance().locateCSS("style");
			logger.debug("Default fontSize = " + css.getProperty(".default", "fontSize"), this);
			logger.debug("Recu fontSize = " + css.getProperty(".recu", "fontSize"), this);
			logger.debug("Text fontSize = " + css.getProperty(".text", "fontSize"), this);
			logger.debug("Text fontSize = " + css.getProperty(".text2", "fontSize"), this);
			logger.debug("Style class = " + css.getStyle(".myclass"), this);
			logger.debug(".myclass effect is " + css.getProperty(".myclass", "effect"), this);

			// StyleVO dedicated compilation / DLL context inclusion required 
			// logger.debug("VO Mapping for '.myclass style is " + getQualifiedClassName(css.getStyle(".myclass")), this);

			logger.debug("VO Mapping for '.myclass style is " + StyleVO(css.getStyle(".myclass")), this);
		}
		
		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * Inits Front controller.
		 */
		protected function initController() : void
		{
		}

		/**
		 * Inits Model View parts.
		 */
		protected function initMV() : void
		{
		}
	}
}
