package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class QuartInOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return (t *= 2) < 1
				? 0.5 * t * t * t * t
				: -0.5 * ((t -= 2) * t * t * t - 2);
		}
	}
}