package garbuz.collections
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import garbuz.collections.errors.IllegalIndexValueError;
	import garbuz.collections.errors.IndexOutOfBoundsError;
	import garbuz.common.errors.NotImplementedError;

	public class AbstractList extends Proxy implements IList
	{
		private var _itemType:Class;

		public function AbstractList(type:Class)
		{
			_itemType = type;
		}

		public function contains(item:*):Boolean
		{
			return indexOf(item) >= 0;
		}

		public function addItem(item:*):*
		{
			return addItemAt(item, length);
		}

		public function removeItem(item:Object):int
		{
			var index:int = indexOf(item);

			if (index >= 0)
				removeItemAt(index);

			return index;
		}

		public function pop():*
		{
			var index:int = length - 1;
			var item:Object = getItemAt(index);
			removeItemAt(index);
			return item;
		}

		public function shift():*
		{
			var item:Object = getItemAt(0);
			removeItemAt(0);
			return item;
		}

		public function get first():*
		{
			return getItemAt(0);
		}

		public function get last():*
		{
			return getItemAt(length - 1);
		}

		public function get itemType():Class
		{
			return _itemType;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// abstract methods
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function addItemAt(item:Object, index:int):*
		{
			return notImplemented();
		}

		public function removeItemAt(index:int):void
		{
			notImplemented();
		}

		public function indexOf(item:*):int
		{
			return notImplemented();
		}

		public function getItemAt(index:int):*
		{
			return notImplemented();
		}

		public function setItemAt(item:*, index:int):void
		{
			notImplemented();
		}

		public function get length():int
		{
			return notImplemented();
		}

		public function clear():void
		{
			notImplemented();
		}

		public function clone():IList
		{
			return notImplemented();
		}

		public function toArray():Array
		{
			return notImplemented();
		}

		public function getIterator():IIterator
		{
			return notImplemented();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// proxy
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		override flash_proxy function getProperty(name:*):*
		{
		    if (!(name is int))
		        throw new IllegalIndexValueError(name);

			return getItemAt(int(name));
		}

		override flash_proxy function setProperty(name:*, value:*):void
		{
			if (!(name is int))
			    throw new IllegalIndexValueError(name);

		    setItemAt(value, int(name));
		}

		override flash_proxy function hasProperty(name:*):Boolean
		{
			if (!(name is int))
			    return false;

			var index:int = int(name);

			return index >= 0 && index < length;
		}

		override flash_proxy function nextNameIndex(index:int):int
		{
		    return index < length ? index + 1 : 0;
		}

		override flash_proxy function nextName(index:int):String
		{
		    return (index - 1).toString();
		}

		override flash_proxy function nextValue(index:int):*
		{
		    return getItemAt(index - 1);
		}

		override flash_proxy function callProperty(name:*, ... rest):*
		{
		    return notImplemented();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// protected
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected function checkInnerBounds(index:int):void
		{
			if (index < 0 || index >= length)
				throw new IndexOutOfBoundsError(index,  length);
		}

		protected function checkOuterBounds(index:int):void
		{
			if (index < 0 || index > length)
				throw new IndexOutOfBoundsError(index,  length);
		}

		protected function notImplemented():*
		{
			throw new NotImplementedError();
			//noinspection UnreachableCodeJS
			return null;
		}
	}
}
