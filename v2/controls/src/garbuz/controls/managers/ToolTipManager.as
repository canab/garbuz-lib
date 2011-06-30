package garbuz.controls.managers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import garbuz.common.errors.AlreadyInitializedError;
	import garbuz.common.errors.NotInitializedError;
	import garbuz.common.localization.MessageBundle;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.controls.interfaces.ITooltip;
	import garbuz.motion.TweenManager;
	import garbuz.motion.tween;

	public class ToolTipManager
	{
		private static const SHOW_DURATION:Number = 0.1;
		private static const SHOW_DELAY:Number = 0.4;

		private static var _instance:ToolTipManager;

		public static function get instance():ToolTipManager
		{
			if (!_instance)
				throw new NotInitializedError();

			return _instance;
		}

		public static function initialize(tooltip:ITooltip):void
		{
			if (_instance)
				throw new AlreadyInitializedError();

			_instance = new ToolTipManager(new PrivateConstructor());
			_instance.initialize(tooltip);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private var _tooltip:ITooltip;
		private var _targets:Dictionary = new Dictionary(true);
		private var _uiManager:UIManager = UIManager.instance;

		//noinspection JSUnusedLocalSymbols
		public function ToolTipManager(param:PrivateConstructor)
		{
		}

		private function initialize(tooltip:ITooltip):void
		{
			_tooltip = tooltip;
		}

		public function registerObject(target:DisplayObject, message:String, bundle:MessageBundle = null):void
		{
			unregisterObject(target);
			addListeners(target);
			_targets[target] = new TargetData(message, bundle);
		}

		public function unregisterObject(target:DisplayObject):void
		{
			if (_targets[target])
			{
				removeListeners(target);
				delete _targets[target];
				hideTooltip();
			}
		}

		private function addListeners(target:DisplayObject):void
		{
			target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function removeListeners(target:DisplayObject):void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onMouseOver(e:MouseEvent):void
		{
			var data:TargetData = _targets[e.currentTarget];
			showText(data.message, data.bundle);
		}

		private function onMouseOut(e:MouseEvent):void
		{
			hideTooltip();
		}

		private function onRemovedFromStage(event:Event):void
		{
			hideTooltip();
		}

		public function showText(message:String, bundle:MessageBundle = null):void
		{
			_tooltip.text = bundle
					? bundle.getLocalizedText(message)
					: message;

			if (!_tooltip.content.parent)
				showTooltip();

			updatePosition();
		}

		private function showTooltip():void
		{
			_uiManager.root.addChild(_tooltip.content);
			_uiManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			_tooltip.content.alpha = 0;

			tween(_tooltip.content, SHOW_DELAY)
				.tween(SHOW_DURATION)
				.to({alpha: 1});

			updatePosition();
		}

		public function hideTooltip():void
		{
			TweenManager.removeTweensOf(_tooltip.content);

			if (_tooltip.content.parent)
			{
				_uiManager.root.removeChild(_tooltip.content);
				_uiManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}

		private function onMouseMove(e:MouseEvent):void
		{
			updatePosition();
			e.updateAfterEvent();
		}

		private function updatePosition():void
		{
			_tooltip.content.x = _uiManager.root.mouseX;
			_tooltip.content.y = _uiManager.root.mouseY;

			DisplayUtil.claimBounds(_tooltip.content, _uiManager.bounds);
		}

		public function get initialized():Boolean
		{
			return Boolean(_tooltip);
		}

	}
}

import garbuz.common.localization.MessageBundle;

internal class TargetData
{
	public var message:String;
	public var bundle:MessageBundle;

	public function TargetData(message:String, bundle:MessageBundle)
	{
		this.message = message;
		this.bundle = bundle;
	}
}

internal class PrivateConstructor {}
