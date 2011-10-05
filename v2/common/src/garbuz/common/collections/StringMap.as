package garbuz.common.collections
{
	import garbuz.common.utils.MapUtil;

	public dynamic class StringMap
	{
		//noinspection JSUnusedLocalSymbols
		public function StringMap(itemType:Class = null)
		{
		}

		public function removeValue(value:*):void
		{
			MapUtil.removeValue(this, value);
		}

		public function getLength():int
		{
			return MapUtil.getLength(this);
		}

		public function getKeys():Array
		{
			return MapUtil.getKeys(this);
		}

		public function getValues():Array
		{
			return MapUtil.getValues(this);
		}

		public function isEmpty():Boolean
		{
			return MapUtil.isEmpty(this);
		}

		public function containsKey(key:String):Boolean
		{
			return MapUtil.containsKey(this, key);
		}

		public function containsValue(value:*):Boolean
		{
			return MapUtil.containsValue(this, value);
		}
	}
}
