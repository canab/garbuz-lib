package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class BackInOut implements IEasing
	{
		public var s:Number;

		public function BackInOut(s:Number)
		{
			this.s = s * 1.525;
		}

		public function calculate(t:Number):Number
		{
			return (t *= 2) < 1
				? 0.5 * (t * t * ((s + 1) * t - s))
				: 0.5 * ((t -= 2) * t * ((s + 1) * t + s) + 2);
		}
	}
}