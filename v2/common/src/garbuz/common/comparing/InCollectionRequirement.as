package garbuz.common.comparing
{
	public class InCollectionRequirement implements IRequirement
	{
		private var _collection:Object;

		public function InCollectionRequirement(collection:Object)
		{
			_collection = collection;
		}
		
		public function accept(object:Object):Boolean
		{
			for each (var item:Object in _collection)
			{
				if (item == object)
					return true;
			}

			return false;
		}
	}
}