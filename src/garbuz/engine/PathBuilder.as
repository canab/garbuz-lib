package garbuz.engine
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import garbuz.common.utils.MathUtil;
	
	
	public class PathBuilder
	{
		public var debugMode:Boolean = false;
		
		private var _path:Vector.<Point>;
		
		private var _ground:Sprite;
		private var _points:Array;
		private var _n:int;
		private var _m:int;
		private var _hGridSize:int;
		private var _vGridSize:int;
		private var _currentStep:int;
		
		private var _startPoint:PathPoint;
		private var _finishPoint:PathPoint;
		private var _outerPoints:Array;
		private var _usedList:Array;
		private var _success:Boolean;
		
		private var _numDirs:int;
		
		// moving directions
		private var _dirI:Array = [ 0, 1, 1,  1,  0, -1, -1, -1];
		private var _dirJ:Array = [ 1, 1, 0, -1, -1, -1,  0,  1];
		
		public function PathBuilder(ground:Sprite, hGridSize:int = 10, vGridSize:int = 10)
		{
			_ground = ground;
			_hGridSize = hGridSize;
			_vGridSize = vGridSize;
			_numDirs = _dirI.length;
			
			createPoints();
			linkPoints();
		}
		
		/**
		 * create points 2-dimension array of poinds
		 **/
		private function createPoints():void
		{
			// array size
			var groundRect:Rectangle = _ground.getBounds(_ground);
			var bitmapData:BitmapData = new BitmapData(groundRect.right, groundRect.bottom, true, 0x000000);
			bitmapData.draw(_ground);
			_n = groundRect.bottom / _vGridSize;
			_m = groundRect.right / _hGridSize;
			
			//var bmp:Bitmap = new Bitmap(bitmapData);
			//_ground.addChild(bmp);
			
			_points = new Array(_n);
			
			// create points grid
			for (var i:int = 0; i < _n; i++)
			{
				_points[i] = new Array(_m);
				
				for (var j:int = 0; j < _m; j++)
				{
					var point:PathPoint = new PathPoint();
					point.i = i;
					point.j = j;
					point.x = (j + 0.5) * _hGridSize; 
					point.y = (i + 0.5) * _vGridSize;
					point.stepNum = -1;
					
					//var globalPoint:Point = _ground.localToGlobal(new Point(point.x, point.y));
					point.enabled = bitmapData.getPixel32(point.x, point.y) != 0x00000000;//_ground.hitTestPoint(globalPoint.x, globalPoint.y, true);
					_points[i][j] = point;
					
					if (debugMode && point.enabled)
						_debug_draw_path_point(point);
				}
			}
		}

		/**
		 * link each point with nearest point
		 **/
		private function linkPoints():void
		{
			var linkI:int;
			var linkJ:int;
			var point:PathPoint;
			
			for (var i:int = 0; i < _n; i++)
			{
				for (var j:int = 0; j < _m; j++)
				{
					point = _points[i][j];
					
					for (var d:int = 0; d < _numDirs; d++)
					{
						linkI = i + _dirI[d];
						linkJ = j + _dirJ[d];
						
						point.links[d] = (linkI >=0 && linkI < _n && linkJ >= 0 && linkJ < _m)
							? _points[linkI][linkJ]
							: null;
					}
				}
			}
		}
		
		/**
		 * returns array of points or null
		 **/
		public function getPath(startPoint:Point, finishPoint:Point):Vector.<Point>
		{
			_path = new Vector.<Point>();
			_startPoint = getPathPoint(startPoint);
			_finishPoint = getPathPoint(finishPoint);
			
			if (debugMode)
				_debug_clear();
			
			if (!_startPoint || !_finishPoint)
				return null;
				
			if (_startPoint == _finishPoint)
				return _path;
				
			if (doSimpleSearch())
			{
				if (debugMode)
					trace('PethBuilder: simple');
			}
			else if (doDefaultSearch())
			{
				if (debugMode)
					trace('PethBuilder: simple');
			}

			if (debugMode)
				_debug_drawPath();
			
			return _path;
		}
		
		/**
		 * returns grid point by coordinates
		 **/
		private function getPathPoint(point:Point):PathPoint
		{
			var i:int = MathUtil.claimRange(point.y / _vGridSize, 0, _n - 1);
			var j:int = MathUtil.claimRange(point.x / _hGridSize, 0, _m - 1);
			
			var pathPoint:PathPoint = _points[i][j];
			var d:int = 0;
			
			//-- if point is outside ground area, look for neighbours
			while (!pathPoint.enabled && d < _numDirs)
			{
				var nearPoint:PathPoint = pathPoint.links[d];
				if (nearPoint)
					pathPoint = nearPoint;
				d++;
			}
			
			return (pathPoint.enabled) ? pathPoint : null;
		}
		
		/**
		 * try find path consist of 3 points
		 **/
		private function doSimpleSearch():Boolean
		{
			var i0:int = _startPoint.i;
			var j0:int = _startPoint.j;
			var i1:int;
			var j1:int;
			var i2:int = _finishPoint.i;
			var j2:int = _finishPoint.j;
			
			var di:int = i2 - i0;
			var dj:int = j2 - j0;
			
			var absdi:int = Math.abs(di);
			var absdj:int = Math.abs(dj);
			
			//-- indexes for middle point
			
			//-- horizontal direction
			if (absdj > absdi)
			{
				i1 = i0;
				//-- to left
				if (dj > 0) 
					j1 = j2 - absdi;
				//-- to right
				else
					j1 = j2 + absdi;
			}
			//-- vertical
			else
			{
				j1 = j0;
				
				//-- down
				if (di > 0)
					i1 = i2 - absdj;
				//-- up
				else
					i1 = i2 + absdj;
			}
			
			var middlePoint:PathPoint = _points[i1][j1];
			
			if (!checkLine(_startPoint, middlePoint))
				return false;
			
			if (!checkLine(_finishPoint, middlePoint))
				return false;
				
			_path = new Vector.<Point>();
			_path.push(_startPoint.toPoint());
			
			if (middlePoint != _startPoint && middlePoint != _finishPoint)
				_path.push(middlePoint.toPoint());
			_path.push(_finishPoint.toPoint());
			
			return true;
		}
		
		private function checkLine(p1:PathPoint, p2:PathPoint):Boolean
		{
			var si:int = MathUtil.sign(p2.i - p1.i);
			var sj:int = MathUtil.sign(p2.j - p1.j);
			
			var direction:int;
			
			for (var d:int = 0; d < _numDirs; d++)
			{
				if (_dirI[d] == si && _dirJ[d] == sj)
				{
					direction = d;
					break;
				}
			}
			
			//-- check points
			var p:PathPoint = p1;
			while (p != p2)
			{
				p = p.links[direction];
				
				if (debugMode)
					_debug_draw_path_point(p);
				if (!p.enabled)
					return false;
			}
			
			return true;
		}
		
		private function doDefaultSearch():Boolean
		{
			_currentStep = 0;
			_startPoint.stepNum = 0;
			_outerPoints = [_startPoint];
			_usedList = [];
			_success = false;
			
			do
			{
				_currentStep++;
				doIteration();
			}
			while (!_success && _outerPoints.length > 0);
			
			if (_success)
				buildPath();
			
			resetUsedPoints();
			
			return _success;
		}
		
		private function buildPath():void
		{
			var point:PathPoint = _finishPoint; 
			var tpath:Array = [_finishPoint];
			_finishPoint.direction = -1;
			
			//-- build array of path points from _finishPoint to _startPoint
			while (point != _startPoint)
			{
				var minDistance:int;
				var nextPoint:PathPoint = null;
				
				//-- from available points find nearest one
				for (var d:int = 0; d < _numDirs; d++)
				{
					var p:PathPoint = point.links[d];
					
					if (!p || p.stepNum != point.stepNum - 1)
						continue;
						
					var d2:int = distance2(p, point);
					if (!nextPoint || d2 < minDistance)
					{
						minDistance = d2;
						nextPoint = p;
						nextPoint.direction = d;
					}
				}
				
				tpath.push(nextPoint);
				point = nextPoint;
			}
			
			//-- reverse array and remove points with same direction
			_path = new Vector.<Point>();
			_path.push(_startPoint.toPoint());
				
			for (var i:int = tpath.length - 2; i >= 0; i--)
			{
				if (tpath[i].direction != tpath[i+1].direction)
					_path.push(tpath[i].toPoint());
			}
		}
		
		private function distance2(p1:PathPoint, p2:PathPoint):int
		{
			var dx:int = p2.x - p1.x;
			var dy:int = p2.y - p1.y;
			
			return dx*dx + dy*dy;
		}
		
		private function resetUsedPoints():void
		{
			_startPoint.stepNum = -1;
			_finishPoint.stepNum = -1;
			
			for each (var list:Array in _usedList)
			{
				for each (var point:PathPoint in list)
				{
					point.stepNum = -1;
				}
			}
		}
		
		private function doIteration():void
		{
			//-- points for next iteration
			var nextOuters:Array = [];
			
			mainLoop:
			for each (var point:PathPoint in _outerPoints)
			{
				for each (var linkPoint:PathPoint in point.links)
				{
					if (!linkPoint || !linkPoint.enabled || linkPoint.stepNum >= 0)
						continue;
						
					if (linkPoint == _finishPoint)
						_success = true;
					
					linkPoint.stepNum = _currentStep;
					nextOuters.push(linkPoint);
				}
			}
			
			//-- save points required to reset/initialize for next path searching
			_usedList.push(nextOuters);
			
			if (!_success)
				_outerPoints = nextOuters;
		}
		
		private function _debug_drawPath():void
		{
			if (!_path || _path.length == 0)
				return;
			
			_debug_draw_point(_path[0], 0x0000FF);
			
			for (var i:int = 0; i < _path.length - 1; i++)
			{
				_ground.graphics.lineStyle(0.5, 0x0000FF);
				_ground.graphics.moveTo(_path[i].x, _path[i].y);
				_ground.graphics.lineTo(_path[i + 1].x, _path[i + 1].y);
				_debug_draw_point(_path[i + 1], 0x0000FF);
			}
		}
		
		private function _debug_draw_path_point(point:PathPoint):void
		{
			var color:int;
			if (point.enabled)
				color = 0x0000FF;
			else
				color = 0xAAAAAA;
				
			_debug_draw_point(point.toPoint(), color);
		}
		
		private function _debug_draw_point(coords:Point, color:int):void 
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(0, color);
			shape.graphics.drawCircle(0, 0, 4);
			shape.x = coords.x;
			shape.y = coords.y;
			_ground.addChild(shape);
		}
		
		private function _debug_clear():void
		{
			_ground.graphics.clear();
		}
		
	}
}
	
	import flash.geom.Point;
	

internal class PathPoint
{
	public var enabled:Boolean; // point on the ground
	public var stepNum:int;		// iteration step
	public var direction:int;
	public var i:int;
	public var j:int;
	public var x:int;
	public var y:int;
	public var links:Array = []; // nearest points
	
	public function toPoint():Point
	{
		return new Point(x, y);
	}
	
	
}