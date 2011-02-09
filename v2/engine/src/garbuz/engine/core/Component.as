package garbuz.engine.core 
{
	/**
	 * ...
	 * @author canab
	 */
	public class Component
	{
		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		
		public var engine:Engine;
		public var parent:Entity;
		public var name:String;
		
		public function Component() 
		{
			super();
		}
		
		internal function initialize():void 
		{
			if (initialized)
				throw new Error("Component is already initialized");
			
			initialized = true;
			
			onInitialize();
		}
		
		internal function dispose():void 
		{
			if (!initialized)
				throw new Error("Component is not initialized");
			
			if (disposed)
				throw new Error("Component is already disposed");
				
			disposed = true;
				
			onDispose();
		}

		public function get isInitialized():Boolean
		{
			return initialized;
		}
		
		protected function onInitialize():void 
		{
			// virtual
		}
		
		protected function onDispose():void 
		{
			// virtual
		}
		
		public function onEnterFrame():void 
		{
			// virtual
		}
	}

}