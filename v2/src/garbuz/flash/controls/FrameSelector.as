package garbuz.flash.controls
{
	import garbuz.common.events.EventSender;
	import garbuz.common.utils.MathUtil;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FrameSelector
	{
		static public const PREV_NAME:String = 'btnPrev';
		static public const NEXT_NAME:String = 'btnNext';
		static public const FRAMES_NAME:String = 'mcFrames';
		
		private var _content:Sprite;
		private var _clickEvent:EventSender = new EventSender(this);
		
		public function FrameSelector(content:Sprite)
		{
			_content = content;
			initialize();
			frameNum = 1;
		}
		
		private function initialize():void
		{
			prevButon.addEventListener(MouseEvent.CLICK, onPrevClick);
			nextButon.addEventListener(MouseEvent.CLICK, onNextClick);
		}
		
		private function onPrevClick(e:MouseEvent):void
		{
			frameNum--;
			_clickEvent.dispatch();
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			frameNum++;
			_clickEvent.dispatch();
		}
		
		public function refresh():void
		{
			setBtnEnabled(prevButon, frames.currentFrame > 1);
			setBtnEnabled(nextButon, frames.currentFrame < frames.totalFrames);
		}
		
		private function setBtnEnabled(object:InteractiveObject, enabled:Boolean):void
		{
			object.mouseEnabled = enabled;
			
			if (object is Sprite)
				Sprite(object).mouseChildren = enabled;
				
			object.alpha = (enabled) ? 1.0 : 0.5;
		}
		
		public function get frameNum():int
		{
			return frames.currentFrame;
		}
		
		public function set frameNum(value:int):void
		{
			value = MathUtil.claimRange(value, 1, frames.totalFrames);
			frames.gotoAndStop(value);
			refresh();
		}
		
		public function get nextButon():SimpleButton
		{
			return _content[NEXT_NAME];
		}
		
		public function get prevButon():SimpleButton
		{
			return _content[PREV_NAME];
		}
		
		public function get frames():MovieClip
		{
			return _content[FRAMES_NAME];
		}
		
		public function get content():Sprite { return _content; }
		
		public function get clickEvent():EventSender { return _clickEvent; }
	}
	
}