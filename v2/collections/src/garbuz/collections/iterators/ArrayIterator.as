package garbuz.collections.iterators
{
	import garbuz.collections.IIterator;

	public class ArrayIterator implements IIterator
	{
		private var _array:Array;
		private var _index:int = 0;

		public function ArrayIterator(array:Array)
		{
			_array = array;
		}

		public function get hasNext():Boolean
		{
			return _index < _array.length;
		}

		public function get next():*
		{
			return _array[_index++];
		}
	}
}
