package garbuz.flash 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import garbuz.common.commands.ICancelableCommand;
	import garbuz.common.events.EventSender;
	import garbuz.common.utils.ArrayUtil;

	/**
	 * ...
	 * @author Canab
	 */
	public class MoviePlayer implements ICancelableCommand
	{
		static private const _players:Dictionary = new Dictionary(true);
		
		static public function disposeAllClips():void
		{
			var keys:Array = ArrayUtil.getKeys(_players);
			for each (var key:MovieClip in keys)
			{
				MoviePlayer(_players[key]).stopPlaying();
			}
		}
		
		public var clip:MovieClip;
		public var toFrame:int;
		public var fromFrame:int;
		
		private var _completeEvent:EventSender = new EventSender(this);
		
		public function MoviePlayer(clip:MovieClip = null, fromFrame:int = 1, toFrame:int = 0) 
		{
			this.clip = clip;
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
		}
		
		public function play(fromFrame:int = 1, toFrame:int = 0):MoviePlayer
		{
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0)
				? toFrame
				: clip.totalFrames;
			
			execute();
			
			return this;
		}
		
		public function playTo(toFrame:int):MoviePlayer
		{
			play(clip.currentFrame, toFrame);
			return this;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (clip.currentFrame == toFrame)
			{
				stopPlaying();
				_completeEvent.dispatch();
			}
			else if (clip.currentFrame < toFrame)
			{
				clip.nextFrame();
			}
			else
			{
				clip.prevFrame();
			}
		}
		
		/* INTERFACE common.commands.IAsincCommand */
		
		public function get completeEvent():EventSender
		{
			return _completeEvent;
		}
		
		public function execute():void
		{
			var currentPlayer:MoviePlayer = _players[clip];
			if (currentPlayer)
				currentPlayer.cancel();
			_players[clip] = this;
			
			clip.gotoAndStop(fromFrame);
			clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/* INTERFACE common.commands.ICancelableCommand */
		
		public function cancel():void
		{
			stopPlaying();
		}
		
		private function stopPlaying():void 
		{
			clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			delete _players[clip];
		}
		
	}

}