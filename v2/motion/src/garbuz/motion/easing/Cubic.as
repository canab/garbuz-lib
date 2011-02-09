package garbuz.motion.easing
{

	import garbuz.motion.easing.equations.CubicEaseIn;
	import garbuz.motion.easing.equations.CubicEaseInOut;
	import garbuz.motion.easing.equations.CubicEaseOut;

	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Cubic
	{

		static public function get easeIn():IEasing
		{
			return new CubicEaseIn();
		}

		static public function get easeOut():IEasing
		{
			return new CubicEaseOut();
		}

		static public function get easeInOut():IEasing
		{
			return new CubicEaseInOut();
		}

	}

}