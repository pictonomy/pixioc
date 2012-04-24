package pluginB.command
{
	import net.pixlib.commands.PXAbstractCommand;
	import net.pixlib.events.PXNumberEvent;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import flash.events.Event;

	/**
	 * The ChangeProperty command.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion FDT 3.5
	 *
	 * @author Romain Ecarnot	 
	 */
	public class ChangeProperty extends PXAbstractCommand
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
		 * @productversion FDT 3.5
		 */
		public function ChangeProperty()
		{
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * Executes command.
		 * 
		 * @param	event	An event object that will be used as data source by the command
		 */
		override protected function onExecute(event : Event = null) : void
		{
			if (event == null || !event is PXNumberEvent)
			{
				var msg : String = this + ".execute() failed, event data is unreachable";
				throw new PXIllegalArgumentException(msg, this);
			}
			else
			{
				PXNumberEvent(event).type = "onChange";
				// pooling
				owner.firePublicEvent(event);
			}
		}
	}
}