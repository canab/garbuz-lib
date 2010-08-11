package garbuz.collections 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author canab
	 */
	public class ObjectMap
	{
		private var _dictionary:Dictionary;
		
		public function ObjectMap(weakKeys:Boolean = false) 
		{
			_dictionary = new Dictionary(weakKeys);
		}
		
		public function put(key:Object, value:Object):void 
		{
			_dictionary[key] = value;
		}
		
		public function containsKey(key:Object):Boolean
		{
			return (key in _dictionary);
		}
		
		public function containsValue(value:Object):Boolean
		{
			for each (var item:Object in _dictionary) 
			{
				if (item == value)
					return true;
			}
			return false;
		}
		
		public function removeKey(key:Object):void 
		{
			delete _dictionary[key];
		}
		
		public function clear():void 
		{
			var keys:Array = getKeys();
			for each (var key:Object in key) 
			{
				delete _dictionary[key];
			}
		}
		
		public function removeValue(value:Object):void 
		{
			delete _dictionary[getKey(value)];
		}
		
		public function getValue(key:Object):Object
		{
			return _dictionary[key];
		}
		
		public function getKey(value:Object):Object
		{
			for (var key:Object in _dictionary)
			{
				if (_dictionary[key] == value)
					return key;
			}
			return null;
		}
		
		public function getKeys():Array
		{
			var result:Array = [];
			for (var key:Object in _dictionary)
			{
				result.push(key);
			}
			return result;
		}
		
		public function getValues():Array
		{
			var result:Array = [];
			for each (var value:Object in _dictionary)
			{
				result.push(value);
			}
			return result;
		}
		
	}

}