package garbuz.common.logging
{
	public class TraceLogAdapter implements ILogAdapter
	{
		public function print(sender:Object, level:String, message:String):void
		{
			trace(formatMessage(sender, level, message));
		}

		protected function formatMessage(sender:Object, level:String, message:String):String
		{
			return "[sender] level: message"
				.replace("sender", sender)
				.replace("level", level)
				.replace("message", message);
		}
	}
}
