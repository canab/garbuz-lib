package garbuz.flash.controls
{
	import garbuz.common.events.EventSender;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import garbuz.flash.DragController;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class ScrollBar
	{
		static private const LINE_NAME:String = 'mcLine';
		static private const BUTTON_NAME:String = 'mcButton';
		
		protected var _line:Sprite;
		protected var _button:Sprite;
		protected var _dragController:DragController;
		protected var _position:Number = 0;
		
		private var _changeEvent:EventSender = new EventSender(this);
		private var _enabled:Boolean = true;
		
		public function ScrollBar(content:Sprite)
		{
			_line = content[LINE_NAME];
			_button = content[BUTTON_NAME];
			
			_dragController = new DragController(_button);
			_dragController.bounds = _line.getBounds(content);
			_dragController.dragEvent.addListener(onDrag);
		}
		
		private function onDrag(sender:DragController):void
		{
			updatePosition();
			_changeEvent.dispatch();
		}
		
		protected function updatePosition():void {}
		
		public function set position(value:Number):void
		{
			_position = value;
		}
		
		public function get changeEvent():EventSender { return _changeEvent; }
		
		public function get position():Number { return _position; }
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_button.mouseEnabled = _enabled;
			_button.mouseChildren = _enabled;
		}
		
	}
	
}