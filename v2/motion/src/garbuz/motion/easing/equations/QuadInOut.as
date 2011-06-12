package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class QuadInOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return (t *= 2) < 1
				? 0.5 * t * t
				: -0.5 * (--t * (t - 2) - 1);
		}
	}
}