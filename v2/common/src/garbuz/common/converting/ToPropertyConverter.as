package garbuz.common.converting 
{
	public class ToPropertyConverter implements IConverter
	{
		private var _propertyName:String;
		
		public function ToPropertyConverter(propertyName:String) 
		{
			_propertyName = propertyName;
		}
		
		public function convert(value:Object):Object
		{
			return value[_propertyName];
		}
	}
}
