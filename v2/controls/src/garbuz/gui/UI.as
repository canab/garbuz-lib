package garbuz.gui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	import garbuz.common.display.StageReference;
	import garbuz.common.errors.AlreadyInitializedError;
	import garbuz.common.errors.NotInitializedError;
	import garbuz.common.localization.MessageBundle;
	import garbuz.controls.ControlBase;
	import garbuz.controls.WindowBase;
	import garbuz.controls.interfaces.ITooltip;

	public class UI
	{
		private static var _instance:UI;

		public static function initialize(root:Sprite, bounds:Rectangle):void
		{
			if (initialized)
				throw new AlreadyInitializedError();

			_instance = new UI(new PrivateConstructor());
			_instance.initialize(root, bounds);
		}

		public static function get initialized():Boolean
		{
			return Boolean(_instance);
		}

		public static function addWindow(window:WindowBase):void
		{
			instance.windowManager.addWindow(window);
		}

		public static function removeWindow(window:WindowBase):void
		{
			instance.windowManager.removeWindow(window);
		}

		public static function removeAllWindows():void
		{
			instance.windowManager.removeAllWindows();
		}

		public static function getWindow(windowName:String):WindowBase
		{
			return instance.windowManager.getWindow(windowName);
		}

		public static function hasWindow(windowName:String):Boolean
		{
			return instance.windowManager.hasWindow(windowName);
		}

		public static function activateWindow(window:WindowBase):void
		{
			instance.windowManager.activateWindow(window);
		}

		public static function showPopup(control:ControlBase, relatedControl:ControlBase):void
		{
			instance.popupManager.showPopup(control, relatedControl);
		}

		public static function registerTooltip(target:DisplayObject, message:String, bundle:MessageBundle = null):void
		{
			instance.tooltipManager.registerObject(target, message, bundle);
		}

		public static function unregisterTooltip(target:DisplayObject):void
		{
			instance.tooltipManager.unregisterObject(target);
		}

		public static function get stage():Stage
		{
			return instance.stage;
		}

		public static function get tooltipRenderer():ITooltip
		{
			return instance.tooltipRenderer;
		}

		public static function set tooltipRenderer(value:ITooltip):void
		{
			instance.tooltipRenderer = value;
		}

		internal static function get instance():UI
		{
			if (!initialized)
				throw new NotInitializedError();

			return _instance;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _root:Sprite;
		private var _bounds:Rectangle;

		private var _popupManager:PopupManager;
		private var _tooltipManager:ToolTipManager;
		private var _windowManager:WindowManager;

		internal var tooltipRenderer:ITooltip;

		//noinspection JSUnusedLocalSymbols
		public function UI(param:PrivateConstructor)
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

		public function get root():Sprite
		{
			return _root;
		}

		public function get bounds():Rectangle
		{
			return _bounds;
		}

		public function get popupManager():PopupManager
		{
			if (!_popupManager)
				_popupManager = new PopupManager();

			return _popupManager;
		}

		public function get stage():Stage
		{
			return StageReference.stage;
		}

		public function get tooltipManager():ToolTipManager
		{
			if (!_tooltipManager)
				_tooltipManager = new ToolTipManager();
			
			return _tooltipManager;
		}

		public function get windowManager():WindowManager
		{
			if (!_windowManager)
				_windowManager = new WindowManager();

			return _windowManager;
		}
	}
}

internal class PrivateConstructor {}
