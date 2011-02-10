package garbuz.motion
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	import garbuz.motion.easing.Quad;

	use namespace motion_internal;

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
		// static interface
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public static function tween(target:Object, duration:Number):Tweener
		{
			return instance.tween(target, duration);
		}

		public static function pause():void
		{
			instance.pause();
		}

		public static function resume():void
		{
			instance.resume();
		}

		public static function get defaultDuration():Number
		{
			return instance.defaultDuration;
		}

		public static function set defaultDuration(value:Number):void
		{
			instance.defaultDuration = value;
		}

		public static function get defaultEasing():Function
		{
			return instance.defaultEasing;
		}

		public static function set defaultEasing(value:Function):void
		{
			instance.defaultEasing = value;
		}


		/////////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		/////////////////////////////////////////////////////////////////////////////////////

		motion_internal var currentTime:Number;

		private var _head:Tweener = null;
		private var _dispatcher:Shape = new Shape();
		private var _paused:Boolean = false;
		private var _isDispatcherActive:Boolean = false;
		private var _pauseTime:Number;

		private var _defaultDuration:Number = 1.0;
		private var _defaultEasing:Function = Quad.easeOut;

		public function tween(target:Object, duration:Number = -1):Tweener
		{
			var tweener:Tweener = new Tweener(this, target, duration);
			insertTween(tweener);
			updateDispatcher();
			return tweener;
		}

		public function pause():void
		{
			if (!_paused)
			{
				_paused = true;
				_pauseTime = getTimer();
				updateDispatcher();
			}
		}

		public function resume():void
		{
			if (_paused)
			{
				_paused = false;
				addTime(getTimer() - _pauseTime);
				updateDispatcher();
			}
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private function insertTween(tweener:Tweener):void
		{
			tweener.next = _head;
			tweener.prev = null;

			if (_head)
				_head.prev = tweener;
			
			_head = tweener;
		}

		private function deleteTween(tweener:Tweener):void
		{
			var prevTweener:Tweener = tweener.prev;
			var nextTweener:Tweener = tweener.next;

			if (prevTweener)
				prevTweener.next = nextTweener;

			if (nextTweener)
				nextTweener.prev = prevTweener;

			if (tweener == _head)
				_head = nextTweener;

			tweener.dispose();
		}

		private function processTweens(event:Event):void
		{
			currentTime = getTimer();
			
			var tweener:Tweener = _head;

			while (tweener)
			{
				var nextTweener:Tweener = tweener.next;

				if (tweener.removed)
				{
					deleteTween(tweener);
				}
				else
				{
					tweener.doStep();
					if (tweener.completed)
						finishTween(tweener);
				}

				tweener = nextTweener;
			}

			updateDispatcher();
		}

		private function finishTween(tweener:Tweener):void
		{
			if (tweener.chain)
				insertTween(tweener.chain);

			deleteTween(tweener);
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

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public function get defaultDuration():Number
		{
			return _defaultDuration;
		}

		public function set defaultDuration(value:Number):void
		{
			_defaultDuration = value;
		}

		public function get defaultEasing():Function
		{
			return _defaultEasing;
		}

		public function set defaultEasing(value:Function):void
		{
			_defaultEasing = value;
		}
	}
}
