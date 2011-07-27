package garbuz.common.processing 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	import garbuz.common.commands.AsincCommand;
	import garbuz.common.commands.ICancelableCommand;

	public class EnterFrameProcessor extends AsincCommand implements ICancelableCommand
	{
		private var _frameDispatcher:Shape = new Shape();
		private var _targets:Vector.<IProcessable> = new <IProcessable>[];
		private var _currentTarget:IProcessable;
		private var _timeLimit:int;

		public function EnterFrameProcessor(timeLimit:int = 50)
		{
			_timeLimit = timeLimit;
		}

		public function addTarget(target:IProcessable):void
		{
			_targets.push(target);
		}
		
		override public function execute():void
		{
			_currentTarget = getNextTarget();
			_frameDispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void
		{
			var startTime:int = getTimer();
			var currentTime:int = 0;

			while (_currentTarget && currentTime < _timeLimit)
			{
				_currentTarget.process();

				if (_currentTarget.completed)
					_currentTarget = getNextTarget();

				currentTime = getTimer() - startTime;
			}
			
			if (!_currentTarget)
			{
				stopProcessing();
				dispatchComplete();
			}
		}

		private function getNextTarget():IProcessable
		{
			return (_targets.length > 0) ? _targets.shift() : null;
		}

		public function cancel():void
		{
			stopProcessing();
		}
		
		private function stopProcessing():void 
		{
			_frameDispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}

}