package garbuz.motion.easing
{

	import garbuz.motion.easing.equations.QuintEaseIn;
	import garbuz.motion.easing.equations.QuintEaseInOut;
	import garbuz.motion.easing.equations.QuintEaseOut;

	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Quint
	{

		static public function get easeIn():IEasing
		{
			return new QuintEaseIn();
		}

		static public function get easeOut():IEasing
		{
			return new QuintEaseOut();
		}

		static public function get easeInOut():IEasing
		{
			return new QuintEaseInOut();
		}

	}

}