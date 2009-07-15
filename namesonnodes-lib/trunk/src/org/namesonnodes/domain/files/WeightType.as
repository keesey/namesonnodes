package org.namesonnodes.domain.files
{
	public final class WeightType
	{
		public static const GENERATION:WeightType = new WeightType(new Lock());
		public static const YEAR:WeightType = new WeightType(new Lock());
		public function WeightType(lock:Lock)
		{
			super();
		}
	}
}
class Lock
{
}
