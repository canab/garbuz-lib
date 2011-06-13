package garbuz.engine.core
{
	import flash.display.Sprite;

	import garbuz.common.errors.ItemNotFoundError;
	import garbuz.common.events.EventSender;

	public class Engine
	{
		internal var nameManager:NameManager = new NameManager();

		private var _root:Sprite;
		private var _processManager:ProcessManager;
		private var _entities:Vector.<Entity>;
		private var _started:Boolean;

		private var _stateChangedEvent:EventSender = new EventSender(this);

		public function Engine(root:Sprite)
		{
			_root = root;
			_processManager = new ProcessManager(this);
			_entities = new Vector.<Entity>();
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

			if (entity.name == null)
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

		internal function addFrameListener(component:Component, method:Function):void
		{
			var processor:FrameProcessor = new FrameProcessor();
			processor.component = component;
			processor.method = method;

			_processManager.addProcessor(processor);
		}

		/**
		 * Call method after given time
		 * @param	time
		 * time in milliseconds
		 */
		internal function callAfter(time:int, component:Component, method:Function):void
		{
			var processor:DelayedProcessor = new DelayedProcessor();
			processor.component = component;
			processor.method = method;
			processor.frameCount = Math.max(time / 1000.0 * _root.stage.frameRate, 1);

			_processManager.addProcessor(processor);
		}

		/**
		 * Call method periodically
		 * @param	time
		 * time in milliseconds
		 */
		internal function createTimer(time:int, component:Component, method:Function):void
		{
			var processor:TimerProcessor = new TimerProcessor();
			processor.component = component;
			processor.method = method;
			processor.frameCount = Math.max(time / 1000.0 * _root.stage.frameRate, 1);

			_processManager.addProcessor(processor);
		}

		/**
		 * Remove previously added timer, delayedCall or frameListener
		 */
		internal function removeProcessor(component:Component, method:Function):void
		{
			var processor:ProcessorBase = _processManager.findProcessor(component, method);

			if (processor)
				_processManager.removeProcessor(processor);
			else
				throw new ItemNotFoundError();
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

		public function getComponent(fullName:String):Component
		{
			var parts:Array = fullName.split(NameManager.SEPARATOR);
			var entityName:String = parts[0];
			var componentName:String = parts[1];

			var entity:Entity = getEntityByName(entityName);

			return (entity)
				? entity.getComponentByName(componentName)
				: null;
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		public function get frameRate():int
		{
			return root.stage.frameRate;
		}

		public function get root():Sprite
		{
			return _root;
		}

		public function get started():Boolean
		{
			return _started;
		}

		public function set started(value:Boolean):void
		{
			if (_started != value)
			{
				_started = value;

				if (_started)
				{
					if (!_root.stage)
						throw new Error("Root should be on the stage at this moment");

					_processManager.start();
					trace("Engine started");
				}
				else
				{
					_processManager.stop();
					trace("Engine stopped");
				}

				_stateChangedEvent.dispatch();
			}
		}

		public function get stateChangedEvent():EventSender
		{
			return _stateChangedEvent;
		}

		public function get entities():Vector.<Entity>
		{
			return _entities;
		}
	}

}