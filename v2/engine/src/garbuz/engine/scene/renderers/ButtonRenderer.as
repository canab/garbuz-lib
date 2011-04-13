package garbuz.engine.scene.renderers 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	import garbuz.common.events.EventSender;

	public class ButtonRenderer extends DisplayObjectRenderer
	{
		private var _button:SimpleButton;
		private var _clickEvent:EventSender = new EventSender(this);
		
		public function ButtonRenderer(button:SimpleButton) 
		{
			super(_button = button);
			_button.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_clickEvent.dispatch();
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
		
	}

}