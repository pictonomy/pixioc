package pluginB
{
	import net.pixlib.log.PXDebug;
	import net.pixlib.plugin.PXAbstractPlugin;

	import pluginB.command.ChangeProperty;
	import pluginB.event.EventList;
	import pluginB.view.BView;
	import pluginB.view.CView;

	/**
	 * Plugin implementation.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 *
	 * @authorRomain Ecarnot
	 */
	public class PluginB extends PXAbstractPlugin
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
		public function PluginB()
		{
			super();
		}

		/**
		 * Triggered when IoC process is finished.
		 *
		 * <p>Overrides method to customize plugin stat-up.</p>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		override public function onApplicationInit() : void
		{
			PXDebug.DEBUG("Plugin B ready", this);
			
			initMV();
			initController();

			super.onApplicationInit();
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * Inits Front controller.
		 */
		protected function initController() : void
		{
			controller.pushCommandClass(EventList.CHANGE_PROPERTY, ChangeProperty);
		}

		/**
		 * Inits Model View parts.
		 */
		protected function initMV() : void
		{
			new BView(this);
			new CView(this);
		}
	}
}
