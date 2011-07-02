package garbuz.gui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import garbuz.common.localization.MessageBundle;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.gui.interfaces.ITooltip;
	import garbuz.motion.TweenManager;
	import garbuz.motion.tween;

	internal class ToolTipManager extends ManagerBase
	{
		private static const SHOW_DURATION:int = 100;
		private static const SHOW_DELAY:int = 400;

		private var _targets:Dictionary = new Dictionary(true);

		public function ToolTipManager()
		{
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

		private function showText(message:String, bundle:MessageBundle = null):void
		{
			tooltip.text = bundle
					? bundle.getLocalizedText(message)
					: message;

			if (!tooltip.content.parent)
				showTooltip();

			updatePosition();
		}

		private function showTooltip():void
		{
			ui.root.addChild(tooltip.content);
			ui.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			tooltip.content.alpha = 0;

			tween(tooltip.content, SHOW_DELAY)
				.tween(SHOW_DURATION)
				.to({alpha: 1});

			updatePosition();
		}

		private function hideTooltip():void
		{
			TweenManager.removeTweensOf(tooltip.content);

			if (tooltip.content.parent)
			{
				ui.root.removeChild(tooltip.content);
				ui.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}

		private function onMouseMove(e:MouseEvent):void
		{
			updatePosition();
			e.updateAfterEvent();
		}

		private function updatePosition():void
		{
			tooltip.content.x = ui.root.mouseX;
			tooltip.content.y = ui.root.mouseY;

			DisplayUtil.claimBounds(tooltip.content, ui.bounds);
		}

		public function get initialized():Boolean
		{
			return Boolean(tooltip);
		}

		public function get tooltip():ITooltip
		{
			if (!ui.tooltipRenderer)
				throw new Error("UI.tooltipRenderer has not been set.");
			
			return ui.tooltipRenderer;
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
