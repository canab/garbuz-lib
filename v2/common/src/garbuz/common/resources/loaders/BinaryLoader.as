package garbuz.common.resources.loaders
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BinaryLoader extends LoaderBase
	{
		private var _loader:URLLoader;

		public function BinaryLoader(url:String, maxAttempts:int = 3)
		{
			super(url, maxAttempts);
		}

		override protected function startLoading():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.load(new URLRequest(url));
		}

		override protected function removeListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}

		override protected function stopLoading():void
		{
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
			}
		}

		private function onComplete(e:Event):void
		{
			processComplete();
		}

		private function onError(e:Event):void
		{
			processFail();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		override public function get progress():Number
		{
			return (_loader.bytesTotal > 0)
				? _loader.bytesLoaded / _loader.bytesTotal
				: 0;
		}

		public function get data():Object
		{
			return _loader.data;
		}
	}

}