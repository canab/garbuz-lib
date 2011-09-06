package garbuz.engine.scene
{
	import garbuz.engine.core.Component;

	public class RandomAnimations extends Component
	{
		private var _items:Vector.<IClipRenderer> = new <IClipRenderer>[];
		private var _currentIndex:int = 0;

		public function RandomAnimations()
		{
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
			playNext();
		}

		private function playNext():void
		{
//			var clip:IClipRenderer = ArrayUtil.getRandomItem(_items);

			_currentIndex++;
			if (_currentIndex == _items.length)
				_currentIndex = 0;

			var clip:IClipRenderer = _items[_currentIndex];
			clip.currentFrame = 1;
			clip.playForward();
		}

		private function onPlayComplete():void
		{
			playNext();
		}
	}
}
