package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.ExpoIn;
	import garbuz.motion.easing.equations.ExpoInOut;
	import garbuz.motion.easing.equations.ExpoOut;

	final public class Expo
	{
		public static const easeIn:IEasing = new ExpoIn();
		public static const easeOut:IEasing = new ExpoOut();
		public static const easeInOut:IEasing = new ExpoInOut();
	}

}
