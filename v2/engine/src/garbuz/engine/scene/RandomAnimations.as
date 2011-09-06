package garbuz.engine.scene
{
	import garbuz.common.utils.ArrayUtil;
	import garbuz.engine.core.Component;

	public class RandomAnimations extends Component
	{
		private var _items:Vector.<IClipRenderer>;

		public function RandomAnimations(items:Vector.<IClipRenderer>)
		{
			_items = items;
		}

		override protected virtual function onInitialize():void
		{
			playNext();
		}

		private function playNext():void
		{
			var clip:IClipRenderer = ArrayUtil.getRandomItem(_items);
			clip.currentFrame = 1;
			clip.playCompleteEvent.addListener(onPlayComplete);
			clip.playForward();
		}

		private function onPlayComplete(clip:IClipRenderer):void
		{
			clip.playCompleteEvent.removeListener(onPlayComplete);
			playNext();
		}
	}
}
