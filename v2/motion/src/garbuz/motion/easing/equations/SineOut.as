package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	final public class SineOut implements IEasing
	{
		public function calculate(k:Number):Number
		{
			return Math.sin(k * (Math.PI / 2));
		}
	}
}