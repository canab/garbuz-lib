package garbuz.common.converting 
{
	public class FunctionConverter implements IConverter
	{
		private var _converter:Function;

		public function FunctionConverter(converter:Function)
		{
			_converter = converter;
		}

		public function convert(value:Object):Object
		{
			return _converter(value);
		}
	}
}
