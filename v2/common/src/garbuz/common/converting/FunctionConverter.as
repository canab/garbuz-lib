package garbuz.common.converting 
{
	/**
	 * ...
	 * @author canab
	 */
	public class FunctionConverter implements IConverter
	{
		private var _converter:Function;

		public function FunctionConverter(converter:Function)
		{
			_converter = converter;
		}

		/* INTERFACE common.converting.IConverter */
		
		public function convert(value:Object):Object
		{
			return _converter(value);
		}
		
	}
}
