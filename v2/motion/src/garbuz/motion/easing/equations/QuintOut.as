package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class QuintOut implements IEasing
	{
		public function calculate(t:Number):Number
		{
			return (t = t - 1) * t * t * t * t + 1;
		}
	}
}