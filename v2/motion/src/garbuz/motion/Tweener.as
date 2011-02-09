package garbuz.motion
{
	import flash.utils.getTimer;

	import garbuz.motion.errors.InvalidValueError;
	import garbuz.motion.properties.DefaultProperty;
	import garbuz.motion.properties.ITweenProperty;

	use namespace motion_internal;

	public class Tweener
	{
		motion_internal var prev:Tweener;
		motion_internal var next:Tweener;
		motion_internal var chain:Tweener;

		motion_internal var completed:Boolean = false;
		motion_internal var removed:Boolean = false;

		private var _duration:Number;
		private var _parameters:Object;
		private var _easeFunction:Function;
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

		public function Tweener(manager:TweenManager, target:Object, duration:Number)
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

		public function easing(value:Function):Tweener
		{
			if (value == null)
				throw new InvalidValueError("value", value);

			_easeFunction = value;

			return this;
		}

		public function to(parameters:Object):Tweener
		{
			if (!parameters)
				throw new InvalidValueError("properties", parameters);

			_parameters = parameters;

			return this;
		}

		public function onUpdate(handler:Function, ...args):Tweener
		{
			_updateHandler = handler;
			_updateParams = args;
			return this;
		}

		public function onComplete(handler:Function, ...args):Tweener
		{
			_completeHandler = handler;
			_completeParams = args;
			return this;
		}

		public function tween(duration:Number = -1):Tweener
		{
			return chain = new Tweener(_manager, _target, duration);
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

			initProperties();

			_startTime = getTimer();
			_endTime = _startTime + _duration;

			_initialized = true;
		}

		private function initProperties():void
		{
			for (var propName:String in _parameters)
			{
				var propValue:Number = _parameters[propName];
				var property:ITweenProperty = new DefaultProperty(_target, propName, propValue);
				_properties.push(property);
			}
		}

		motion_internal function dispose():void
		{
			_target = null;
			
			_completeHandler = null;
			_completeParams = null;
			_updateHandler = null;
			_updateParams = null;

			next = null;
			prev = null;
			chain = null;
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

		motion_internal function addTime(time:Number):void
		{
			_startTime += time;
			_endTime += time;
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
