package garbuz.common.comparing
{
	
	/**
	* ...
	* @author Canab
	*/
	public class PropertyRequirement implements IRequirement
	{
		private var _path:Array;
		private var _value:Object;
		
		public function PropertyRequirement(property:String, value:Object)
		{
			_path = property.split('.');
			_value = value;
		}
		
		public function accept(object:Object):Boolean
		{
			if (!object)
				return false;
			
			var item:Object = object;
			
			for each (var property:String in _path) 
			{
				if (item && item.hasOwnProperty(property))
					item = item[property];
				else
					return false;
			}
			
			return item === _value;
		}
		
	}
}