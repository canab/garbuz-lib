package garbuz.motion.properties
{
	public class ScaleProperty extends DefaultProperty
	{
		override public function applyPosition(position:Number):void
		{
			_target.scaleX = _target.scaleY = _startValue + position * (_endValue - _startValue);
		}

		override public function applyEndValue():void
		{
			_target.scaleX = _target.scaleY = _endValue;
		}

		override public function getValueFromTarget():Object
		{
			return 0.5 * (_target.scaleX + _target.scaleY);
		}
	}
}
