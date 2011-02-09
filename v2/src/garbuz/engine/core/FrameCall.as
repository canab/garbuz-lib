package garbuz.engine.core
{
	public class FrameCall
	{
		public var target:Component;
		public var method:Function;

		public function FrameCall(target:Component, method:Function)
		{
			this.target = target;
			this.method = method;
		}
	}
}
