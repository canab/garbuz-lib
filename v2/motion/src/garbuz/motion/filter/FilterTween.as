package garbuz.motion.filter
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;

	import garbuz.motion.motion_internal;

	use namespace motion_internal;

	public class FilterTween
	{
		private static const FILTER_NOT_SPECIFIED:String = "Filter is not specified";
		private static const INVALID_INDEX:String = "Cannot get filter by provided index";

		public static function byClass(classRef:Class):FilterTween
		{
			return new FilterTween(classRef);
		}

		public static function byInstance(filter:BitmapFilter):FilterTween
		{
			return new FilterTween(filter);
		}

		public static function byNum(num:int = 0):FilterTween
		{
			return new FilterTween(num);
		}

		public function FilterTween(filterID:Object)
		{
			this.filterId = filterID;
		}

		public function to(parameters:Object):FilterTween
		{
			this.endValues = parameters;
			return this;
		}

		public function autoRemove():FilterTween
		{
			isAutoRemove = true;
			return this;
		}

		motion_internal var filterId:Object = 0;
		motion_internal var endValues:Object = {};
		motion_internal var startValues:Object = {};
		motion_internal var isAutoRemove:Boolean = false;
		motion_internal var filter:BitmapFilter;

		motion_internal function initialize(target:DisplayObject):void
		{
			if (filterId is int)
				filter = getFilterByIndex(target);
			else if (filterId is Class)
				filter = getFilterByClass(target);
			else if (filterId is BitmapFilter)
				filter = BitmapFilter(filterId);
			else
				throw new ArgumentError(FILTER_NOT_SPECIFIED);

			initStartValues();
		}

		private function initStartValues():void
		{
			for (var propName:String in endValues)
			{
				startValues[propName] = filter[propName];
			}
		}

		private function getFilterByIndex(target:DisplayObject):BitmapFilter
		{
			var filters:Array = target.filters;
			var index:int = int(filterId);

			if (index < filters.length)
				return filters[index];
			else
				throw new ArgumentError(INVALID_INDEX);
		}

		private function getFilterByClass(target:DisplayObject):BitmapFilter
		{
			var classRef:Class = Class(filterId);

			for each (var filter:BitmapFilter in target.filters)
			{
				if (filter is classRef)
					return filter;
			}

			return new classRef();
		}

		motion_internal function applyTween(relativeTime:Number):void
		{
			for (var propName:String in endValues)
			{
				var startValue:Number = startValues[propName];
				var endValue:Number = endValues[propName];
				filter[propName] = startValue + relativeTime * (endValue - startValue);
			}
		}

		motion_internal function applyComplete():void
		{
			for (var propName:String in endValues)
			{
				filter[propName] = endValues[propName];
			}
		}
	}
}
