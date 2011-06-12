package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class QuadOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return -t * (t - 2);
		}
	}
}