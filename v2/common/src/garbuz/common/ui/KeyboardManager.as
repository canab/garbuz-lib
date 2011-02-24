package garbuz.common.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	import garbuz.common.events.EventSender;

	public class KeyboardManager
	{
		static private var _instance:KeyboardManager;
		
		static public function get instance():KeyboardManager
		{
			if (!_instance)
				_instance = new KeyboardManager(new PrivateConstructor());
				
			return _instance;
		}
		
		private var _pressEvent:EventSender = new EventSender(this);
		private var _releaseEvent:EventSender = new EventSender(this);
		private var _pressedKeys:Dictionary = new Dictionary();
		private var _root:Sprite;

		//noinspection JSUnusedLocalSymbols
		public function KeyboardManager(param:PrivateConstructor)
		{
			super();
		}
		
		public function initialize(root:Sprite):void 
		{
			_root = root;
			
			if (_root.stage)
				addStageListeners();
			else
				_root.addEventListener(Event.ADDED_TO_STAGE, addStageListeners);
		}
		
		private function addStageListeners(e:Event = null):void 
		{
			_root.removeEventListener(Event.ADDED_TO_STAGE, addStageListeners);
			
			_root.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_root.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_root.stage.addEventListener(Event.DEACTIVATE, clearKeys);
		}
		
		public function clearKeys(e:Event = null):void
		{
			_pressedKeys = new Dictionary();
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			_pressedKeys[e.keyCode] = true;
			_pressEvent.dispatch(e);
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			delete _pressedKeys[e.keyCode];
			_releaseEvent.dispatch(e);
		}
		
		public function isKeyPressed(keyCode:int):Boolean
		{
			return (keyCode in _pressedKeys);
		}
		
		public function get pressedKeys():Array
		{
			var result:Array = [];
			for (var keyCode:Object in _pressedKeys) 
			{
				result.push(keyCode);
			}
			
			return result;
		}
		
		public function get initialized():Boolean
		{
			return Boolean(_root);
		}
		
		public function get pressEvent():EventSender { return _pressEvent; }
		
		public function get releaseEvent():EventSender { return _releaseEvent; }
		
	}
}

internal class PrivateConstructor {}