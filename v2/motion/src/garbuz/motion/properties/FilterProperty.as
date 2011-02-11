package garbuz.motion.properties
{
	public class FilterProperty implements ITweenProperty
	{
		private var _target:Object;
		private var _filters:Array;

		public function initialize(target:Object, startValue:Object, endValue:Object):void
		{
			_target = target;
		}

		public function applyTween(position:Number):void
		{
		}

		public function applyComplete():void
		{
		}
	}
}

import flash.filters.BitmapFilter;

internal class Filter
{
	public var filter:BitmapFilter;
	public var properties:Array;
	public var removeOnComplete:Boolean;
}

internal class Property
{
	public var name:String;
	public var startValue:Number;
	public var endValue:Number;
}
