package garbuz.engine.scene.renderers
{
	import flash.display.Sprite;

	import garbuz.common.utils.MathUtil;

	public class ClipRenderer extends SpriteRenderer
	{
		private var _isPlaying:Boolean = false;
		private var _currentFrame:int = 1;
		private var _playHandler:Function;
		private var _endFrame:int;

		public function ClipRenderer(content:Sprite)
		{
			super(content);
		}

		override protected function onInitialize():void
		{
			super.onInitialize();

			if (_isPlaying)
				engine.addFrameListener(this, onPlayFrame);
		}

		public function play():void
		{
			beginPlay(loopHandler);
		}

		public function playTo(frameNum:int):void
		{
			_endFrame = MathUtil.claimRange(frameNum, 1, totalFrames);
			beginPlay(toFrameHandler);
		}

		public function playForward():void
		{
			playTo(totalFrames);
		}

		public function playReverse():void
		{
			playTo(0);
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

		private function beginPlay(playHandler:Function):void
		{
			_playHandler = playHandler;

			if (!_isPlaying)
			{
				_isPlaying = true;

				if (isInitialized)
					engine.addFrameListener(this, onPlayFrame);
			}
		}

		private function stopPlay():void
		{
			if (_isPlaying)
			{
				_isPlaying = false;

				if (isInitialized)
					engine.removeFrameListener(this, onPlayFrame);
			}
		}

		private function onPlayFrame():void
		{
			_playHandler();
		}

		private function loopHandler():void
		{
			nextFrame();
		}

		private function toFrameHandler():void
		{
			if (_currentFrame < _endFrame)
				nextFrame();
			else if (_currentFrame > _endFrame)
				prevFrame();
			else
				stopPlay();
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
