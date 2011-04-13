package garbuz.engine.core 
{
	import garbuz.common.errors.ItemNotFoundError;

	/**
	 * ...
	 * @author canab
	 */
	public class Entity
	{
		public var name:String;
		
		internal var initialized:Boolean = false;
		internal var disposed:Boolean = false;
		
		private var _engine:Engine;
		private var _components:Vector.<Component>;
		
		public function Entity() 
		{
			_components = new Vector.<Component>();
		}
		
		public function initialize():void 
		{
			if (initialized)
				throw new Error("Entity is already initialized");
			
			if (!name)
				name = _engine.nameManager.getUniqueName();

			for each (var component:Component in _components)
			{
				initializeComponent(component);
			}
			
			initialized = true;
		}
		
		public function dispose():void 
		{
			if (!initialized)
				throw new Error("Entity is not initialized");
			
			if (disposed)
				throw new Error("Entity is already disposed");
			
			for each (var component:Component in _components) 
			{
				component.dispose();
			}
			
			disposed = true;
		}
		
		public function addComponent(component:Component, name:String = null):void 
		{
			if (disposed)
				throw new Error("Entity is disposed");

			if (component.name == null)
				component.name = name;

			_components.push(component);

			if (initialized)
				initializeComponent(component);
		}
		
		private function initializeComponent(component:Component):void 
		{
			component.engine = _engine;
			component.parent = this;
			component.initialize();
		}
		
		public function removeComponent(component:Component):void 
		{
			if (disposed)
				throw new Error("Entity is disposed");
				
			component.dispose();
			
			var index:int = _components.indexOf(component);
			if (index == -1)
				throw new ItemNotFoundError();
			else
				_components.splice(index, 1);
		}
		
		public function removeComponentByType(type:Class):void 
		{
			removeComponent(getComponentByType(type));
		}
		
		public function getComponentByType(type:Class):Component
		{
			for each (var item:Component in _components) 
			{
				if (item is type)
					return item;
			}
			return null;
		}
		
		public function getComponentByName(name:String):Component
		{
			for each (var item:Component in _components) 
			{
				if (item.name == name)
					return item;
			}
			return null;
		}
		
		internal function set engine(value:Engine):void 
		{
			_engine = value;
		}
	}

}