package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class StringData extends DataComponent
	{
		private var _value:String;
		
		public function StringData(newValue:String = null)
		{
			_value = newValue;
		}
		
		public function get value():String { return _value; }
		public function set value(newValue:String):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
	}

}