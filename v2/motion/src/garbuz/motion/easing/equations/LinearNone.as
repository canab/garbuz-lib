package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class LinearNone implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return t;
		}
	}
}