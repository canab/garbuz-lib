package garbuz.engine.scene.renderers
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import garbuz.common.utils.BitmapUtil;

	public class BitmapSpriteRenderer extends SpriteRenderer
	{
		private var _content:Sprite;

		public function BitmapSpriteRenderer()
		{
			super(_content = new Sprite());
		}

		public function captureSprite(target:Sprite):void
		{
			_content.x = int(target.x);
			_content.y = int(target.y);
			_content.addChild(target);

			var bounds:Rectangle = BitmapUtil.calculateIntBounds(_content);
			var bitmap:Bitmap = BitmapUtil.convertToBitmap(_content, bounds);
			bitmap.x = Math.round(bounds.x - target.x);
			bitmap.y = Math.round(bounds.y - target.y);

			_content.removeChild(target);
			_content.addChild(bitmap);
		}
	}
}
