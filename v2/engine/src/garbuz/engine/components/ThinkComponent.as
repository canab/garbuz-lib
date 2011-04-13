package garbuz.engine.components 
{
	import garbuz.common.commands.CallFunctionCommand;
	import garbuz.engine.core.Component;

	public class ThinkComponent extends Component
	{
		private var _command:CallFunctionCommand;
		
		public function ThinkComponent() 
		{
			_command = new CallFunctionCommand(onThink);
		}
		
		override protected function onDispose():void 
		{
			engine.removeDelayedCall(_command);
		}
		
		/**
		 * Call function onThink() after given time
		 * @param	time
		 * time in milliseconds
		 */
		protected function thinkAfter(time:int):void 
		{
			engine.addDelayedCall(time, _command);
		}
		
		protected function onThink():void
		{
			// virtual
		}
		
	}

}