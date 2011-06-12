package garbuz.motion
{
	import flash.display.DisplayObject;

	import garbuz.motion.IEasing;

	import garbuz.motion.properties.ITweenProperty;
	import garbuz.motion.properties.NumberProperty;

	use namespace motion_internal;

	public class Tweener
	{
		motion_internal var prev:Tweener;
		motion_internal var next:Tweener;
		motion_internal var chain:Tweener;

		motion_internal var initialized:Boolean = false;
		motion_internal var completed:Boolean = false;
		motion_internal var removed:Boolean = false;
		motion_internal var target:Object;
		motion_internal var properties:Object = {};
		motion_internal var numProperties:int = 0;

		private var _duration:Number;
		private var _delay:Number = 0;
		private var _params:Object = {};
		private var _easing:IEasing;
		private var _completeHandler:Function;
		private var _completeParams:Array;
		private var _updateHandler:Function;
		private var _updateParams:Array;

		private var _manager:TweenManager;
		private var _startTime:Number;
		private var _autoDetach:Boolean = false;

		public function Tweener(manager:TweenManager, target:Object, duration:Number)
		{
			_manager = manager;

			this.target = target;

			_duration = (duration < 0)
					? _manager.defaultDuration * 1000
					: duration * 1000;
		}


		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// public
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		/**
		 * Sets ease function. Not required (default value will be used).
		 * @param value Function
		 *
		 * @example
		 * <code>easing(Elastic.easeOut)</code>
		 * 
		 * @see garbuz.motion.easing
		 * @see garbuz.motion.TweenManager.defaultEasing
		 */
		public function easing(value:IEasing):Tweener
		{
			if (!(value is Function))
				throw new ArgumentError(Errors.NOT_A_FUNCTION);

			_easing = value;

			return this;
		}

		/**
		 * Sets key-value object.
		 * Both from(...) and to(...) functions can be used together.
		 *
		 * @example
		 * <code>to({x:50, y:100})</code>
		 *
		 * @example
		 * <code>from({x:0, y:0}).to({x:50, y:100})</code>
		 */
		public function to(parameters:Object):Tweener
		{
			if (!parameters)
				throw new ArgumentError(Errors.NULL_POINTER);

			_params = parameters;

			return this;
		}

		/**
		 * Apply delay before an animation will be started.
		 * @param value delay time in seconds
		 */
		public function delay(value:Number):Tweener
		{
			if (value <= 0)
				throw new ArgumentError("Value should be >= 0");

			_delay = value * 1000;

			return this;
		}

		/**
		 * Set the function which should be invoked on each frame.
		 * @param handler Function
		 * @param args Function arguments
		 */
		public function onUpdate(handler:Function, ...args):Tweener
		{
			_updateHandler = handler;
			_updateParams = args;

			return this;
		}

		/**
		 * Set the function which should be invoked on animation complete.
		 * Function will not be invoked if Tween is terminated by killing or by overriding all properties.
		 * @param handler Function
		 * @param args Function arguments
		 */
		public function onComplete(handler:Function, ...args):Tweener
		{
			_completeHandler = handler;
			_completeParams = args;
			
			return this;
		}

		/**
		 * Put new tween of the same target in a chain.
		 * Tween executes after parent tween will be completed.
		 * @param duration Tween duration in seconds
		 *
		 * @example <code>
		 * tween(sprite, 2.0).to({x: 50})
		 *  .tween(0.5).to({y: 20})
		 *  .tween().to({x: 100})</code>
		 */
		public function tween(duration:Number = -1):Tweener
		{
			chain = new Tweener(_manager, target, duration);
			return chain;
		}

		/**
		 * Detach target from display list.
		 * Target should be a DisplayObject.
		 */
		public function autoDetach():Tweener
		{
			if (!(target is DisplayObject))
				throw new ArgumentError(Errors.NOT_A_DISPLAY_OBJECT);

			_autoDetach = true;

			return this;
		}


		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		motion_internal function initialize(currentTime:Number):void
		{
			if (_easing == null)
				_easing = _manager.defaultEasing;

			_startTime = currentTime + _delay;

			initProperties();

			initialized = true;
		}

		private function initProperties():void
		{
			for (var propName:String in _params)
			{
				addProperty(propName);
			}
		}

		private function addProperty(propName:String):void
		{
			var property:ITweenProperty = (propName in TweenManager.specialProperties)
					? new (TweenManager.specialProperties[propName])()
					: new NumberProperty(propName);

			properties[propName] = property;
			numProperties++;
			property.initialize(target, _params[propName]);
		}

		motion_internal function doStep(currentTime:Number):void
		{
			if (currentTime < _startTime)
				return;

			var timePosition:Number = (currentTime - _startTime) / _duration;

			if (timePosition < 1)
			{
				var easingPosition:Number = _easing.calculate(timePosition);
				completed = true;

				for each (var property:ITweenProperty in properties)
				{
					property.applyTween(easingPosition);
					completed = false;
				}
			}
			else
			{
				completed = true;
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
		}

		motion_internal function overrideProperties(sourceProps:Object):void
		{
			for (var propName:String in sourceProps)
			{
				if (propName in properties)
					removeProperty(propName);
			}
		}

		private function removeProperty(propName:String):void
		{
			delete properties[propName];
			numProperties--;
		}

		private function applyComplete():void
		{
			for each (var property:ITweenProperty in properties)
			{
				property.applyComplete();
			}

			if (_autoDetach)
			{
				var displayObject:DisplayObject = DisplayObject(target);
				displayObject.parent.removeChild(displayObject);
			}
		}
	}
}
