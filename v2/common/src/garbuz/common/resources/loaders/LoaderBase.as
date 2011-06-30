package garbuz.common.resources.loaders
{
	import garbuz.common.commands.ICancelableCommand;
	import garbuz.common.errors.NotImplementedError;
	import garbuz.common.events.EventSender;
	import garbuz.common.logging.Logger;

	public class LoaderBase implements ICancelableCommand
	{
		private static var _logger:Logger = new Logger(LoaderBase);
		private static var _version:String;

		public static function get version():String
		{
			return _version;
		}

		public static function set version(value:String):void
		{
			_version = value;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _completeEvent:EventSender = new EventSender(this);

		private var _url:String;
		private var _maxAttempts:int;
		private var _attemptNum:int = 0;
		private var _successful:Boolean;

		public function LoaderBase(url:String, maxAttempts:int)
		{
			_url = url;
			_maxAttempts = maxAttempts;

			if (_version)
				addVersion();
		}

		private function addVersion():void
		{
			_url += (_url.indexOf("?") >= 0)
				? "&v=" + _version
				: "?v=" + _version;
		}

		public function execute():void
		{
			_attemptNum = 1;
			startLoading();
		}

		public function cancel():void
		{
			removeListeners();
			stopLoading();
		}

		protected function processFail():void
		{
			_successful = false;

			removeListeners();

			if (_attemptNum < _maxAttempts)
			{
				_attemptNum++;
				startLoading();
			}
			else
			{
				_logger.error("failed: " + url);
				_completeEvent.dispatch();
			}
		}

		protected function processComplete():void
		{
			removeListeners();
			_successful = true;
			_logger.debug("completed: " + url);
			_completeEvent.dispatch();
		}

		protected virtual function startLoading():void
		{
			throw new NotImplementedError();
		}

		protected virtual function removeListeners():void
		{
			throw new NotImplementedError();
		}

		protected virtual function stopLoading():void
		{
			throw new NotImplementedError();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}

		public function get url():String
		{
			return _url;
		}

		public function get progress():Number
		{
			return 0;
		}

		public function get successful():Boolean
		{
			return _successful;
		}

	}

}