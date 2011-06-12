package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class CubicOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return --t * t * t + 1;
		}
	}
}