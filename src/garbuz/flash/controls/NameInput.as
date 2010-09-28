package garbuz.flash.controls 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.KeyLocation;
	import garbuz.common.events.EventSender;
	import garbuz.common.utils.StringUtil;
	/**
	 * ...
	 * @author canab
	 */
	public class NameInput
	{
		private var _field:TextField;
		private var _text:String;
		private var _margins:int = 10;
		private var _prevText:String;
		private var _changeFlag:Boolean;
		
		private var _changeEvent:EventSender = new EventSender(this);
		private var _wrongCharEvent:EventSender = new EventSender(this);
		
		public function NameInput(field:TextField) 
		{
			_field = field;
			_field.multiline = false;
			_field.wordWrap = false;
			_field.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_field.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_field.addEventListener(Event.CHANGE, onTextChange);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (!_changeFlag && e.charCode > 32 && e.charCode != 127)
				_wrongCharEvent.dispatch();
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			_changeFlag = false;
		}
		
		public function set cursorPosition(position:int):void
		{
			_field.setSelection(position, position);
		}
		
		private function onTextChange(e:Event):void 
		{
			var savedText:String = _field.text;
			
			_field.text = _field.text.replace(/\s/g, "_");
			_changeFlag = true;
			
			if (_field.textWidth > _field.width - 2 * _margins)
			{
				_field.text = _text;
			}
			else
			{
				_field.text = savedText;
				_text = savedText;
				_changeEvent.dispatch();
			}
		}
		
		public function get margins():int { return _margins; }
		public function set margins(value:int):void 
		{
			_margins = value;
		}
		
		public function get text():String { return StringUtil.trim(_text); }
		public function set text(value:String):void 
		{
			_text = StringUtil.trim(value);
			_field.text = _text;
			
			cursorPosition = _text.length;
		}
		
		public function get isEmpty():Boolean
		{
			return text.length == 0;
		}
		
		public function get changeEvent():EventSender { return _changeEvent; }
		
		public function get field():TextField { return _field; }
		
		public function get wrongCharEvent():EventSender { return _wrongCharEvent; }
		
	}

}