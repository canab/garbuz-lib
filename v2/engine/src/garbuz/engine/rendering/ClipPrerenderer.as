package garbuz.engine.rendering
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import garbuz.common.comparing.AnimationRequirement;
	import garbuz.common.processing.IProcessable;
	import garbuz.common.query.fromDisplay;
	import garbuz.common.utils.BitmapUtil;

	public class ClipPrerenderer implements IProcessable
	{
		private var _frames:Vector.<BitmapFrame>;
		private var _content:Sprite;
		private var _subClips:Array = [];
		private var _totalFrames:int;
		private var _currentFrame:int;
		private var _container:Sprite = new Sprite();

		public function ClipPrerenderer(sprite:Sprite, frames:Vector.<BitmapFrame> = null)
		{
			_content = sprite;
			_frames = frames ? frames : new <BitmapFrame>[];
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
				rootClip.gotoAndStop(1);
				_subClips.push(rootClip);
				_totalFrames = rootClip.totalFrames;
			}

			var children:Array = fromDisplay(_content)
					.byRequirement(new AnimationRequirement())
					.findAllRecursive();

			for each (var child:MovieClip in children)
			{
				child.gotoAndStop(1);
				_subClips.push(child);
				_totalFrames = Math.max(_totalFrames, child.totalFrames);
			}
		}

		public function process():void
		{
			_frames.push(getNextFrame());
		}

		public function renderAllFrames():void
		{
			while (!completed)
			{
				process();
			}
		}

		private function getNextFrame():BitmapFrame
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

			gotoNextFrame();

			return frame;
		}

		private function gotoNextFrame():void
		{
			_currentFrame++;

			for each (var clip:MovieClip in _subClips)
			{
				if (clip.currentFrame < clip.totalFrames)
					clip.nextFrame();
				else
					clip.gotoAndStop(1);
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get completed():Boolean
		{
			return _frames.length == _totalFrames;
		}

		public function get frames():Vector.<BitmapFrame>
		{
			return _frames;
		}
	}

}