package garbuz.engine.rendering
{
	public class BitmapCache
	{
		private var _cache:Object = {};

		public function contains(id:String):Boolean
		{
			return id in _cache;
		}

		public function getFrames(id:Object):Vector.<BitmapFrame>
		{
			var key:String = String(id);

			var frames:Vector.<BitmapFrame> = _cache[key];
			
			if (frames == null)
			{
				_cache[key] = frames = new <BitmapFrame>[];
			}

			return frames;
		}
	}
}