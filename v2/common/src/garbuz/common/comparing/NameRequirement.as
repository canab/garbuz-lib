package garbuz.common.comparing
{
	
	/**
	 * ...
	 * @author Canab
	 */
	public class NameRequirement implements IRequirement
	{
		private var _isPrefix:Boolean;
		private var _property:String;
		private var _value:String;
		
		public function NameRequirement(name:String, isPrefix:Boolean = false)
		{
			_property = 'name';
			_value = name;
			_isPrefix = isPrefix;
		}
		
		public function accept(object:Object):Boolean
		{
			if (_isPrefix)
			{
				return object
					&& object.hasOwnProperty(_property)
					&& String(object[_property]).indexOf(_value) == 0;
			}
			else
			{
				return object
					&& object.hasOwnProperty(_property)
					&& object[_property] == _value;
			}
		}
		
	}
	
}