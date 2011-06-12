package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.SineIn;
	import garbuz.motion.easing.equations.SineInOut;
	import garbuz.motion.easing.equations.SineOut;

	final public class Sine
	{
		public static const easeIn:IEasing = new SineIn();
		public static const easeOut:IEasing = new SineOut();
		public static const easeInOut:IEasing = new SineInOut();
	}
}
