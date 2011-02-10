package garbuz.motion.properties
{
	public interface ITweenProperty
	{
		function setObject(target:Object, propertyName:String):void

		function setStartValue(value:Object):void;

		function setEndValue(value:Object):void;

		function applyPosition(relativeTime:Number):void;

		function applyEndValue():void;

		function getValueFromTarget():Object;
	}
}
