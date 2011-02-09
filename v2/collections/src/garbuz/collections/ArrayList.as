package garbuz.collections 
{
	/**
	 * ...
	 * @author canab
	 */
	public dynamic class ArrayList extends Array
	{
		
		public function ArrayList() 
		{
			super();
		}
		
		public function removeItem(item:*):void 
		{
			splice(indexOf(item), 1);
		}
		
		public function get first():*
		{
			return this[0];
		}
		
		public function get last():*
		{
			return this[length - 1];
		}
		
	}

}