package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.QuintIn;
	import garbuz.motion.easing.equations.QuintInOut;
	import garbuz.motion.easing.equations.QuintOut;

	final public class Quint
	{
		public static const easeIn:IEasing = new QuintIn();
		public static const easeOut:IEasing = new QuintOut();
		public static const easeInOut:IEasing = new QuintInOut();
	}
}
