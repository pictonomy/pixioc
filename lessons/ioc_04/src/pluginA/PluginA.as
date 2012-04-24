package pluginA
{
	import net.pixlib.core.PXApplication;
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.load.PXResourceLocator;
	import net.pixlib.plugin.PXAbstractPlugin;
	import flash.display.DisplayObject;

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

			logger.debug("Format font " + PXCoreFactory.getInstance().locate("format").fontFamily, this);
			logger.debug("Format rank " + PXCoreFactory.getInstance().locate("format").rank, this);
			
			var gridObject : DisplayObject = PXResourceLocator.getInstance().locateDisplayObject("gridObject");
			PXApplication.getInstance().root.addChild(gridObject);

			var gridObject2 : DisplayObject = PXResourceLocator.getInstance().locateDisplayObject("gridObject2");
			PXApplication.getInstance().root.addChild(gridObject2);

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
