package garbuz.motion
{
	public function motion(target:Object, duration:Number = -1):Tween
	{
		return TweenManager.tween(target);
	}
}
