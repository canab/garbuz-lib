package garbuz.controls.managers
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	import garbuz.common.errors.AlreadyInitializedError;
	import garbuz.common.errors.NotInitializedError;

	public class UIManager
	{
		private static var _instance:UIManager;

		public static function get instance():UIManager
		{
			if (!initialized)
				throw new NotInitializedError();

			return _instance;
		}

		public static function initialize(root:Sprite, bounds:Rectangle):void
		{
			if (initialized)
				throw new AlreadyInitializedError();

			_instance = new UIManager(new PrivateConstructor());
			_instance.initialize(root, bounds);
		}

		public static function get initialized():Boolean
		{
			return Boolean(_instance);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _root:Sprite;
		private var _bounds:Rectangle;

		//noinspection JSUnusedLocalSymbols
		public function UIManager(param:PrivateConstructor)
		{
		}

		public function initialize(root:Sprite, bounds:Rectangle):void
		{
			_root = root;
			_bounds = bounds;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get stage():Stage
		{
			return _root.stage;
		}

		public function get root():Sprite
		{
			return _root;
		}

		public function get bounds():Rectangle
		{
			return _bounds;
		}
	}
}

internal class PrivateConstructor {}
