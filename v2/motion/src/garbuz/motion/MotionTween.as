package garbuz.motion
{
	import flash.utils.getTimer;

	import garbuz.motion.easing.IEasing;
	import garbuz.motion.errors.InvalidValueError;
	import garbuz.motion.properties.DefaultProperty;
	import garbuz.motion.properties.ITweenProperty;

	use namespace motion_internal;

	public class MotionTween
	{
		motion_internal var target:Object;

		motion_internal var prev:MotionTween;
		motion_internal var next:MotionTween;

		motion_internal var completed:Boolean = false;
		motion_internal var removed:Boolean = false;

		private var _initialized:Boolean = false;

		private var _easing:IEasing;
		private var _duration:Number;
		private var _completeHandler:Function;
		private var _completeParams:Array;
		private var _updateHandler:Function;
		private var _updateParams:Array;

		private var _properties:Array = [];
		private var _startTime:Number;
		private var _endTime:Number;

		public function MotionTween(target:Object)
		{
			this.target = target;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// public
		//
		/////////////////////////////////////////////////////////////////////////////////////
		public function easing(value:IEasing):MotionTween
		{
			if (!value)
				throw new InvalidValueError("value", value);

			_easing = value;

			return this;
		}

		public function duration(value:Number):MotionTween
		{
			if (value <= 0)
				throw new InvalidValueError("duration", value);

			_duration = value * 1000;

			return this;
		}

		public function to(properties:Object):MotionTween
		{
			if (!properties)
				throw new InvalidValueError("properties", properties);

			initProperties(properties);

			return this;
		}

		public function onUpdate(handler:Function, ...args):MotionTween
		{
			_updateHandler = handler;
			_updateParams = args;
			return this;
		}

		public function onComplete(handler:Function, ...args):MotionTween
		{
			_completeHandler = handler;
			_completeParams = args;
			return this;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private function initialize():void
		{
			_startTime = getTimer();
			_endTime = _startTime + _duration;

			_initialized = true;
		}

		private function initProperties(props:Object):void
		{
			for (var propName:String in props)
			{
				var property:ITweenProperty = new DefaultProperty(target, propName, props[propName]);
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
			if (!_initialized)
				initialize();

			var timePosition:Number = (TweenManager.currentTime - _startTime) / _duration;

			if (timePosition < 1)
			{
				var easingPosition:Number = _easing.calculate(timePosition);

				for each (var property:ITweenProperty in _properties)
				{
					property.applyPosition(easingPosition);
				}
			}
			else
			{
				applyComplete();
			}

			if (_updateHandler != null)
				_updateHandler.apply(null, _updateParams);

			if (completed && _completeHandler != null)
				_completeHandler.apply(null, _completeParams);
		}

		private function applyComplete():void
		{
			completed = true;

			for each (var property:ITweenProperty in _properties)
			{
				property.applyComplete();
			}
		}

	}
}
