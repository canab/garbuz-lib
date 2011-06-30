package garbuz.engine.core
{
	import flash.display.Sprite;

	import garbuz.common.errors.ItemAlreadyExistsError;
	import garbuz.common.errors.ItemNotFoundError;
	import garbuz.common.events.EventSender;
	import garbuz.common.logging.Logger;
	import garbuz.motion.TweenManager;
	import garbuz.motion.Tweener;

	public class Engine
	{
		internal var nameManager:NameManager = new NameManager();

		private var _logger:Logger = new Logger(this);

		private var _startEvent:EventSender = new EventSender(this);
		private var _stopEvent:EventSender = new EventSender(this);

		private var _root:Sprite;
		private var _processManager:ProcessManager;
		private var _tweenManager:TweenManager;
		private var _entities:Object = {};
		private var _started:Boolean;
		private var _initialized:Boolean = false;

		public function Engine(root:Sprite)
		{
			_root = root;
			_processManager = new ProcessManager(this);
			_tweenManager = new TweenManager();
		}

		public function dispose():void
		{
			stop();

			for each (var entity:Entity in _entities)
			{
				entity.dispose();
			}

			_logger.debug("disposed");
		}

		public function addEntity(entity:Entity):void
		{
			if (entityExists(entity.name))
				throw new ItemAlreadyExistsError();

			if (!entity.name)
				entity.name = nameManager.getUniqueName();

			_entities[entity.name] = entity;

			entity.engine = this;

			if (_initialized)
				entity.initialize();
		}

		public function removeEntity(entity:Entity):void
		{
			if (!entityExists(entity.name))
				throw new ItemNotFoundError();

			if (_initialized)
				entity.dispose();

			delete _entities[entity.name];
		}

		public function start():void
		{
			if (_started)
				return;

			if (!_initialized)
				initialize();

			_started = true;
			_processManager.start();
			_tweenManager.resumeAll();
			_logger.debug("started");
			_startEvent.dispatch();
		}

		public function stop():void
		{
			if (!_started)
				return;

			_started = false;
			_processManager.stop();
			_tweenManager.pauseAll();
			_logger.debug("stopped");
			_stopEvent.dispatch();
		}

		private function initialize():void
		{
			if (!_root.stage)
				throw new Error("Root should be on the stage at this moment");

			for each (var entity:Entity in _entities)
			{
				entity.initialize();
			}

			_initialized = true;
		}

		public function tween(target:Object, duration:Number = -1):Tweener
		{
			return _tweenManager.tween(target, duration);
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

		private function entityExists(name:String):Boolean
		{
			return name && (name in _entities);
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
			if (value)
				start();
			else
				stop();
		}

		public function get startEvent():EventSender
		{
			return _startEvent;
		}

		public function get stopEvent():EventSender
		{
			return _stopEvent;
		}

		public function get tweenManager():TweenManager
		{
			return _tweenManager;
		}
	}

}