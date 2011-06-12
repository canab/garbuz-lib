package garbuz.motion.easing.equations
{
	import garbuz.motion.IEasing;

	public class ElasticIn implements IEasing
	{
		public var a:Number;
		public var p:Number;

		public function ElasticIn(a:Number, p:Number)
		{
			this.a = a;
			this.p = p;
		}

		public function calculate(t:Number):Number
		{
			if (t == 0)
				return 0;

			if (t == 1)
				return 1;

			if (!p)
				p = 0.3;

			var s:Number;

			if (!a || a < 1)
			{
				a = 1;
				s = p / 4;
			}
			else
			{
				s = p / (2 * Math.PI) * Math.asin(1 / a);
			}

			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p));
		}
	}
}