package garbuz.motion.properties
{
	public class DefaultProperty implements ITweenProperty
	{
		protected var _target:Object;
		protected var _propName:String;
		protected var _startValue:Number;
		protected var _endValue:Number;

		public function DefaultProperty(propName:String)
		{
			_propName = propName;
		}

		public function initialize(target:Object, startValue:Object, endValue:Object):void
		{
			_target = target;
			_startValue = (startValue is Number) ? Number(startValue) : _target[_propName];
			_endValue = (endValue is Number) ? Number(endValue) : _target[_propName];
		}

		public function applyTween(position:Number):void
		{
			_target[_propName] = _startValue + position * (_endValue - _startValue)
		}

		public function applyComplete():void
		{
			_target[_propName] = _endValue;
		}
	}
}
