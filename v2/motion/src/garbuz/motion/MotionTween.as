package garbuz.motion
{
	import garbuz.motion.errors.InvalidValueError;
	import garbuz.motion.properties.DefaultProperty;
	import garbuz.motion.properties.ITweenProperty;

	use namespace motion_internal;

	public class MotionTween
	{
		motion_internal var target:Object;

		motion_internal var prev:MotionTween;
		motion_internal var next:MotionTween;

		motion_internal var finished:Boolean = false;
		motion_internal var removed:Boolean = false;

		private var _duration:Number;
		private var _properties:Array = [];

		public function MotionTween(target:Object)
		{
			this.target = target;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// public
		//
		/////////////////////////////////////////////////////////////////////////////////////
		public function setDuration(value:Number):void
		{
			if (value <= 0)
				throw new InvalidValueError("setDuration", value);

			_duration = value;
		}

		public function to(properties:Object):void
		{
			initProperties(properties);
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private function initProperties(props:Object):void
		{
			for (var propName:String in props)
			{
				var property:ITweenProperty = new DefaultProperty(target, propName, target[propName]);
				_properties.push(property);
			}
		}

		motion_internal function dispose():void
		{
			target = null;
			next = null;
			prev = null;
		}

		motion_internal function doStep():void
		{
			for each (var property:ITweenProperty in _properties)
			{
				property.apply();
			}
		}
	}
}
