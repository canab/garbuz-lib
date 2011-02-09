package garbuz.common.utils
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorUtil
	{
		static public function fromRGB(r:uint, g:uint, b:uint):uint
		{
			return r << 16 | g << 8 | b;
		}

		static public function toRGB(color:uint):Object
		{
			return { r: color >> 16, g: color >> 8 & 0x0000FF, b: color & 0x0000FF };
		}

		static public function addColor(target:DisplayObject, color:int):void
		{
			var rgb:Object = toRGB(color);
			var transform:ColorTransform = target.transform.colorTransform;
			transform.redOffset += rgb.r;
			transform.greenOffset += rgb.g;
			transform.blueOffset += rgb.b;
			target.transform.colorTransform = transform;
		}
		
	}
}