package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class IntData extends DataComponent
	{
		private var _value:int;
		
		public function IntData(newValue:int = 0)
		{
			_value = newValue;
		}
		
		public function get value():int { return _value; }
		public function set value(newValue:int):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
	}

}