package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class SineIn implements IEasing
	{
		public function calculate(k:Number):Number
		{
			return 1 - Math.cos(k * (Math.PI / 2));
		}
	}
}