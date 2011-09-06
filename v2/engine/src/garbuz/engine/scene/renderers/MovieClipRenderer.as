package garbuz.engine.scene.renderers
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import garbuz.common.comparing.AnimationRequirement;
	import garbuz.common.query.fromDisplay;

	public class MovieClipRenderer extends ClipRenderer
	{
		private var _content:Sprite;
		private var _subClips:Vector.<MovieClip> = new <MovieClip>[];
		private var _totalFrames:int = 1;

		public function MovieClipRenderer(content:Sprite)
		{
			super(_content = content);
			initialize();
		}

		private function initialize():void
		{
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

		override protected function updateFrame():void
		{
			for each (var clip:MovieClip in _subClips)
			{
				clip.gotoAndStop(currentFrame % totalFrames);
			}
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		override public function get totalFrames():int
		{
			return _totalFrames;
		}
	}
}
