package garbuz.engine.components 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import garbuz.common.events.EventSender;
	import garbuz.engine.core.Component;
	import garbuz.engine.scene.renderers.SpriteRenderer;
	/**
	 * ...
	 * @author canab
	 */
	public class ClickHandler extends Component
	{
		private var _renderer:SpriteRenderer;
		private var _clickEvent:EventSender = new EventSender(this);
		
		public function ClickHandler(renderer:SpriteRenderer) 
		{
			_renderer = renderer;
		}
		
		override protected function onInitialize():void 
		{
			var content:Sprite = Sprite(_renderer.content);
			content.buttonMode = true;
			content.mouseEnabled = true;
			content.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override protected function onDispose():void 
		{
			_renderer.content.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			_clickEvent.dispatch();
		}
		
		public function get clickEvent():EventSender { return _clickEvent; }
	}

}