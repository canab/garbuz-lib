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
				var attrName:String = String(attr.name());

				if (result[attrName] is Boolean)
					result[attrName] = attr == "true";
				else
					result[attrName] = attr;
			}
			
			for each (var child:XML in xml.children())
			{
				var tagName:String = String(child.name());

				if (result[tagName] is Boolean)
					result[tagName] = attr == "true";
				else
					result[tagName] = child;
			}
			
			return result;
		}
	}

}