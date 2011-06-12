package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class ExpoOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return t == 1
				? 1
				: -Math.pow(2, -10 * t) + 1;
		}
	}
}