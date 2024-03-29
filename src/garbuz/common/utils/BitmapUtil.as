package garbuz.common.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class BitmapUtil
	{
		public static function convertToBitmap(content:Sprite, bounds:Rectangle = null, transparent:Boolean = true):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(getBitmapData(content, bounds, transparent));
			bitmap.smoothing = true;
			return bitmap;
		}

		public static function getBitmapData(content:Sprite, bounds:Rectangle = null, transparent:Boolean = true):BitmapData
		{
			bounds = bounds || calculateIntBounds(content);

			var matrix:Matrix = new Matrix();
			matrix.translate(-bounds.left, -bounds.top);

			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, transparent, 0x00000000);
			bitmapData.draw(content, matrix, null, null, null, true);
			return bitmapData;
		}

		public static function calculateIntBounds(content:Sprite):Rectangle
		{
			var bounds:Rectangle = content.getBounds(content);
			bounds.left = int(bounds.left);
			bounds.top = int(bounds.top);
			bounds.right = int(bounds.right) + 1;
			bounds.bottom = int(bounds.bottom) + 1;

			return bounds;
		}
	}
}
