package garbuz.engine.scene
{
	import garbuz.common.utils.ArrayUtil;
	import garbuz.engine.core.Component;

	public class RandomAnimations extends Component
	{
		private var _items:Vector.<IClipRenderer> = new <IClipRenderer>[];
		private var _nowPlaying:Vector.<IClipRenderer> = new <IClipRenderer>[];
		private var _period:int;

		public function RandomAnimations(period:int = 1000)
		{
			_period = period;
		}

		public function addItems(renderers:Vector.<IClipRenderer> = null):void
		{
			for each (var clipRenderer:IClipRenderer in renderers)
			{
				addItem(clipRenderer);
			}
		}

		public function addItem(clipRenderer:IClipRenderer):void
		{
			_items.push(clipRenderer);
			clipRenderer.currentFrame = clipRenderer.totalFrames;
			clipRenderer.playCompleteEvent.addListener(onPlayComplete);
		}

		override protected virtual function onInitialize():void
		{
			addDelayedCall(_period, playNext);
		}

		private function playNext():void
		{
			var clip:IClipRenderer = ArrayUtil.getRandomItem(_items);

			if (_nowPlaying.indexOf(clip) == -1)
			{
				_nowPlaying.push(clip);

				clip.currentFrame = 1;
				clip.playForward();
			}

			addDelayedCall(_period, playNext);
		}

		private function onPlayComplete(clip:IClipRenderer):void
		{
			ArrayUtil.removeItem(_nowPlaying, clip);
		}
	}
}
