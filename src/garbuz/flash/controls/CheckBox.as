package garbuz.flash.controls 
{
	import garbuz.common.events.EventSender;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author canab
	 */
	public class CheckBox
	{
		private var _content:MovieClip;
		
		private var _clickEvent:EventSender = new EventSender(this);
		private var _checked:Boolean = false;
		private var _enabled:Boolean = true;
		
		public function CheckBox(content:MovieClip) 
		{
			_content = content;
			initialize();
			refresh();
		}
		
		private function initialize():void
		{
			_content.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			checked = !checked;
			_clickEvent.dispatch();
		}
		
		private function refresh():void
		{
			_content.mouseEnabled = _enabled;
			_content.useHandCursor = _enabled;
			_content.buttonMode = _enabled;
			
			if (_checked)
				_content.gotoAndStop(2);
			else
				_content.gotoAndStop(1);
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
		public function get checked():Boolean { return _checked; }
		public function set checked(value:Boolean):void 
		{
			if (_checked != value)
			{
				_checked = value;
				refresh();
			}
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			if (_enabled != value)
			{
				_enabled = value;
				refresh();
			}
		}
		
		
		
	}

}