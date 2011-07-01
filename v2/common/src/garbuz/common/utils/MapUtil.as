package garbuz.common.utils
{
	public class MapUtil
	{
		public static function getLength(object:Object):int
		{
			var length:int = 0;
			//noinspection JSUnusedLocalSymbols
			for each (var item:Object in object)
			{
				length++;
			}
			return length;
		}

		public static function getKeys(object:Object):Array
		{
			var result:Array = [];
			for (var key:Object in object)
			{
				result.push(key);
			}
			return result;
		}

		public static function getValues(object:Object):Array
		{
			var result:Array = [];
			for each (var item:Object in object)
			{
				result.push(item);
			}
			return result;
		}

		public static function isEmpty(object:Object):Boolean
		{
			//noinspection LoopStatementThatDoesntLoopJS,JSUnusedLocalSymbols
			for each (var item:Object in object)
			{
				return false;
			}
			return true;
		}
	}
}
