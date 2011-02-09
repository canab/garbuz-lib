package garbuz.flash.controls
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;

	import garbuz.common.events.EventSender;

	/**
	 * ...
	 * @author canab
	 */
	public class SimplePreloader
	{
		static public const PERCENT_NAME:String = 'txtPercent';
		static public const PROGRESS_NAME:String = 'mcProgress';
		
		public var autoDetach:Boolean = true;
		
		private var _completeEvent:EventSender = new EventSender(this);
		
		private var _root:MovieClip;
		private var _content:Sprite;
		private var _progressBar:ProgressBar;
		private var _startBytes:int = 0;
		
		public function SimplePreloader(root:MovieClip, content:Sprite) 
		{
			_root = root;
			_content = content;
			initialize();
		}
		
		private function initialize():void
		{
			_startBytes = _root.loaderInfo.bytesLoaded;
			
			if (progressClip)
				_progressBar = new ProgressBar(progressClip);
				
			setProgress(0);
			
			_root.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_root.addChild(_content);
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			var progressValue:Number = (e.bytesTotal == _startBytes)
				? 1
				: (e.bytesLoaded - _startBytes) / (e.bytesTotal - _startBytes);
			setProgress(progressValue);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (_root.loaderInfo.bytesLoaded == _root.loaderInfo.bytesTotal)
			{
				if (autoDetach)
					_root.removeChild(_content);
				
				_root.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				_completeEvent.dispatch();
			}
		}
		
		private function setProgress(value:Number):void 
		{
			if (percentField)
				percentField.text = String(Math.round(value * 100)) + '%';
				
			if (_progressBar)
				_progressBar.value = value;
		}
		
		public function get progressClip():Sprite
		{
			return _content[PROGRESS_NAME];
		}
		
		public function get percentField():TextField
		{
			return _content[PERCENT_NAME];
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
		public function get content():Sprite { return _content; }
		
	}

}