package garbuz.common.converting 
{
	/**
	 * ...
	 * @author canab
	 */
	public class XmlToObjectConverter implements IConverter
	{
		private var _objectType:Class;
		
		public function XmlToObjectConverter(objectType:Class) 
		{
			_objectType = objectType;
		}
		
		/* INTERFACE common.converting.IConverter */
		
		public function convert(value:Object):Object
		{
			var xml:XML = XML(value);
			var result:Object = new _objectType();
			
			for each (var attr:XML in xml.attributes())
			{
				var attrName:String = attr.name();
				result[attrName] = attr;
				
				//trace(attrName, result[attrName]);
			}
			
			for each (var child:XML in xml.children())
			{
				var tagName:String = child.name();
				result[tagName] = child;
				
				//trace(tagName, result[tagName]);
			}
			
			return result;
		}
	}

}