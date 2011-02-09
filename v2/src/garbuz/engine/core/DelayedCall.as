package garbuz.engine.core 
{
	import garbuz.common.commands.ICommand;
	
	/**
	 * ...
	 * @author canab
	 */
	internal class DelayedCall
	{
		public var numFrames:int;
		public var command:ICommand;
		
		public function DelayedCall(numFrames:int, command:ICommand)
		{
			this.numFrames = numFrames;
			this.command = command;
		}
	}

}