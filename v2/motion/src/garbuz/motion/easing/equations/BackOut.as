package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class BackOut implements IEasing
	{
		public var s:Number;

		public function BackOut(s:Number)
		{
			this.s = s;
		}

		public function calculate(t:Number):Number
		{
			return (t = t - 1) * t * ((s + 1) * t + s) + 1;
		}
	}
}