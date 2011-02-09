package garbuz.common.converting 
{
	/**
	 * ...
	 * @author canab
	 */
	public class ToPropertyConverter implements IConverter
	{
		private var _propertyName:String;
		
		public function ToPropertyConverter(propertyName:String) 
		{
			_propertyName = propertyName;
		}
		
		/* INTERFACE common.converting.IConverter */
		
		public function convert(value:Object):Object
		{
			return value[_propertyName];
		}
		
	}
}
