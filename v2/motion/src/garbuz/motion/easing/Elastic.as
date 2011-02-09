package garbuz.motion.easing
{

	import garbuz.motion.easing.equations.ElasticEaseIn;
	import garbuz.motion.easing.equations.ElasticEaseInOut;
	import garbuz.motion.easing.equations.ElasticEaseOut;

	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Elastic
	{

		static public function get easeIn():IEasing
		{
			return new ElasticEaseIn(0.1, 0.4);
		}

		static public function get easeOut():IEasing
		{
			return new ElasticEaseOut(0.1, 0.4);
		}

		static public function get easeInOut():IEasing
		{
			return new ElasticEaseInOut(0.1, 0.4);
		}

		static public function easeInWith(a:Number, p:Number):IEasing
		{

			return new ElasticEaseIn(a, p);

		}

		static public function easeOutWith(a:Number, p:Number):IEasing
		{

			return new ElasticEaseOut(a, p);

		}

		static public function easeInOutWith(a:Number, p:Number):IEasing
		{

			return new ElasticEaseInOut(a, p);

		}

	}

}











