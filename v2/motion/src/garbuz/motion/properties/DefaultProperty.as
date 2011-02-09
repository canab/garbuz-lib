package garbuz.motion.properties
{
	import garbuz.motion.motion_internal;

	public class DefaultProperty implements ITweenProperty
	{
		private var _target:Object;
		private var _name:String;
		private var _startValue:Number;
		private var _endValue:Number;

		public function DefaultProperty(target:Object, propertyName:String, endValue:Number)
		{
			_target = target;
			_name = propertyName;
			_endValue = endValue;

			_startValue = target[propertyName];
		}

		public function apply():void
		{
		}
	}
}
