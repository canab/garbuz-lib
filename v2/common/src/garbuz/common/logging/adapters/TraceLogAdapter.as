package garbuz.common.logging.adapters
{
	import garbuz.common.logging.ILogAdapter;

	public class TraceLogAdapter implements ILogAdapter
	{
		public function print(sender:Object, level:int, message:String):void
		{
			trace(message);
		}
	}
}
