package garbuz.engine.scene.renderers
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import garbuz.common.comparing.AnimationRequirement;
	import garbuz.common.query.fromDisplay;
	import garbuz.common.utils.BitmapUtil;

	internal class ClipPrerenderer
	{
		private var _content:Sprite;
		private var _subClips:Array = [];
		private var _totalFrames:int;
		private var _currentFrame:int;
		private var _container:Sprite = new Sprite();

		public function ClipPrerenderer(sprite:Sprite)
		{
			_content = sprite;
			_container.addChild(_content);
			initialize();
		}

		private function initialize():void
		{
			_currentFrame = 1;
			_totalFrames = 1;

			var rootClip:MovieClip = _content as MovieClip;

			if (rootClip && rootClip.totalFrames > 1)
			{
				rootClip.stop();
				_subClips.push(rootClip);
				_totalFrames = rootClip.totalFrames;
			}

			var children:Array = fromDisplay(_content)
					.byRequirement(new AnimationRequirement())
					.findAllRecursive();

			for each (var child:MovieClip in children)
			{
				child.stop();
				_subClips.push(child);
				_totalFrames = Math.max(_totalFrames, child.totalFrames);
			}
		}

		public function getAllFrames():Vector.<BitmapFrame>
		{
			var result:Vector.<BitmapFrame> = new <BitmapFrame>[];

			while (hasNext)
			{
				result.push(getNextFrame());
			}

			return result;
		}

		public function getNextFrame():BitmapFrame
		{
			var frame:BitmapFrame = null;
			var bounds:Rectangle = BitmapUtil.calculateIntBounds(_container);

			if (bounds.width > 0 && bounds.height > 0)
			{
				frame = new BitmapFrame();
				var matrix:Matrix = new Matrix();
				matrix.translate(-bounds.left, -bounds.top);
				frame.x = bounds.left - int(_content.x);
				frame.y = bounds.top - int(_content.y);

				frame.data = new BitmapData(bounds.width, bounds.height, true, 0x000000);
				frame.data.draw(_container, matrix);
			}

			nextFrame();

			return frame;
		}

		private function nextFrame():void
		{
			_currentFrame++;

			for each (var clip:MovieClip in _subClips)
			{
				if (clip.currentFrame < clip.totalFrames)
				{
					clip.nextFrame();
				}
				else
				{
					clip.gotoAndStop(1);
				}
			}
		}

		public function get hasNext():Boolean
		{
			return _currentFrame <= _totalFrames;
		}
	}

}