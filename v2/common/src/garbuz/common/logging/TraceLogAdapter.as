package garbuz.common.logging
{
	public class TraceLogAdapter implements ILogAdapter
	{
		private var _levelMap:Object = {};

		public function TraceLogAdapter()
		{
			_levelMap[Levels.DEBUG] = "debug:";
			_levelMap[Levels.INFO]  = " info:";
			_levelMap[Levels.ERROR] = "error:";
		}

		public function print(sender:Object, level:String, message:String):void
		{
			trace(formatMessage(sender, level, message));
		}

		protected function formatMessage(sender:Object, level:String, message:String):String
		{
			return _levelMap[level]
					+ " " + getSender(sender)
					+ " " + message;
		}

		private function getSender(sender:Object):String
		{
			return "[" + String(sender)
					.replace(/\[object (.+)\]/, "$1")
					.replace(/\[class (.+)\]/, "$1") + "]";
		}
	}
}
