package garbuz.motion.easing
{
	final public class Elastic
	{
		static public var easeIn:Function = easeInWith(0.1, 0.4);
		static public var easeOut:Function = easeOutWith(0.1, 0.4);
		static public var easeInOut:Function = easeInOutWith(0.1, 0.4);

		static public function easeInWith(a:Number, p:Number):Function
		{
			return function (k:Number):Number
			{
				if (k == 0)
					return 0;

				if (k == 1)
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

				return -(a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p));
			}
		}

		static public function easeOutWith(a:Number, p:Number):Function
		{
			return function (k:Number):Number
			{
				if (k == 0)
					return 0;

				if (k == 1)
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

				return (a * Math.pow(2, -10 * k) * Math.sin((k - s) * (2 * Math.PI) / p) + 1);
			}
		}

		static public function easeInOutWith(a:Number, p:Number):Function
		{
			return function (k:Number):Number
			{
				if (k == 0)
					return 0;

				if (k == 1)
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

				return (k *= 2) < 1
						? -0.5 * (a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p))
						: a * Math.pow(2, -10 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p) * .5 + 1;
			}
		}
	}

}