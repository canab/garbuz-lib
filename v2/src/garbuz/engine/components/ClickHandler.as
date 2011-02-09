package garbuz.engine.components 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import garbuz.common.events.EventSender;
	import garbuz.engine.core.Component;
	/**
	 * ...
	 * @author canab
	 */
	public class ClickHandler extends Component
	{
		private var _content:InteractiveObject;
		private var _clickEvent:EventSender = new EventSender(this);
		
		public function ClickHandler(content:InteractiveObject) 
		{
			_content = content;
		}
		
		override protected function onInitialize():void 
		{
			_content.mouseEnabled = true;
			_content.addEventListener(MouseEvent.CLICK, onClick);
			
			if (_content is Sprite)
				Sprite(_content).buttonMode = true;
		}
		
		override protected function onDispose():void 
		{
			_content.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_clickEvent.dispatch();
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
	}

}