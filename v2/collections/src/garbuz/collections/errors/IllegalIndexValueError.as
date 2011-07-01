package garbuz.collections.errors
{
	public class IllegalIndexValueError extends Error
	{
		private static const MESSAGE:String = "Illegal index value error";

		public function IllegalIndexValueError(value:*)
		{
			var message:String = MESSAGE + ": " + String(value);
			super(message);
		}
	}
}
