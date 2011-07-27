package garbuz.engine.core 
{
	import garbuz.common.errors.AlreadyDisposedError;
	import garbuz.common.errors.AlreadyInitializedError;
	import garbuz.common.errors.NotInitializedError;

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
				throw new AlreadyInitializedError();
			
			if (!name)
				name = engine.nameManager.getUniqueName();

			initialized = true;
			
			onInitialize();
		}
		
		internal function dispose():void 
		{
			if (!initialized)
				throw new NotInitializedError();
			
			if (disposed)
				throw new AlreadyDisposedError();
				
			disposed = true;
				
			onDispose();
		}

		public function get fullName():String
		{
			return (parent)
				? parent.name + NameManager.SEPARATOR + name
				: name;
		}

		public function get isInitialized():Boolean
		{
			return initialized;
		}
		
		protected virtual function onInitialize():void
		{
		}
		
		protected virtual function onDispose():void
		{
		}
		
		/**
		 * Call method on enter frame
		 */
		protected function addFrameListener(method:Function):void
		{
			if (!initialized)
				throw new NotInitializedError();

			engine.addFrameListener(this, method);
		}

		/**
		 * Call method after given time
		 * @param	time
		 * time in milliseconds
		 */
		protected function callAfter(time:int, method:Function):void
		{
			if (!initialized)
				throw new NotInitializedError();

			engine.callAfter(time, this, method);
		}

		/**
		 * Call method periodically
		 * @param	time
		 * time in milliseconds
		 */
		protected function createTimer(time:int, method:Function):void
		{
			if (!initialized)
				throw new NotInitializedError();

			engine.createTimer(time, this, method);
		}

		/**
		 * Remove previously added timer, delayedCall or frameListener
		 */
		protected function removeProcessor(method:Function):void
		{
			engine.removeProcessor(this, method);
		}

		public function remove():void
		{
			parent.removeComponent(this);
		}
	}

}