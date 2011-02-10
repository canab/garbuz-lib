package garbuz.motion.properties
{
	public class DefaultProperty implements ITweenProperty
	{
		protected var _target:Object;
		protected var _propName:String;
		protected var _startValue:Number;
		protected var _endValue:Number;

		public function setObject(target:Object, propertyName:String):void
		{
			_target = target;
			_propName = propertyName;
		}

		public function setStartValue(value:Object):void
		{
			_startValue = Number(value);
		}

		public function setEndValue(value:Object):void
		{
			_endValue = Number(value);
		}

		public function applyPosition(position:Number):void
		{
			_target[_propName] = _startValue + position * (_endValue - _startValue)
		}

		public function applyEndValue():void
		{
			_target[_propName] = _endValue;
		}

		public function getValueFromTarget():Object
		{
			return _target[_propName];
		}
	}
}
