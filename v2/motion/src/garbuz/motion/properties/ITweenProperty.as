package garbuz.motion.properties
{
	public interface ITweenProperty
	{
		function setStartValue(value:Object):void;

		function setEndValue(value:Object):void;

		function applyPosition(relativeTime:Number):void;

		function applyEndValue():void;
	}
}
