package garbuz.engine.components 
{
	import flash.geom.Point;
	import garbuz.common.events.EventSender;
	import garbuz.engine.core.Component;
	
	/**
	 * ...
	 * @author canab
	 */
	public class PathMover extends Component
	{
		public var targetPosition:Position;
		public var targetDirection:Direction8;
		public var speed:Number = 1;
		
		private var _path:Vector.<Point>;
		private var _completeEvent:EventSender = new EventSender(this);
		private var _startEvent:EventSender = new EventSender(this);
		
		private var _counter:int;
		private var _dx:Number;
		private var _dy:Number;
		
		private var _executed:Boolean = false;
		
		public function PathMover() 
		{
			super();
		}
		
		public function execute(path:Vector.<Point>):void 
		{
			if (_executed)
				stop();
			
			_path = path.slice(1);
			_executed = true;
			_counter = 0;
			
			_startEvent.dispatch();
			
			engine.addFrameListener(this);
		}
		
		private function processNextPoint():void
		{
			if (_path.length == 0)
			{
				stop();
				_completeEvent.dispatch();
			}
			else
			{
				var point:Point = _path.shift();
				
				var dx:Number = point.x - targetPosition.x;
				var dy:Number = point.y - targetPosition.y;
				
				var distance:Number = Math.sqrt(dx * dx + dy * dy);
				
				targetDirection.setFromCoords(dx, dy);
				
				_counter = Math.ceil(distance/speed);
				
				_dx = dx/_counter;
				_dy = dy/_counter;
			}
		}
		
		public function stop():void
		{
			if (_executed)
			{
				_executed = false;
				engine.removeFrameListener(this);
			}
		}
		
		override public function onEnterFrame():void 
		{
			if (--_counter <= 0)
				processNextPoint();
			
			if (_executed)
			{
				targetPosition.x += _dx;
				targetPosition.y += _dy;
			}
		}
		
		public function get completeEvent():EventSender { return _completeEvent; }
		
		public function get executed():Boolean { return _executed; }
		
		public function get startEvent():EventSender { return _startEvent; }
	}

}