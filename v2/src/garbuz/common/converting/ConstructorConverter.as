package garbuz.common.converting 
{
	/**
	 * ...
	 * @author canab
	 */
	public class ConstructorConverter implements IConverter
	{
		private var _constructor:Class;
		
		public function ConstructorConverter(constructor:Class) 
		{
			_constructor = constructor;
		}
		
		/* INTERFACE common.converting.IConverter */
		
		public function convert(value:Object):Object
		{
			return new _constructor(value);
		}
		
	}
}
