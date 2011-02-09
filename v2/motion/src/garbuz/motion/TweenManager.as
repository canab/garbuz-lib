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

		motion_internal static var currentTime:Number;

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

		public static function tween(target:Object):Tweening
		{
			return instance.tween(target);
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

		private var _head:Tweening = null;
		private var _dispatcher:Shape = new Shape();
		private var _paused:Boolean = false;
		private var _isDispatcherActive:Boolean = false;

		private var _defaultDuration:Number = 1.0;
		private var _defaultEasing:Function = Quad.easeOut;

		public function tween(target:Object):Tweening
		{
			var tween:Tweening = createTween(target);
			insertTween(tween);
			updateDispatcher();
			return tween;
		}

		public function pause():void
		{
			if (!_paused)
			{
				_paused = false;
				updateDispatcher();
			}
		}

		public function resume():void
		{
			if (_paused)
			{
				_paused = false;
				updateDispatcher();
			}
		}


		/////////////////////////////////////////////////////////////////////////////////////
		//
		// private
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private function createTween(target:Object):Tweening
		{
			var tween:Tweening = new Tweening(target);
			tween.duration(_defaultDuration);
			tween.easing(_defaultEasing);
			return tween;
		}

		private function insertTween(tween:Tweening):void
		{
			tween.next = _head;
			tween.prev = null;

			if (_head)
				_head.prev = tween;
			
			_head = tween;
		}

		private function deleteTween(tween:Tweening):void
		{
			var prev:Tweening = tween.prev;
			var next:Tweening = tween.next;

			if (prev)
				prev.next = next;

			if (next)
				next.prev = prev;

			if (tween == _head)
				_head = next;

			tween.dispose();
		}

		private function processTweens(event:Event):void
		{
			currentTime = getTimer();
			
			var tween:Tweening = _head;

			while (tween)
			{
				var nextTween:Tweening = tween.next;

				if (tween.removed)
				{
					deleteTween(tween);
				}
				else
				{
					tween.doStep();
					if (tween.completed)
						finishTween(tween);
				}

				tween = nextTween;
			}

			updateDispatcher();
		}

		private function finishTween(tween:Tweening):void
		{
			deleteTween(tween);
		}

		private function updateDispatcher():void
		{
			if (_isDispatcherActive && _paused)
			{
				_isDispatcherActive = false;
				_dispatcher.removeEventListener(Event.ENTER_FRAME, processTweens);
			}
			else if (!_isDispatcherActive && !_paused && _head)
			{
				_isDispatcherActive = false;
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
