package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class BooleanData extends DataComponent
	{
		private var _value:Boolean;
		
		public function BooleanData(newValue:Boolean = false)
		{
			_value = newValue;
		}
		
		public function get value():Boolean { return _value; }
		public function set value(newValue:Boolean):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
	}

}