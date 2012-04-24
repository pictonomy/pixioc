package pluginA.view
{
	import net.pixlib.core.PXApplication;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.view.PXAbstractView;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * The AView view. 
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 *
	 * @author Romain Ecarnot
	 */
	public class AView extends PXAbstractView
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------
		private var _console : TextField;

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
		public function AView(owner : PXPlugin)
		{
			super(owner, ViewList.AVIEW, PXApplication.getInstance().root.addChild(new Sprite()));
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
		 */
		public function getContainer() : DisplayObjectContainer
		{
			return content as DisplayObjectContainer;
		}

		/**
		 * Triggered when model has changed.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 */
		public function changeTo(value : Number) : void
		{
			_console.text = "change to " + value;
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * Triggered when view is initialized.
		 */
		override protected function onInitView() : void
		{
			_console = getContainer().addChild(new TextField()) as TextField;
			_console.autoSize = TextFieldAutoSize.LEFT;
			_console.text = "click on buttons";

			super.onInitView();
		}
	}
}