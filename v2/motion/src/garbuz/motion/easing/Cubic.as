package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.CubicIn;
	import garbuz.motion.easing.equations.CubicInOut;
	import garbuz.motion.easing.equations.CubicOut;

	final public class Cubic
	{
		public static const easeIn:IEasing = new CubicIn();
		public static const easeOut:IEasing = new CubicOut();
		public static const easeInOut:IEasing = new CubicInOut();
	}
}
