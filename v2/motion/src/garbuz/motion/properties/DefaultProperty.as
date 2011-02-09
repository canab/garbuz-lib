package garbuz.motion.properties
{
	public class DefaultProperty implements ITweenProperty
	{
		private var _target:Object;
		private var _propName:String;
		private var _startValue:Number;
		private var _endValue:Number;

		public function DefaultProperty(target:Object, propertyName:String, endValue:Number)
		{
			_target = target;
			_propName = propertyName;
			_endValue = endValue;

			_startValue = target[propertyName];
		}

		public function applyPosition(position:Number):void
		{
			_target[_propName] = _startValue + position * (_endValue - _startValue)
		}

		public function applyComplete():void
		{
			_target[_propName] = _endValue;
		}
	}
}
