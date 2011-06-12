package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	final public class SineInOut implements IEasing
	{
		public function calculate(k:Number):Number
		{
			return - (Math.cos(Math.PI * k) - 1) / 2;
		}
	}
}