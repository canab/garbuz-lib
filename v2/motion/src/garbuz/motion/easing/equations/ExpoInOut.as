package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class ExpoInOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			if (t == 0)
				return 0;

			if (t == 1)
				return 1;

			return (t *= 2) < 1
				? 0.5 * Math.pow(2, 10 * (t - 1))
				: 0.5 * (-Math.pow(2, -10 * (t - 1)) + 2);
		}
	}
}