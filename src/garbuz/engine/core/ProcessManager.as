package garbuz.engine.core 
{
	import flash.events.Event;
	import garbuz.common.commands.CallFunctionCommand;
	import garbuz.common.commands.ICommand;
	import garbuz.common.errors.ItemNotFoundError;
	/**
	 * ...
	 * @author canab
	 */
	internal class ProcessManager
	{
		private var _engine:Engine;
		private var _frameListeners:Vector.<Component>		= new Vector.<Component>();
		private var _afterCalls:Vector.<ICommand>           = new Vector.<ICommand>();
		private var _delayedCalls:Vector.<DelayedCall>      = new Vector.<DelayedCall>();
		private var _isProcessing:Boolean = false;
		private var _disposed:Boolean = false;
		
		public function ProcessManager(engine:Engine) 
		{
			_engine = engine;
		}
		
		internal function start():void 
		{
			_engine.root.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		internal function stop():void 
		{
			_engine.root.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		internal function dispose():void
		{
			stop();
			_disposed = true;
		}
		
		internal function addFrameListener(component:Component):void
		{
			if (_isProcessing)
				_afterCalls.push(new CallFunctionCommand(addFrameListener, [component]));
			else
				_frameListeners.push(component);
		}
		
		internal function removeFrameListener(component:Component):void
		{
			if (_isProcessing)
			{
				_afterCalls.push(new CallFunctionCommand(removeFrameListener, [component]));
			}
			else
			{
				var index:int = _frameListeners.indexOf(component);
				if (index == -1)
					throw new ItemNotFoundError();
				else
					_frameListeners.splice(index, 1);
			}
		}
		
		internal function addDelayedCall(time:int, command:ICommand):void
		{
			if (_isProcessing)
			{
				_afterCalls.push(new CallFunctionCommand(addDelayedCall, [time, command]));
			}
			else
			{
				var frames:int = Math.max(time / 1000.0 * _engine.root.stage.frameRate, 1);
				_delayedCalls.push(new DelayedCall(frames, command));
			}
		}
		
		internal function removeDelayedCall(command:ICommand):void
		{
			if (_isProcessing)
			{
				_afterCalls.push(new CallFunctionCommand(removeDelayedCall, [command]));
			}
			else
			{
				for (var i:int = 0; i < _delayedCalls.length; i++) 
				{
					if (_delayedCalls[i].command == command)
					{
						_delayedCalls.splice(i, 1);
						return;
					}
				}
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_isProcessing = true;
			processFrameListeners();
			_isProcessing = false;
			
			processAfterCalls();
			
			_isProcessing = true;
			processDelayedCalls();
			_isProcessing = false;
			
			processAfterCalls();
		}
		
		private function processFrameListeners():void
		{
			for each (var component:Component in _frameListeners) 
			{
				if (_disposed)
					break;
				
				if (component.disposed)
					removeFrameListener(component);
				else
					component.onEnterFrame();
			}
		}
		
		private function processDelayedCalls():void
		{
			var i:int = 0;
			var call:DelayedCall;
			
			while (i < _delayedCalls.length && !_disposed)
			{
				call = _delayedCalls[i];
				call.numFrames--;
				
				if (call.numFrames == 0)
				{
					call.command.execute();
					_delayedCalls.splice(i, 1);
				}
				else 
				{
					i++;
				}
			}
		}
		
		private function processAfterCalls():void
		{
			for each (var command:ICommand in _afterCalls) 
			{
				if (_disposed)
					break;
					
				command.execute();
			}
			
			_afterCalls.length = 0;
		}
		
	}

}