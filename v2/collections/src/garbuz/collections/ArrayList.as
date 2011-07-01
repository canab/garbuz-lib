package garbuz.collections
{
	import garbuz.collections.iterators.ArrayIterator;

	public class ArrayList extends AbstractList
	{
		private var _array:Array = [];

		public function ArrayList(type:Class, source:Array = null)
		{
			super(type);
			_array = source || [];
		}

		override public function addItemAt(item:Object, index:int):*
		{
			checkOuterBounds(index);
			_array.splice(index, 0, item);
			return item;
		}

		override public function removeItemAt(index:int):void
		{
			checkInnerBounds(index);
			_array.splice(index, 1);
		}

		override public function indexOf(item:*):int
		{
			return _array.indexOf(item);
		}

		override public function getItemAt(index:int):*
		{
			checkInnerBounds(index);
			return _array[index];
		}

		override public function setItemAt(item:*, index:int):void
		{
			checkOuterBounds(index);
			_array[index] = item;
		}

		override public function get length():int
		{
			return _array.length;
		}

		override public function clear():void
		{
			_array = [];
		}

		override public function clone():IList
		{
			return new ArrayList(itemType, _array.slice());
		}

		override public function toArray():Array
		{
			return _array.slice();
		}

		override public function getIterator():IIterator
		{
			return new ArrayIterator(_array);
		}
	}
}
