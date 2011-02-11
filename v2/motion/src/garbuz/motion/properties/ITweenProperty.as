package garbuz.motion.properties
{
	public interface ITweenProperty
	{
		function initialize(target:Object, startValue:Object, endValue:Object):void

		function applyTween(relativeTime:Number):void;

		function applyComplete():void;
	}
}
