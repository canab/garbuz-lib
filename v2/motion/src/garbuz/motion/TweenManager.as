package garbuz.motion
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import garbuz.motion.easing.Quad;

	use namespace motion_internal;

	/**
	 * Class provides tween animation.
	 * Can be used by static interface as
	 * <code>TweenManager.tween(...)</code>
	 * or as several instances of TweenManager
	 * @example
	 * <code>var manager:TweenManager = new TweenManager()
	 * manager.tween(...)</code>
	 * @see garbuz.motion.tween()
	 */
	public class TweenManager
	{
		private static var _instance:TweenManager;

		motion_internal static function get instance():TweenManager
		{
			if (!_instance)
				_instance = new TweenManager();

			return _instance;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// public interface
		//
		/////////////////////////////////////////////////////////////////////////////////////

		/**
		 * Create new tween
		 * @param target
		 * target object
		 * @param duration
		 * Tween time in seconds. If omitted defaultDuration value will be used.
		 * @see garbuz.motion.TweenManager.defaultDuration()
		 */
		public static function tween(target:Object, duration:Number):Tweener
		{
			return instance.tween(target, duration);
		}

		/**
		 * Pause all tweens
		 * @see garbuz.motion.TweenManager.resume()
		 */
		public static function pause():void
		{
			instance.pause();
		}

		/**
		 * Resume all tweens
		 * @see garbuz.motion.TweenManager.pause()
		 */
		public static function resume():void
		{
			instance.resume();
		}

		/**
		 * Default duration in seconds
		 */
		public static function get defaultDuration():Number
		{
			return instance.defaultDuration;
		}

		public static function set defaultDuration(value:Number):void
		{
			instance.defaultDuration = value;
		}

		/**
		 * Default ease function
		 * @see garbuz.motion.easing
		 */
		public static function get defaultEasing():Function
		{
			return instance.defaultEasing;
		}

		public static function set defaultEasing(value:Function):void
		{
			instance.defaultEasing = value;
		}

		/**
		 * Total count of tweens
		 */
		public static function get tweenCount():int
		{
			return instance.tweenCount;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		/////////////////////////////////////////////////////////////////////////////////////


		private var _head:Tweener = null;
		private var _dispatcher:Shape = new Shape();
		private var _paused:Boolean = false;
		private var _isDispatcherActive:Boolean = false;
		private var _pauseTime:Number;
		private var _targetsTweenMap:Dictionary = new Dictionary();

		private var _currentTime:Number;
		private var _defaultDuration:Number = 1.0;
		private var _defaultEasing:Function = Quad.easeOut;
		private var _tweenCount:int = 0;

		/**
		 * Create new tween
		 * @param target
		 * target object
		 * @param duration
		 * Tween time in seconds. If omitted defaultDuration value will be used.
		 * @see garbuz.motion.TweenManager.defaultDuration()
		 */
		public function tween(target:Object, duration:Number = -1):Tweener
		{
			var tweener:Tweener = new Tweener(this, target, duration);
			addTween(tweener);
			updateDispatcher();
			return tweener;
		}

		/**
		 * Pause all tweens
		 * @see garbuz.motion.TweenManager.resume()
		 */
		public function pause():void
		{
			if (!_paused)
			{
				_paused = true;
				_pauseTime = getTimer();
				updateDispatcher();
			}
		}

		/**
		 * Resume all tweens
		 * @see garbuz.motion.TweenManager.pause()
		 */
		public function resume():void
		{
			if (_paused)
			{
				_paused = false;
				addTime(getTimer() - _pauseTime);
				updateDispatcher();
			}
		}

		/**
		 * Default duration in seconds
		 */
		public function get defaultDuration():Number
		{
			return _defaultDuration;
		}

		public function set defaultDuration(value:Number):void
		{
			_defaultDuration = value;
		}

		/**
		 * Default ease function
		 * @see garbuz.motion.easing
		 */
		public function get defaultEasing():Function
		{
			return _defaultEasing;
		}

		public function set defaultEasing(value:Function):void
		{
			_defaultEasing = value;
		}

		/**
		 * Total count of tweens
		 */
		public function get tweenCount():int
		{
			return _tweenCount;
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private function addTween(tweener:Tweener):void
		{
			_tweenCount++;
			insertIntoList(tweener);
			addToMap(tweener);
		}

		private function insertIntoList(tweener:Tweener):void
		{
			tweener.next = _head;
			tweener.prev = null;

			if (_head)
				_head.prev = tweener;

			_head = tweener;
		}

		private function addToMap(tweener:Tweener):void
		{
			var tweens:Array = _targetsTweenMap[tweener.target];

			if (!tweens)
				tweens = _targetsTweenMap[tweener.target] = [];

			tweens.push(tweener);
		}

		private function removeTween(tweener:Tweener):void
		{
			_tweenCount--;

			deleteFromList(tweener);
			removeFromMap(tweener);

			tweener.dispose();
		}

		private function deleteFromList(tweener:Tweener):void
		{
			var prevTweener:Tweener = tweener.prev;
			var nextTweener:Tweener = tweener.next;

			if (prevTweener)
				prevTweener.next = nextTweener;

			if (nextTweener)
				nextTweener.prev = prevTweener;

			if (tweener == _head)
				_head = nextTweener;
		}

		private function removeFromMap(tweener:Tweener):void
		{
			var tweens:Array = _targetsTweenMap[tweener.target];
			var index:int = tweens.indexOf(tweener);
			if (index >= 0)
				tweens.splice(index, 1);

			if (tweens.length == 0)
				delete _targetsTweenMap[tweener.target];
		}

		private function processTweens(event:Event):void
		{
			_currentTime = getTimer();
			
			var tweener:Tweener = _head;

			while (tweener)
			{
				var nextTweener:Tweener = tweener.next;

				if (tweener.removed)
				{
					removeTween(tweener);
				}
				else
				{
					if (!tweener.initialized)
					{
						tweener.initialize(_currentTime);
						overrideProperties(tweener);
					}

					tweener.doStep(_currentTime);

					if (tweener.completed)
						finishTween(tweener);
				}

				tweener = nextTweener;
			}

			updateDispatcher();
		}

		private function overrideProperties(sourceTweener:Tweener):void
		{
			var targetTweeners:Array = _targetsTweenMap[sourceTweener.target];
			var sourceProps:Object = sourceTweener.properties;

			for each (var targetTweener:Tweener in targetTweeners)
			{
				if (targetTweener == sourceTweener)
					continue;

				var targetProps:Object = targetTweener.properties;
				for (var propName:String in sourceProps)
				{
					delete targetProps[propName];
				}
			}
		}

		private function finishTween(tweener:Tweener):void
		{
			if (tweener.chain)
				addTween(tweener.chain);

			removeTween(tweener);
		}

		private function addTime(time:Number):void
		{
			for (var tweener:Tweener = _head; tweener; tweener = tweener.next)
			{
				tweener.addTime(time);
			}
		}

		private function updateDispatcher():void
		{
			if (_isDispatcherActive && (_paused || !_head))
			{
				_isDispatcherActive = false;
				_dispatcher.removeEventListener(Event.ENTER_FRAME, processTweens);
			}
			else if (!_isDispatcherActive && !_paused && _head)
			{
				_isDispatcherActive = true;
				_dispatcher.addEventListener(Event.ENTER_FRAME, processTweens);
			}
		}
	}
}
