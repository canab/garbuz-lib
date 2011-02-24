package garbuz.common.converting 
{
	public class ConstructorConverter implements IConverter
	{
		private var _constructor:Class;
		
		public function ConstructorConverter(constructor:Class) 
		{
			_constructor = constructor;
		}
		
		public function convert(value:Object):Object
		{
			return new _constructor(value);
		}
	}
}
