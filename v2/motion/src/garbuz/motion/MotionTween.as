package garbuz.motion
{

	use namespace motion_internal;

	public class MotionTween
	{
		motion_internal var target:Object;

		motion_internal var prev:MotionTween;
		motion_internal var next:MotionTween;

		public function MotionTween(target:Object)
		{
			this.target = target;
		}

		motion_internal function dispose():void
		{
			target = null;
			next = null;
			prev = null;
		}
	}
}
