package pluginB.view
{
	import net.pixlib.events.PXNumberEvent;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.view.PXAbstractView;
	import pluginB.event.EventList;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * The BView view. 
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 *
	 * @author Romain Ecarnot
	 */
	public class BView extends PXAbstractView
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * Creates instance.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		public function BView(owner : PXPlugin)
		{
			super(owner, ViewList.BVIEW);
		}

		/**
		 * Returns <code>DisplayObjectContainer</code> instance of current 
		 * view.
		 * 
		 * @return The <code>DisplayObjectContainer</code> instance of current 
		 * view.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion FDT 3.5
		 */
		public function getContainer() : DisplayObjectContainer
		{
			return content as DisplayObjectContainer;
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * View is initialized.
		 */
		override protected function onInitView() : void
		{
			var button : Sprite = resolveUI("button") as Sprite;
			button.buttonMode = true;
			button.addEventListener(MouseEvent.CLICK, _onClickHandler);

			super.onInitView();
		}

		private function _onClickHandler(event : MouseEvent) : void
		{
			event.stopImmediatePropagation();

			firePrivateEvent(new PXNumberEvent(EventList.CHANGE_PROPERTY, this, Math.random()));
		}
	}
}