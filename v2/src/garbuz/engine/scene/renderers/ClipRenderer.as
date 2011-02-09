package garbuz.engine.scene.renderers
{
	import flash.display.Sprite;

	import garbuz.common.utils.MathUtil;

	public class ClipRenderer extends SpriteRenderer
	{
		private var _isPlaying:Boolean = false;
		private var _currentFrame:int = 1;
		private var _playHandler:Function = loopHandler;

		public function ClipRenderer(content:Sprite)
		{
			super(content);
		}

		override protected function onInitialize():void
		{
			super.onInitialize();

			if (_isPlaying)
				engine.addFrameListener(this, _playHandler);
		}

		public function play():void
		{
			beginPlay();
		}

		public function stop():void
		{
			stopPlay();
		}

		public function nextFrame():void
		{
			if (++_currentFrame > totalFrames)
				_currentFrame = 1;

			updateFrame();
		}

		public function prevFrame():void
		{
			if (--_currentFrame == 0)
				_currentFrame = totalFrames;

			updateFrame();
		}

		private function beginPlay():void
		{
			if (!_isPlaying)
			{
				_isPlaying = true;

				if (isInitialized)
					engine.addFrameListener(this, _playHandler);
			}
		}

		private function stopPlay():void
		{
			if (_isPlaying)
			{
				_isPlaying = false;

				if (isInitialized)
					engine.removeFrameListener(this, _playHandler);
			}
		}

		private function loopHandler():void
		{
			nextFrame();
		}

		protected function updateFrame():void
		{
			// virtual
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public function get totalFrames():int
		{
			return 0;
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
				updateFrame();
			}
		}

	}
}
