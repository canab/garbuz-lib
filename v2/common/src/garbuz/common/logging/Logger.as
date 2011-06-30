package garbuz.common.logging
{
	public class Logger
	{
		private static var _defaultAdapter:ILogAdapter;
		private static var _defaultFormatter:ILogFormatter;
		private static var _defaultLogger:Logger;

		public static function debug(...args):void
		{
			defaultLogger.debug.apply(null, args);
		}

		public static function info(...args):void
		{
			defaultLogger.info.apply(null, args);
		}

		public static function error(...args):void
		{
			defaultLogger.debug.apply(null, args);
		}

		public static function get defaultAdapter():ILogAdapter
		{
			if (!_defaultAdapter)
				_defaultAdapter = new TraceLogAdapter();

			return _defaultAdapter;
		}

		public static function set defaultAdapter(value:ILogAdapter):void
		{
			if (!value)
				throw new Error("logAdapter cannot be null.");

			_defaultAdapter = value;
		}

		public static function get defaultFormatter():ILogFormatter
		{
			if (!_defaultFormatter)
				_defaultFormatter = new PatternFormatter();

			return _defaultFormatter;
		}

		public static function set defaultFormatter(value:ILogFormatter):void
		{
			_defaultFormatter = value;
		}

		public static function get defaultLogger():Logger
		{
			if (!_defaultLogger)
				_defaultLogger = new Logger("Logger");

			return _defaultLogger;
		}

		public static function set defaultLogger(value:Logger):void
		{
			_defaultLogger = value;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _sender:Object;
		private var _adapter:ILogAdapter;
		private var _formatter:ILogFormatter;

		public function Logger(sender:Object)
		{
			_sender = sender;
		}

		public function debug(... args):void
		{
			print(Levels.DEBUG, joinArgs(args));
		}

		public function info(...args):void
		{
			print(Levels.INFO, joinArgs(args));
		}

		public function error(...args):void
		{
			print(Levels.ERROR, joinArgs(args));
		}

		private function joinArgs(args:Array):String
		{
			var text:String = "";

			for each (var item:Object in args)
			{
				if (text.length > 0)
					text += " ";
				
				text += String(item);
			}

			return text;
		}

		protected function print(level:String, message:String):void
		{
			var text:String = formatter.format(_sender, level, message);
			adapter.print(_sender, level, text);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get adapter():ILogAdapter
		{
			if (!_adapter)
				_adapter = defaultAdapter;

			return _adapter;
		}

		public function set adapter(value:ILogAdapter):void
		{
			_adapter = value;
		}

		public function get formatter():ILogFormatter
		{
			if (!_formatter)
				_formatter = defaultFormatter;

			return _formatter;
		}

		public function set formatter(value:ILogFormatter):void
		{
			_formatter = value;
		}
	}
}