package garbuz.common.utils
{
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
	}
}