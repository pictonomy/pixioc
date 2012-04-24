package pluginA
{
	import net.pixlib.log.PXDebug;
	import net.pixlib.events.PXNumberEvent;
	import net.pixlib.plugin.PXAbstractPlugin;
	import pluginA.command.ChangeProperty;
	import pluginA.event.EventList;
	import pluginA.view.AView;

	/**
	 * Plugin implementation.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
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
		 */
		override public function onApplicationInit() : void
		{
			PXDebug.DEBUG("Plugin A ready", this);
			
			initMV();
			initController();

			super.onApplicationInit();
		}

		/**
		 * Triggered by others plugin (Public access)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onChange(event : PXNumberEvent) : void
		{
			// Redirect event type to dispatch in FrontController private channel
			// but re use the same event instance (pooling)
			event.type = EventList.CHANGE_PROPERTY;

			firePrivateEvent(event);
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
			new AView(this);
		}
	}
}
