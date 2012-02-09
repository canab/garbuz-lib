package garbuz.common.display
{
	import flash.display.MovieClip;
	import flash.events.Event;

	import garbuz.common.collections.WeakObjectMap;
	import garbuz.common.commands.AsincCommand;
	import garbuz.common.commands.ICancelableCommand;
	import garbuz.common.utils.DisplayUtil;

	public class MoviePlayer extends AsincCommand implements ICancelableCommand
	{
		static private const _players:WeakObjectMap = new WeakObjectMap(MovieClip, MoviePlayer);
		
		static public function disposeAllClips():void
		{
			for each (var player:MoviePlayer in _players.getValues())
			{
				player.cancel();
			}
		}

		static public function disposeClip(clip:MovieClip):void
		{
			var player:MoviePlayer = _players[clip];
			if (player)
				player.cancel();
		}

		static public function getPlayer(clip:MovieClip):MovieClip
		{
			return _players[clip];
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//
		// instance
		//
		/////////////////////////////////////////////////////////////////////////////////////

		public var clip:MovieClip;
		public var toFrame:int;
		public var fromFrame:int;
		
		public function MoviePlayer(clip:MovieClip = null, fromFrame:int = 1, toFrame:int = 0)
		{
			this.clip = clip;
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0) ? toFrame : clip.totalFrames;
		}

		public function detachOnComplete():MoviePlayer
		{
			completeEvent.addListener(detachFromDisplay);
			return this;
		}

		private function detachFromDisplay():void
		{
			DisplayUtil.detachFromDisplay(clip);
		}
		
		public function play(fromFrame:int = 1, toFrame:int = 0):MoviePlayer
		{
			this.fromFrame = fromFrame;
			this.toFrame = (toFrame > 0) ? toFrame : clip.totalFrames;
			
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
				stop();
				dispatchComplete();
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
		
		override public function execute():void
		{
			var currentPlayer:MoviePlayer = _players[clip];

			if (currentPlayer)
				currentPlayer.cancel();
			
			_players[clip] = this;
			
			clip.gotoAndStop(fromFrame);
			clip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function cancel():void
		{
			clip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_players.removeKey(clip);
		}
		
		public function stop():void
		{
			cancel();
		}
		
	}

}