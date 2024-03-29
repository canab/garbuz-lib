package garbuz.common.utils 
{
	import garbuz.common.errors.ItemNotFoundError;
	/**
	 * ...
	 * @author canab
	 */
	public class ArrayUtil
	{
		static public function lastItem(source:Array):Object
		{
			return (source.length > 0)
				? source[source.length - 1]
				: null;
		}
		
		static public function getKeys(object:Object):Array
		{
			var result:Array = [];
			for (var key:Object in object)
			{
				result.push(key);
			}
			return result;
		}
		
		static public function removeItem(source:Array, item:Object):Boolean
		{
			var index:int = source.indexOf(item);
			if (index >= 0)
			{
				source.splice(index, 1);
				return true;
			}
			return false;
		}
		
		static public function removeItems(source:Array, items:Array):int
		{
			var i:int = 0;
			var length:int = source.length;
			while (i < source.length)
			{
				var item:Object = source[i];
				var index:int = items.indexOf(item);
				if (index >= 0)
					source.splice(i, 1);
				else
					i++;
			}
			return length - source.length;
		}
		
		static public function removeItemSafe(source:Array, item:Object):void
		{
			var index:int = source.indexOf(item);
			if (index >= 0)
				source.splice(index, 1);
			else
				throw new ItemNotFoundError();
		}
		
		static public function getRandomItem(source: Array):*
		{
			return source[int(Math.random() * source.length)];
		}
		
		static public function getRandomItems(source:Array, count:int):Array
		{
			var result:Array = [];
			var selection:Array = [];
			
			for (var i:int = 0; i < count; i++)
			{
				var index:int = Math.random() * source.length;
				
				while(selection.indexOf(index) >= 0)
				{
					index++;
					if (index == source.length)
						index = 0;
				}
				
				result.push(source[index]);
				selection.push(index);
			}
			
			return result;
		}		
		
		static public function equals(source:Array, target:Array):Boolean
		{
			if (source == null && target == null)
				return true;
			
			if (source == null || target == null)
				return false;
			
			if (source.length != target.length)
				return false;
				
			for each (var item:Object in source) 
			{
				if (target.indexOf(item) == -1)
					return false;
			}
			
			return true;
		}
		
		static public function pushUniqueItem(target:Array, item:Object):Boolean
		{
			if (target.indexOf(item) == -1)
			{
				target.push(item);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		static public function pushUniqueItems(target:Array, items:Array):int
		{
			var result:int = 0;
			for each (var item:Object in items) 
			{
				if (pushUniqueItem(target, item))
					result++;
			}
			return result;
		}
		
		static public function toObject(source:Array, keyProperty:String):Object
		{
			var result:Object = { };
			
			for each (var item:Object in source) 
			{
				if (item.hasOwnProperty(keyProperty))
				{
					result[item[keyProperty]] = item;
				}
			}
			
			return result;
		}
	}

}