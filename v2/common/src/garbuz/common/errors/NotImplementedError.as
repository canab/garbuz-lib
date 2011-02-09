package garbuz.common.errors 
{
	/**
	 * ...
	 * @author canab
	 */
	public class NotImplementedError extends Error
	{
		
		public function NotImplementedError(message:String = "Method is not implemented")
		{
			super(message);
		}
		
	}

}