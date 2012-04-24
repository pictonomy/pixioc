package runner
{
	import net.pixlib.ioc.runner.PXDefaultApplicationRunner;
	import net.pixlib.log.PXLogManager;
	import net.pixlib.log.PXTraceLayout;


	/**
	 * @author Romain Ecarnot
	 */
	public class SampleRunner extends PXDefaultApplicationRunner
	{
		public function SampleRunner()
		{
			PXLogManager.getInstance().addLogListener(PXTraceLayout.getInstance());
		}
	}
}
