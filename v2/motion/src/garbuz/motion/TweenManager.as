package garbuz.motion
{
	import flash.display.Shape;
	import flash.events.Event;

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

		public static function tween(target:Object):MotionTween
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

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		/////////////////////////////////////////////////////////////////////////////////////

		private var _head:MotionTween = null;
		private var _dispatcher:Shape = new Shape();
		private var _paused:Boolean = false;
		private var _isDispatcherActive:Boolean = false;
		private var _defaultDuration:Number = 1.0;

		public function tween(target:Object):MotionTween
		{
			var tween:MotionTween = createTween(target);
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

		private function createTween(target:Object):MotionTween
		{
			var tween:MotionTween = new MotionTween(target);
			tween.setDuration(_defaultDuration);
			return tween;
		}

		private function insertTween(tween:MotionTween):void
		{
			tween.next = _head;
			tween.prev = null;
			_head = tween;
		}

		private function deleteTween(tween:MotionTween):void
		{
			var prev:MotionTween = tween.prev;
			
			if (prev)
				prev.next = tween.next;

			var next:MotionTween = tween.next;

			if (next)
				next.prev = tween.prev;

			if (tween == _head)
				_head = next;

			tween.dispose();
		}

		private function processTweens(event:Event):void
		{
			var tween:MotionTween = _head;

			while (tween)
			{
				var nextTween:MotionTween = tween.next;

				if (tween.removed)
				{
					deleteTween(tween);
				}
				else
				{
					tween.doStep();
					if (tween.finished)
						finishTween(tween)
				}

				tween = nextTween;
			}

			updateDispatcher();
		}

		private function finishTween(tween:MotionTween):void
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
		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			_paused = value;
			updateDispatcher();
		}

		public function get defaultDuration():Number
		{
			return _defaultDuration;
		}

		public function set defaultDuration(value:Number):void
		{
			_defaultDuration = value;
		}
	}
}
