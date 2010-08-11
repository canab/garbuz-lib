package garbuz.engine.components 
{
	import garbuz.common.utils.ArrayUtil;
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class ArrayData extends DataComponent
	{
		private var _value:Array;
		
		public function ArrayData(newValue:Array = null) 
		{
			_value = newValue || [];
		}
		
		public function get value():Array { return _value; }
		public function set value(newValue:Array):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
		
		public function addItem(item:Object):void 
		{
			_value.push(item);
			changeEvent.dispatch();
		}
		
		public function removeItem(item:Object):void
		{
			if (ArrayUtil.removeItem(_value, item))
				changeEvent.dispatch();
		}
		
		public function removeItems(items:Array):void
		{
			if (ArrayUtil.removeItems(_value, items) > 0)
				changeEvent.dispatch();
		}
		
		public function get length():int
		{
			return _value.length;
		}
		
	}

}