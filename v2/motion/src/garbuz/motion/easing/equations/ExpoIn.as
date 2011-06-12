package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class ExpoIn implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return t == 0
				? 0
				: Math.pow(2, 10 * (t - 1));
		}
	}
}