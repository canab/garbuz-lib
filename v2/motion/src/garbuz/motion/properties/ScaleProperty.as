package garbuz.motion.properties
{
	public class ScaleProperty implements ITweenProperty
	{
		protected var _target:Object;
		protected var _startValue:Number;
		protected var _endValue:Number;

		public function initialize(target:Object, startValue:Object, endValue:Object):void
		{
			_target = target;
			_startValue = (startValue is Number) ? Number(startValue) : currentScale;
			_endValue = (endValue is Number) ? Number(endValue) : currentScale;
		}

		public function applyTween(position:Number):void
		{
			_target.scaleX = _target.scaleY = _startValue + position * (_endValue - _startValue);
		}

		public function applyComplete():void
		{
			_target.scaleX = _target.scaleY = _endValue;
		}
		
		private function get currentScale():Number
		{
			return 0.5 * (_target.scaleX + _target.scaleY);
		}

	}
}
