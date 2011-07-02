package garbuz.controls
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	import garbuz.common.events.EventManager;
	import garbuz.common.events.EventSender;
	import garbuz.gui.UI;

	public class WindowBase extends ControlBase
	{
		private var _events:EventManager;

		public function WindowBase(name:String)
		{
			this.name = name;
			mouseChildren = true;
		}

		controls_internal function processAdd():void
		{
			onAdd();
		}

		controls_internal function processRemove():void
		{
			if (_events)
				_events.clearEvents();

			onRemove();
		}

		protected function closeWindow():void
		{
			UI.removeWindow(this);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// events
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function registerEvent(event:EventSender, handler:Function):void
		{
			events.registerEvent(event, handler);
		}

		public function unregisterEvent(event:EventSender, handler:Function):void
		{
			events.unregisterEvent(event, handler);
		}

		public function registerNativeEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			events.registerNativeEvent(object, type, listener, useCapture);
		}

		public function unregisterNativeEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			events.unregisterNativeEvent(object, type, listener, useCapture);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// virtual
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected virtual function onAdd():void {}

		protected virtual function onRemove():void {}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		private function get events():EventManager
		{
			if (!_events)
				_events = new EventManager();

			return _events;
		}

		override public function get hitArea():Sprite
		{
			return super.hitArea;
		}

		override public function set hitArea(value:Sprite):void
		{
			super.hitArea = value;
			hitArea.mouseChildren = false;
			hitArea.buttonMode = true;
			hitArea.cacheAsBitmap = true;
		}
	}
}
