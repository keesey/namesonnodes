package org.namesonnodes.flare.test
{
	import flexunit.framework.TestSuite;
	
	public class FlareTest extends TestSuite
	{
		public function FlareTest(param:Object=null)
		{
			super(param);
		}
		public static function suite():TestSuite
		{
			const newTestSuite:TestSuite = new TestSuite();
			newTestSuite.addTestSuite(PhylogenyVisualizationTest);
			return newTestSuite;
		}
	}
}