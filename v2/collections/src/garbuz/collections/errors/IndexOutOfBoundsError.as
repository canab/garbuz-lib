package garbuz.collections.errors
{
	public class IndexOutOfBoundsError extends Error
	{
		private static const MESSAGE:String = "Index out of bounds";

		public function IndexOutOfBoundsError(index:int, length:int)
		{
			var message:String = MESSAGE + ": " + index + "/" + length;
			super(message);
		}
	}
}
