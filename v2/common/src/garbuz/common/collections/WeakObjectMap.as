package garbuz.common.collections
{
	public class WeakObjectMap extends ObjectMap
	{
		public function WeakObjectMap(keyType:Class = null, valueType:Class = null)
		{
			super(keyType, valueType, true);
		}
	}
}
