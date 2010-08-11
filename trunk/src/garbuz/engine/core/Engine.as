package garbuz.engine.core 
{
	import flash.display.Sprite;
	import garbuz.common.commands.CallFunctionCommand;
	import garbuz.common.commands.ICommand;
	import garbuz.common.errors.ItemNotFoundError;
	import garbuz.common.events.EventSender;
	/**
	 * ...
	 * @author canab
	 */
	public class Engine
	{
		private var _root:Sprite;
		private var _processManager:ProcessManager;
		private var _entities:Vector.<Entity>;
		private var _started:Boolean;
		
		private var _stateChangedEvent:EventSender = new EventSender(this);
		
		public function Engine(root:Sprite)
		{
			if (!root.stage)
				throw new Error("Root should be on the stage at this moment");
			
			_root = root;
			_processManager = new ProcessManager(this);
			_entities = new Vector.<Entity>();
			
			trace("Engine created");
		}
		
		public function dispose():void 
		{
			stop();
			
			for each (var entity:Entity in _entities) 
			{
				entity.dispose();
			}
			
			_processManager.dispose();
			
			trace("Engine disposed");
		}
		
		public function addEntity(entity:Entity, name:String = null):void
		{
			_entities.push(entity);
			entity.name = name;
			entity.engine = this;
			entity.initialize();
		}
		
		public function removeEntity(entity:Entity):void 
		{
			entity.dispose();
			
			var index:int = _entities.indexOf(entity);
			if (index == -1)
				throw new ItemNotFoundError();
			else
				_entities.splice(index, 1);
		}
		
		public function start():void 
		{
			started = true;
		}
		
		public function stop():void 
		{
			started = false;
		}
		
		public function addFrameListener(component:Component):void 
		{
			_processManager.addFrameListener(component);
		}
		
		public function removeFrameListener(component:Component):void 
		{
			_processManager.removeFrameListener(component);
		}
		
		/**
		 * Execute command after given time
		 * @param	time
		 * time in milliseconds
		 * @param	command
		 */
		
		 public function addDelayedCall(time:int, command:ICommand):void
		{
			_processManager.addDelayedCall(time, command);
		}
		/**
		 * Call function after given time
		 * @param	time
		 * time in milliseconds
		 * @param	command
		 */
		public function callAfter(time:int, func:Function, args:Array = null):void
		{
			_processManager.addDelayedCall(time, new CallFunctionCommand(func, args));
		}
		
		public function removeDelayedCall(command:ICommand):void
		{
			_processManager.removeDelayedCall(command);
		}
		
		public function getEntitiesByType(type:Class):Array
		{
			var result:Array = [];
			for each (var item:Entity in _entities) 
			{
				if (item is type)
					result.push(item);
			}
			return result;
		}
		
		public function getEntityByType(type:Class):Entity
		{
			for each (var item:Entity in _entities) 
			{
				if (item is type)
					return item;
			}
			return null;
		}
		
		public function getEntityByName(name:String):Entity
		{
			for each (var item:Entity in _entities) 
			{
				if (item.name == name)
					return item;
			}
			return null;
		}
		
		public function get frameRate():int
		{
			return root.stage.frameRate;
		}
		
		public function get root():Sprite { return _root; }
		
		public function get started():Boolean { return _started; }
		public function set started(value:Boolean):void 
		{
			if (_started != value)
			{
				_started = value;
				
				if (_started)
				{
					_processManager.start();
					trace("Engine started");
				}
				else
				{
					_processManager.stop();
					trace("Engine stopped");
				}
					
				_root.mouseEnabled = _started;
				_root.mouseChildren = _started;
					
				_stateChangedEvent.dispatch();
			}
		}
		
		public function get stateChangedEvent():EventSender { return _stateChangedEvent; }
		
		public function get entities():Vector.<Entity> { return _entities; }
	}

}