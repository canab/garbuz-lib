package garbuz.common.resources.loaders
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class ImageLoader extends LoaderBase
	{
		private var _loader:Loader;
		private var _loaderContext:LoaderContext;

		public function ImageLoader(url:String, maxAttempts:int = 3)
		{
			super(url, maxAttempts);
		}

		override protected function startLoading():void
		{
			if (!_loader)
				_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);

			_loader.load(new URLRequest(url), _loaderContext);
		}

		override protected function removeListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
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

		private function onLoadComplete(e:Event):void
		{
			processComplete();
		}

		private function onLoadError(e:Event):void
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
			return (_loader.contentLoaderInfo.bytesTotal > 0)
				? _loader.contentLoaderInfo.bytesLoaded / _loader.contentLoaderInfo.bytesTotal
				: 0;
		}

		public function get content():Bitmap
		{
			return Bitmap(_loader.content);
		}

		public function get loaderInfo():LoaderInfo
		{
			return _loader.contentLoaderInfo;
		}

		public function get loader():Loader
		{
			return _loader;
		}

		public function set loader(value:Loader):void
		{
			_loader = value;
		}

		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}

		public function set loaderContext(value:LoaderContext):void
		{
			_loaderContext = value;
		}
	}

}