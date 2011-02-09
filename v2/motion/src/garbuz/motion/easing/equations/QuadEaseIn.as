package garbuz.motion.easing.equations
{

	import garbuz.motion.easing.IEasing;

	/**
	 * @author Joshua Granick
	 */
	final public class QuadEaseIn implements IEasing
	{

		public function calculate(k:Number):Number
		{

			return k * k;

		}

		public function ease(t:Number, b:Number, c:Number, d:Number):Number
		{

			return c * (t /= d) * t + b;

		}

	}

}