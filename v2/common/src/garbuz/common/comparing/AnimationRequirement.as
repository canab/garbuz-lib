package garbuz.common.comparing
{
	import flash.display.MovieClip;

	/**
	* ...
	* @author canab
	*/
	public class AnimationRequirement implements IRequirement
	{
		public function AnimationRequirement()
		{
		}
		
		public function accept(object:Object):Boolean
		{
			return (object is MovieClip) && MovieClip(object).totalFrames > 1;
		}
		
	}
}