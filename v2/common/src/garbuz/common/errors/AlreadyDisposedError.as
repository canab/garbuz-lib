package garbuz.common.errors 
{
	public class AlreadyDisposedError extends Error
	{
		public function AlreadyDisposedError(message:String = "Object is already disposed")
		{
			super(message);
		}
	}
}