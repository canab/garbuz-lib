package garbuz.motion.filter
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;

	import garbuz.motion.motion_internal;
	import garbuz.motion.properties.ITweenProperty;

	use namespace motion_internal;

	public class FilterProperty implements ITweenProperty
	{
		private static const INVALID_PARAMETER:String = "Parameter's type should be either of FilterTween or Array of FilterTween";

		private var _target:DisplayObject;
		private var _filters:Array;
		private var _tweens:Array = [];

		public function initialize(target:Object, endValue:Object):void
		{
			_target = DisplayObject(target);
			_filters = _target.filters;

			if (endValue is FilterTween)
				initTween(endValue as FilterTween);
			else if (endValue is Array)
				initTweens(endValue as Array);
			else
				throw new ArgumentError(INVALID_PARAMETER);
		}

		private function initTweens(array:Array):void
		{
			for each (var filterTween:FilterTween in array)
			{
				initTween(filterTween);
			}
		}

		private function initTween(tween:FilterTween):void
		{
			tween.initialize(_target);

			if (_filters.indexOf(tween.filter) == -1)
				_filters.push(tween.filter);

			_tweens.push(tween);
		}

		public function applyTween(relativeTime:Number):void
		{
			for each (var tween:FilterTween in _tweens)
			{
				tween.applyTween(relativeTime);
			}

			_target.filters = _filters;
		}

		public function applyComplete():void
		{
			for each (var tween:FilterTween in _tweens)
			{
				tween.applyComplete();

				if (tween.isAutoRemove)
					removeFilter(tween.filter);
			}

			_target.filters = _filters;
		}

		private function removeFilter(filter:BitmapFilter):void
		{
			var index:int = _filters.indexOf(filter);
			if (index >= 0)
				_filters.splice(index, 1);
		}
	}
}
