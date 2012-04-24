package runner
{
	import net.pixlib.ioc.parser.factory.xml.PXAttributeAsPropertyProcessor;
	import net.pixlib.ioc.runner.PXDefaultApplicationRunner;
	import net.pixlib.log.PXLogManager;
	import net.pixlib.log.PXTraceLayout;

	/**
	 * @author Romain Ecarnot
	 */
	public class SampleRunner extends PXDefaultApplicationRunner
	{
		override protected function initLogger() : void
		{
			super.initLogger();

			PXLogManager.getInstance().addLogListener(PXTraceLayout.getInstance());
		}

		override protected function preprocess() : void
		{
			oLoader.addProcessor(new PXAttributeAsPropertyProcessor("format"));
			oLoader.addProcessingVariable("lang", "fr");
			oLoader.addProcessingVariable("local", null, "culture");
			
			super.preprocess();
		}
	}
}
