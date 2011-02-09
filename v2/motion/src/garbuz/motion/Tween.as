package garbuz.motion
{
	import flash.utils.getTimer;

	import garbuz.motion.errors.InvalidValueError;
	import garbuz.motion.properties.DefaultProperty;
	import garbuz.motion.properties.ITweenProperty;

	use namespace motion_internal;

	public class Tween
	{
		motion_internal var prev:Tween;
		motion_internal var next:Tween;

		motion_internal var completed:Boolean = false;
		motion_internal var removed:Boolean = false;
		motion_internal var chainTween:Tween = null;

		private var _easeFunction:Function;
		private var _duration:Number;
		private var _completeHandler:Function;
		private var _completeParams:Array;
		private var _updateHandler:Function;
		private var _updateParams:Array;

		private var _manager:TweenManager;
		private var _target:Object;
		private var _initialized:Boolean = false;
		private var _properties:Array = [];
		private var _startTime:Number;
		private var _endTime:Number;

		public function Tween(manager:TweenManager, target:Object, duration:Number)
		{
			_manager = manager;
			_target = target;

			_duration = (duration == -1)
					? _manager.defaultDuration
					: duration;

			if (_duration <= 0)
				throw new InvalidValueError("duration", duration);

			_duration *= 1000;
		}


		/////////////////////////////////////////////////////////////////////////////////////
		//
		// public
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public function easing(value:Function):Tween
		{
			if (value == null)
				throw new InvalidValueError("value", value);

			_easeFunction = value;

			return this;
		}

		public function to(properties:Object):Tween
		{
			if (!properties)
				throw new InvalidValueError("properties", properties);

			initProperties(properties);

			return this;
		}

		public function onUpdate(handler:Function, ...args):Tween
		{
			_updateHandler = handler;
			_updateParams = args;
			return this;
		}

		public function onComplete(handler:Function, ...args):Tween
		{
			_completeHandler = handler;
			_completeParams = args;
			return this;
		}

		public function chain(duration:Number = -1):Tween
		{
			return chainTween = new Tween(_manager, _target, duration);
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private function initialize():void
		{
			if (_duration == 0)
				_duration = _manager.defaultDuration;

			if (_easeFunction == null)
				_easeFunction = _manager.defaultEasing;

			_startTime = getTimer();
			_endTime = _startTime + _duration;

			_initialized = true;
		}

		private function initProperties(props:Object):void
		{
			for (var propName:String in props)
			{
				var property:ITweenProperty = new DefaultProperty(_target, propName, props[propName]);
				_properties.push(property);
			}
		}

		motion_internal function dispose():void
		{
			_target = null;
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
				var easingPosition:Number = _easeFunction(timePosition);

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
