package garbuz.common.errors 
{
	/**
	 * ...
	 * @author canab
	 */
	public class ItemNotFoundError extends Error
	{
		public function ItemNotFoundError(message:String = "Item not found") 
		{
			super(message);
		}
	}

}