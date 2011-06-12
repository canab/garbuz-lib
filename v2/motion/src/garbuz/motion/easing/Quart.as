package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.QuartIn;
	import garbuz.motion.easing.equations.QuartInOut;
	import garbuz.motion.easing.equations.QuartOut;

	final public class Quart
	{
		public static const easeIn:IEasing = new QuartIn();
		public static const easeOut:IEasing = new QuartOut();
		public static const easeInOut:IEasing = new QuartInOut();
	}
}
