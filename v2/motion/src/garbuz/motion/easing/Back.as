package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.BackIn;
	import garbuz.motion.easing.equations.BackInOut;
	import garbuz.motion.easing.equations.BackOut;

	public class Back
	{
		private static const S:Number = 1.70158;

		public static const easeIn:IEasing = new BackIn(S);
		public static const easeOut:IEasing = new BackOut(S);
		public static const easeInOut:IEasing = new BackInOut(S);

		public static function easeInWith(s:Number = S):IEasing
		{
			return new BackIn(s);
		}

		public static function easeOutWith(s:Number = S):IEasing
		{
			return new BackOut(s);
		}

		public static function easeInOutWith(s:Number = S):IEasing
		{
			return new BackInOut(s);
		}
	}
}
