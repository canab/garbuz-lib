package garbuz.common.logging
{
	public class PatternFormatter implements ILogFormatter
	{
		public static const DEFAULT_PATTERN:String = "{level}: [{sender}] {message}";

		private var _levelMap:Object = {};
		private var _pattern:String;

		public function PatternFormatter(pattern:String = null)
		{
			_pattern = pattern || DEFAULT_PATTERN;

			_levelMap[Levels.DEBUG] = "debug";
			_levelMap[Levels.INFO]  = "info ";
			_levelMap[Levels.ERROR] = "error";
		}

		public function format(sender:Object, level:String, message:String):String
		{
			return _pattern
					.replace("{level}", _levelMap[level])
					.replace("{sender}", getSender(sender))
					.replace("{message}", message);
		}

		private function getSender(sender:Object):String
		{
			return String(sender)
					.replace(/\[object (.+)\]/, "$1")
					.replace(/\[class (.+)\]/, "$1");
		}

	}
}
