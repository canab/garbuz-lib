package garbuz.engine.scene.renderers 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import garbuz.common.events.EventSender;

	/**
	 * ...
	 * @author canab
	 */
	public class SpriteRenderer extends DisplayObjectRenderer
	{
		private var _content:Sprite;
		private var _clickEvent:EventSender;
		
		public function SpriteRenderer(content:Sprite) 
		{
			_content = content;
			_content.mouseEnabled = false;
			_content.mouseChildren = false;
			super(_content);
		}
		
		public function get sprite():Sprite
		{
			return _content as Sprite;
		}

		public function get clickEvent():EventSender
		{
			if (!_clickEvent)
			{
				_clickEvent = new EventSender(this);
				_content.addEventListener(MouseEvent.CLICK, onClick);
			}

			return _clickEvent;
		}

		private function onClick(event:MouseEvent):void
		{
			_clickEvent.dispatch();
		}
	}

}