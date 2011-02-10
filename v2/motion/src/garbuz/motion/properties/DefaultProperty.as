package garbuz.motion.properties
{
	public class DefaultProperty implements ITweenProperty
	{
		private var _target:Object;
		private var _propName:String;
		private var _startValue:Number;
		private var _endValue:Number;

		public function DefaultProperty(target:Object, propertyName:String)
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
	}
}
