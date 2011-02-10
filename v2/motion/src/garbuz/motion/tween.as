package garbuz.motion
{
	/**
	 * Creates new tween
	 * @param target
	 * target object
	 * @param duration
	 * Tween time in seconds. If omitted defaultDuration value will be used.
	 * @see garbuz.motion.TweenManager.defaultDuration()
	 */
	public function tween(target:Object, duration:Number = -1):Tweener
	{
		return TweenManager.tween(target, duration);
	}
}
