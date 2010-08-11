package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class NumberData extends DataComponent
	{
		private var _value:Number;
		
		public function NumberData(newValue:Number = 0.0)
		{
			_value = newValue;
		}
		
		public function get value():Number { return _value; }
		public function set value(newValue:Number):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
	}

}