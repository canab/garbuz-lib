package garbuz.engine.rendering
{
	import flash.display.MovieClip;

	import garbuz.common.commands.AsincCommand;
	import garbuz.common.commands.ICancelableCommand;
	import garbuz.common.processing.EnterFrameProcessor;

	public class CacheRenderer extends AsincCommand implements ICancelableCommand
	{
		private var _processor:EnterFrameProcessor = new EnterFrameProcessor();
		private var _cache:BitmapCache;
		private var _executed:Boolean;

		public function CacheRenderer(cache:BitmapCache)
		{
			_cache = cache;
		}

		public function addClip(key:Object, clip:MovieClip):CacheRenderer
		{
			var frames:Vector.<BitmapFrame> = _cache.getFrames(key);
			var renderer:ClipPrerenderer = new ClipPrerenderer(clip, frames);
			_processor.addTarget(renderer);

			return this;
		}

		override public virtual function execute():void
		{
			_processor.completeEvent.addListener(onProcessorComplete);
			_processor.execute();
			_executed = true;
		}

		private function onProcessorComplete():void
		{
			_executed = false;
			dispatchComplete();
		}

		public function cancel():void
		{
			if (_executed)
			{
				_executed = false;
				_processor.cancel();
			}
		}
	}
}


