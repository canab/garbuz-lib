package garbuz.motion.easing
{

	import garbuz.motion.easing.equations.QuadEaseIn;
	import garbuz.motion.easing.equations.QuadEaseInOut;
	import garbuz.motion.easing.equations.QuadEaseOut;

	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Quad
	{

		static public function get easeIn():IEasing
		{
			return new QuadEaseIn();
		}

		static public function get easeOut():IEasing
		{
			return new QuadEaseOut();
		}

		static public function get easeInOut():IEasing
		{
			return new QuadEaseInOut();
		}

	}

}