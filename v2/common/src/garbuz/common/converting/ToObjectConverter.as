package garbuz.common.converting 
{
	import garbuz.common.utils.ReflectUtil;

	public class ToObjectConverter implements IConverter
	{
		private var _objectType:Class;
		
		public function ToObjectConverter(objectType:Class)
		{
			_objectType = objectType;
		}
		
		public function convert(value:Object):Object
		{
			var result:Object = new _objectType();
			ReflectUtil.copyFieldsAndProperties(value, result);
			return result;
		}
	}
}