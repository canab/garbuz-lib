package garbuz.engine.components 
{
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class ObjectData extends DataComponent
	{
		private var _value:Object;
		
		public function ObjectData(newValue:Object = null)
		{
			_value = newValue;
		}
		
		public function get value():Object { return _value; }
		public function set value(newValue:Object):void 
		{
			if (_value != newValue)
			{
				_value = newValue;
				changeEvent.dispatch();
			}
		}
	}

}