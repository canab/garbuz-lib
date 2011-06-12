package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class BackIn implements IEasing
	{
		public var s:Number;

		public function BackIn(s:Number)
		{
			this.s = s;
		}

		public function calculate(t:Number):Number
		{
			return t * t * ((s + 1) * t - s);
		}
	}
}