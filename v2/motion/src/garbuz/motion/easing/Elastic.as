package garbuz.motion.easing
{
	import garbuz.motion.IEasing;
	import garbuz.motion.easing.equations.ElasticIn;
	import garbuz.motion.easing.equations.ElasticInOut;
	import garbuz.motion.easing.equations.ElasticOut;

	final public class Elastic
	{
		private static const A:Number = 0.1;
		private static const P:Number = 0.4;

		public static const easeIn:IEasing = new ElasticIn(A, P);
		public static const easeOut:IEasing = new ElasticOut(A, P);
		public static const easeInOut:IEasing = new ElasticInOut(A, P);

		public static function easeInWith(a:Number = A, p:Number = P):IEasing
		{
			return new ElasticIn(a, p);
		}

		public static function easeOutWith(a:Number = A, p:Number = P):IEasing
		{
			return new ElasticOut(a, p);
		}

		public static function easeInOutWith(a:Number = A, p:Number = P):IEasing
		{
			return new ElasticInOut(a, p);
		}
	}
}
