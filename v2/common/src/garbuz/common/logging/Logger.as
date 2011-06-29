package garbuz.common.logging
{
	public class Logger
	{
		private static var _defaultAdapter:ILogAdapter = new TraceLogAdapter();
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
			return _defaultAdapter;
		}

		public static function set defaultAdapter(value:ILogAdapter):void
		{
			if (!value)
				throw new Error("logAdapter cannot be null.");

			_defaultAdapter = value;
		}

		public static function get defaultLogger():Logger
		{
			if (!_defaultLogger)
				_defaultLogger = new Logger("Logger", _defaultAdapter);

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

		public function Logger(sender:Object, adapter:ILogAdapter = null)
		{
			_sender = sender;
			_adapter = adapter || defaultAdapter;
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
			_adapter.print(_sender, level, message);
		}


		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get adapter():ILogAdapter
		{
			return _adapter;
		}

		public function set adapter(value:ILogAdapter):void
		{
			if (!value)
				throw new Error("logAdapter cannot be null.");

			_adapter = value;
		}
	}
}