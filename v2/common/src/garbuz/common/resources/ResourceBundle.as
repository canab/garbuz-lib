package garbuz.common.resources
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;

	import garbuz.collections.ObjectMap;
	import garbuz.common.errors.NullPointerError;
	import garbuz.common.events.EventSender;
	import garbuz.common.resources.loaders.SWFLoader;

	public class ResourceBundle
	{
		private var _readyEvent:EventSender = new EventSender(this);

		private var _swfLoader:SWFLoader;
		private var _nativeLoader:Loader;
		private var _url:String;
		private var _references:ObjectMap = new ObjectMap(true);
		private var _manager:LoadingManager;

		public function ResourceBundle(url:String)
		{
			_url = url;
		}

		public function addReference(reference:Object):void
		{
			if (!reference)
				throw new NullPointerError();

			_references.put(reference, null);
		}

		public function load(manager:LoadingManager):void
		{
			_manager = manager;
			_swfLoader = new SWFLoader(_url);
			_swfLoader.completeEvent.addListener(onLoad);
			_manager.addLoader(_swfLoader);
		}

		private function onLoad(swfLoader:SWFLoader):void
		{
			_nativeLoader = swfLoader.loader;
			_swfLoader = null;
			_readyEvent.dispatch();
		}

		public function dispose():void
		{
			if (_swfLoader)
			{
				_manager.removeLoader(_swfLoader);
				_swfLoader = null;
			}
			else if (_nativeLoader)
			{
				_nativeLoader.unloadAndStop();
				_nativeLoader = null;
			}
		}

		public function createInstance(className:String):Object
		{
			var classRef:Class = Class(domain.getDefinition(className));
			return new classRef();
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get isReady():Boolean
		{
			return Boolean(_nativeLoader);
		}

		public function get domain():ApplicationDomain
		{
			return _nativeLoader.contentLoaderInfo.applicationDomain;
		}

		public function get readyEvent():EventSender
		{
			return _readyEvent;
		}

		public function get hasReferences():Boolean
		{
			return !_references.isEmpty();
		}

		public function toString():String
		{
			return "ResourceBundle(" + _references.getKeys().length + ") " + _url;
		}
	}
}