package garbuz.motion
{
	public function tween(target:Object, duration:Number = -1):Tweener
	{
		return TweenManager.tween(target, duration);
	}
}
