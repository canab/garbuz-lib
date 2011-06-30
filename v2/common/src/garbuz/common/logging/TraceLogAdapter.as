package garbuz.common.logging
{
	public class TraceLogAdapter implements ILogAdapter
	{
		public function print(sender:Object, level:String, message:String):void
		{
			trace(message);
		}
	}
}
