package garbuz.simpleControls
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	import garbuz.common.events.EventManager;
	import garbuz.common.events.EventSender;
	import garbuz.common.ui.KeyboardManager;

	public class ScreenBase
	{
		private var _content:Sprite;
		private var _isActive:Boolean = false;
		private var _isFirstActivate:Boolean = true;

		private var _events:EventManager;

		public function ScreenBase(content:Sprite)
		{
			_content = content;
			_content.mouseEnabled = false;
			_content.opaqueBackground = 0;
			_content.focusRect = false;
		}

		internal function activate():void
		{
			_isActive = true;
			_content.stage.focus = _content;
			KeyboardManager.instance.pressEvent.addListener(internalOnKeyPress);
			onActivate();
			_isFirstActivate = false;
		}

		internal function deactivate():void
		{
			_isActive = false;
			KeyboardManager.instance.pressEvent.removeListener(internalOnKeyPress);
			onDeactivate();
		}

		internal function processAdd():void
		{
			onAdd();
		}

		internal function processRemove():void
		{
			if (_events)
				_events.clearEvents();

			onRemove();
		}

		//noinspection JSUnusedLocalSymbols
		private function internalOnKeyPress(sender:KeyboardManager, keyEvent:KeyboardEvent):void
		{
			onKeyPress(keyEvent);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// virtual handlers
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected virtual function onAdd():void {}

		protected virtual function onActivate():void {}

		protected virtual function onKeyPress(e:KeyboardEvent):void {}

		protected virtual function onDeactivate():void {}

		protected virtual function onRemove():void {}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// events
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function registerEvent(event:EventSender, handler:Function):void
		{
			eventManager.registerEvent(event, handler);
		}

		public function unregisterEvent(event:EventSender, handler:Function):void
		{
			eventManager.unregisterEvent(event, handler);
		}

		public function registerNativeEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			eventManager.registerNativeEvent(object, type, listener, useCapture);
		}

		public function unregisterNativeEvent(object:EventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			eventManager.unregisterNativeEvent(object, type, listener, useCapture);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get isActive():Boolean
		{
			return _isActive;
		}

		protected function get isFirstActivate():Boolean
		{
			return _isFirstActivate;
		}

		public function get content():Sprite
		{
			return _content;
		}

		private function get eventManager():EventManager
		{
			if (!_events)
				_events = new EventManager();

			return _events;
		}
	}

}