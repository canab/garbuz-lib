package garbuz.common.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	public class ClipUtil
	{
		public static function addFrameScripts(clip:MovieClip, handlers:Object):void
		{
			var labels:Array = clip.currentLabels;

			for each (var label:FrameLabel in labels)
			{
				var handler:Function = handlers[label.name];
				
				if (handler != null)
					clip.addFrameScript(label.frame - 1, handler);
			}
		}
	}
}
