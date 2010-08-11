package garbuz.engine.scene.renderers 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author canab
	 */
	public class SpriteRenderer extends DisplayObjectRenderer
	{
		private var _content:Sprite;
		
		public function SpriteRenderer(content:Sprite) 
		{
			_content = content;
			_content.mouseEnabled = false;
			_content.mouseChildren = false;
			super(_content);
		}
		
	}

}