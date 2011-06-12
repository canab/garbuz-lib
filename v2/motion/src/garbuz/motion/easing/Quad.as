package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.QuadIn;
	import garbuz.motion.easing.equations.QuadInOut;
	import garbuz.motion.easing.equations.QuadOut;

	public class Quad
	{
		public static const easeIn:IEasing = new QuadIn();
		public static const easeOut:IEasing = new QuadOut();
		public static const easeInOut:IEasing = new QuadInOut();
	}
}
