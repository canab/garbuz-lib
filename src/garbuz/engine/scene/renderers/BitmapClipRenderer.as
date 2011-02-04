package garbuz.engine.scene.renderers
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	import garbuz.common.utils.MathUtil;

	public class BitmapClipRenderer extends SpriteRenderer
	{
		private var _content:Sprite;

		private var _frames:Array;
		private var _currentFrame:int = 1;
		private var _forceCurrentFrame:Boolean = false;
		private var _bitmap:Bitmap = new Bitmap();
		private var _initialized:Boolean = false;
		private var _isPlaying:Boolean = false;

		public function BitmapClipRenderer(frames:Array /*of BitmapFrame*/ = null)
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

		override protected function onInitialize():void
		{
			super.onInitialize();

			if (_isPlaying)
				engine.addFrameListener(this, playHandler);
		}

		private function playHandler():void
		{
			if (!_initialized && _frames[_currentFrame])
			{
				_initialized = true;
				updateBitmap();
			}

			if (_forceCurrentFrame)
				_forceCurrentFrame = false;
			else
				nextFrame();
		}

		public function play():void
		{
			setPlayMode(true);
		}

		public function stop():void
		{
			setPlayMode(false);
		}

		private function setPlayMode(mode:Boolean):void
		{
			if (_isPlaying != mode)
			{
				_isPlaying = mode;

				if (isInitialized)
				{
					if (_isPlaying)
						engine.addFrameListener(this, playHandler);
					else
						engine.removeFrameListener(this, playHandler);
				}
			}
		}

		public function gotoAndPlay(frame:int, scene:String = null):void
		{
			_forceCurrentFrame = true;
			currentFrame = frame;
			setPlayMode(true);
		}

		public function gotoAndStop(frame:int, scene:String = null):void
		{
			currentFrame = frame;
			setPlayMode(false);
		}

		public function nextFrame():void
		{
			if (++_currentFrame > _frames.length)
			{
				_currentFrame = 1;
			}

			updateBitmap();
		}

		public function prevFrame():void
		{
			if (--_currentFrame == 0)
			{
				_currentFrame = _frames.length;
			}

			updateBitmap();
		}


		private function updateBitmap():void
		{
			var frame:BitmapFrame = _frames[_currentFrame - 1];
			
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

		public function get totalFrames():int
		{
			return _frames.length;
		}

		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function set currentFrame(value:int):void
		{
			var frameNum:int = MathUtil.claimRange(value, 1, totalFrames);
			if (frameNum != _currentFrame)
			{
				_currentFrame = frameNum;
				updateBitmap();
			}
		}

		public function set smoothing(value:Boolean):void
		{
			_bitmap.smoothing = value;
		}

		public function get frames():Array /*of BitmapFrame*/
		{
			return _frames;
		}

		public function set frames(value:Array /*of BitmapFrame*/):void
		{
			_frames = value;
			currentFrame = 1;
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
	}
}
