package garbuz.common.resources.loaders
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import garbuz.common.events.EventSender;

	public class SWFLoader extends LoaderBase
	{
		private var _loader:Loader;
		private var _initEvent:EventSender;
		private var _loaderContext:LoaderContext;

		public function SWFLoader(url:String, maxAttempts:int = 3)
		{
			super(url, maxAttempts);
		}

		override protected function startLoading():void
		{
			if (!_loader)
				_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

			_loader.load(new URLRequest(url), _loaderContext);
		}

		private function onInit(event:Event):void
		{
			if (_initEvent)
				_initEvent.dispatch();
		}

		override protected function removeListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onInit);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
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
			return (_loader.contentLoaderInfo.bytesTotal > 0)
				? _loader.contentLoaderInfo.bytesLoaded / _loader.contentLoaderInfo.bytesTotal
				: 0;
		}

		public function get content():DisplayObject
		{
			return _loader.content;
		}

		public function get loaderInfo():LoaderInfo
		{
			return _loader.contentLoaderInfo;
		}

		public function get domain():ApplicationDomain
		{
			return _loader.contentLoaderInfo.applicationDomain;
		}

		public function get loader():Loader
		{
			return _loader;
		}

		public function get initEvent():EventSender
		{
			if (!_initEvent)
				_initEvent = new EventSender(this);
			
			return _initEvent;
		}

		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}

		public function set loaderContext(value:LoaderContext):void
		{
			_loaderContext = value;
		}

		public function set loader(value:Loader):void
		{
			_loader = value;
		}
	}

}