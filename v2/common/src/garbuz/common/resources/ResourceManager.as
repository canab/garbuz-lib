package garbuz.common.resources
{
	import flash.system.ApplicationDomain;

	import garbuz.collections.ObjectMap;
	import garbuz.common.errors.NullPointerError;
	import garbuz.common.logging.Logger;

	public class ResourceManager
	{
		private static var _instance:ResourceManager;

		private static var _logger:Logger = new Logger(ResourceManager);

		/**
		 * garbageCollector is running after each GC_COUNTER_MAX allocated resources
		 */
		private static const GC_COUNTER_MAX:int = 50;

		public static function get instance():ResourceManager
		{
			if (!_instance)
				_instance = new ResourceManager(new PrivateConstructor());

			return _instance;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _manager:LoadingManager = new LoadingManager();
		private var _bundles:ObjectMap = new ObjectMap();
		private var _gcCounter:int = 0;

		//noinspection JSUnusedLocalSymbols
		public function ResourceManager(param:PrivateConstructor)
		{
			super();
		}

		public function allocateResource(url:String, reference:Object):ResourceBundle
		{
			var bundle:ResourceBundle = _bundles.getValue(url) as ResourceBundle;

			if (!bundle)
			{
				bundle = new ResourceBundle(url);
				bundle.load(_manager);
				_bundles.put(url, bundle);

				if (++_gcCounter >= GC_COUNTER_MAX)
					collectUnusedResources();
			}

			bundle.addReference(reference);

			return bundle;
		}

		public function createInstance(url:String, className:String):Object
		{
			return getBundle(url).createInstance(className);
		}

		public function getDomain(url:String):ApplicationDomain
		{
			return getBundle(url).domain;
		}

		private function getBundle(url:String):ResourceBundle
		{
			var bundle:ResourceBundle = ResourceBundle(_bundles.getValue(url));

			if (!bundle)
				throw new NullPointerError();

			return bundle;
		}

		public function collectUnusedResources():void
		{
			_logger.info("collectUnusedResources()");

			_gcCounter = 0;

			var urls:Array = _bundles.getKeys();

			for each (var url:String in urls)
			{
				var bundle:ResourceBundle = getBundle(url);
				if (!bundle.hasReferences)
				{
					bundle.dispose();
					_bundles.removeKey(url);
				}
			}
		}

		public function printStats():void
		{
			var bundles:Array = _bundles.getValues();

			for each (var bundle:ResourceBundle in bundles)
			{
				_logger.info(bundle);
			}

			_logger.info("total: " + bundles.length);
		}

	}

}

internal class PrivateConstructor {}