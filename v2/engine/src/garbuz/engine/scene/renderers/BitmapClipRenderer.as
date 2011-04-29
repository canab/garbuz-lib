package garbuz.engine.scene.renderers
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class BitmapClipRenderer extends ClipRenderer
	{
		private var _content:Sprite;

		private var _frames:Vector.<BitmapFrame>;
		private var _bitmap:Bitmap = new Bitmap();

		public function BitmapClipRenderer(frames:Vector.<BitmapFrame> = null)
		{
			super(_content = new Sprite());

			_frames = frames;
			_content.addChild(_bitmap);
		}

		public function captureClip(target:Sprite):void
		{
			frames = new ClipPrerenderer(target).getAllFrames();

			_content.x = int(target.x);
			_content.y = int(target.y);
		}

		override protected function updateFrame():void
		{
			var frame:BitmapFrame = _frames[currentFrame - 1];
			
			if (frame)
			{
				_bitmap.bitmapData = frame.data;
				_bitmap.x = frame.x;
				_bitmap.y = frame.y;
			}
			else
			{
				_bitmap.bitmapData = null;
			}
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public function get frames():Vector.<BitmapFrame>
		{
			return _frames;
		}

		public function set frames(value:Vector.<BitmapFrame>):void
		{
			_frames = value;
			currentFrame = 1;
			updateFrame();
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

		override public function get totalFrames():int
		{
			return _frames.length;
		}
	}
}
