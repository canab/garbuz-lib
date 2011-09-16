package garbuz.common.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import garbuz.common.comparing.AnimationRequirement;
	import garbuz.common.comparing.IRequirement;
	import garbuz.common.query.fromDisplay;

	public class DisplayUtil
	{
		static public function transformCoords(point:Point, source:DisplayObject, target:DisplayObject):Point
		{
			return target.globalToLocal(source.localToGlobal(point));
		}
		
		static public function bringToFront(object:DisplayObject):void
		{
			var parent:DisplayObjectContainer = object.parent;
			parent.setChildIndex(object, parent.numChildren - 1);
		}
		
		static public function sendToBack(object:DisplayObject):void
		{
			var parent:DisplayObjectContainer = object.parent;
			parent.setChildIndex(object, 0);
		}
		
		static public function setScale(object:DisplayObject, scale:Number):void
		{
			object.scaleX = object.scaleY = scale;
		}
		
		static public function setPosition(object:DisplayObject, position:Object):void 
		{
			object.x = position.x;
			object.y = position.y
		}
		
		static public function getPosition(object:Object):Point
		{
			return new Point(object.x, object.y);
		}
		
		static public function removeChildren(container:DisplayObjectContainer):void
		{
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
		}
		
		static public function detachFromDisplay(displayObject:DisplayObject):void
		{
			displayObject.parent.removeChild(displayObject);
		}
		
		static public function getChildrenBounds(container:DisplayObjectContainer):Rectangle
		{
			var minX : Number = Number.MAX_VALUE;
			var maxX : Number = Number.MIN_VALUE;
			var minY : Number = Number.MAX_VALUE;
			var maxY : Number = Number.MIN_VALUE;
			
			for (var i:int = 0; i < container.numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				var bounds:Rectangle = child.getBounds(container);
				
				minX = Math.min(minX, bounds.x);
				minY = Math.min(minY, bounds.y);
				maxX = Math.max(maxX, bounds.right);
				maxY = Math.max(maxY, bounds.bottom);
			}
			
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		
		static public function calcBounds(objects:Array, target:DisplayObjectContainer):Rectangle
		{
			var minX : Number = Number.MAX_VALUE;
			var minY : Number = Number.MAX_VALUE;
			var maxX : Number = Number.MIN_VALUE;
			var maxY : Number = Number.MIN_VALUE;
			
			for each (var object:DisplayObject in objects) 
			{
				var bounds:Rectangle = object.getBounds(target);
				
				minX = Math.min(minX, bounds.x);
				minY = Math.min(minY, bounds.y);
				maxX = Math.max(maxX, bounds.right);
				maxY = Math.max(maxY, bounds.bottom);
			}
			
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}

		static public function fitToBounds(object:DisplayObject, bounds:Rectangle):void
		{
			adjustScale(object, bounds.width, bounds.height);
			claimBounds(object, bounds);
		}
		
		static public function adjustScale(object:DisplayObject, maxWidth:Number, maxHeight:Number):void
		{
			var scale:Number = Math.min(maxWidth / object.width, maxHeight / object.height);
			object.height *= scale;
			object.width *= scale;
		}

		public static function claimBounds(object:DisplayObject, bounds:Rectangle):void
		{
			var rect:Rectangle = object.getBounds(object.parent);
			
			if (rect.left < bounds.left)
				object.x += bounds.left - rect.left;
			else if (rect.right > bounds.right)
				object.x += bounds.right - rect.right;

			if (rect.top < bounds.top)
				object.y += bounds.top - rect.top;
			else if (rect.bottom > bounds.bottom)
				object.y += bounds.bottom - rect.bottom;
		}
		
		static public function createRectSprite(width:Number = 100, height:Number = 100,
			color:int = 0x000000, alpha:Number = 1):Sprite
		{
			var sprite:Sprite = new Sprite();
			
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawRect(0, 0, width, height);
			sprite.graphics.endFill();
			
			return sprite;
		}
		
		static public function addBoundsRect(object:Sprite, color:int = 0, alpha:Number = 0):Sprite
		{
			var bounds:Rectangle = object.getBounds(object);
			var rect:Sprite = createRectSprite(bounds.width, bounds.height, color, alpha);
			object.addChild(rect);
			rect.x = bounds.x;
			rect.y = bounds.y;
			
			return rect;
		}


		public static function stopAllClips(content:DisplayObjectContainer):void
		{
			var clips:Array = fromDisplay(content)
				.byRequirement(new AnimationRequirement())
				.findAllRecursive();

			if (content is MovieClip)
				clips.push(content);

			for each (var clip:MovieClip in clips)
			{
				clip.stop();
			}
		}

		public static function playAllClips(content:DisplayObjectContainer):void
		{
			var clips:Array = fromDisplay(content)
				.byRequirement(new AnimationRequirement())
				.findAllRecursive();

			if (content is MovieClip)
				clips.push(content);

			for each (var clip:MovieClip in clips)
			{
				clip.play();
			}
		}

		public static function hasAnimation(content:DisplayObjectContainer):Boolean
		{
			var requirement:IRequirement = new AnimationRequirement();

			return requirement.accept(content)
				? true
				: fromDisplay(content).byRequirement(requirement).existsRecursive();
		}

		public static function getPixel(item:DisplayObject, x:int, y:int):uint
		{
			var bitmapData:BitmapData = new BitmapData(4, 4);
			var matrix:Matrix = new Matrix();
			matrix.translate(-x, -y);

			bitmapData.draw(item, matrix, item.transform.colorTransform, item.blendMode);

			return bitmapData.getPixel(1, 1);
		}

		public static function getPixel32(item:DisplayObject, x:int, y:int):uint
		{
			var bitmapData:BitmapData = new BitmapData(4, 4, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.translate(-x, -y);

			bitmapData.draw(item, matrix, item.transform.colorTransform, item.blendMode);

			return bitmapData.getPixel32(1, 1);
		}

		static public function getRandomPoint(area:DisplayObject):Point
		{
			var bounds:Rectangle = area.getBounds(area);
			var stepCount:int = 100;
			var point:Point;

			while (stepCount-- > 0)
			{
				point = new Point(
					bounds.left + Math.random() * bounds.width,
					bounds.top + Math.random() * bounds.height);

				if (getPixel32(area, point.x, point.y) != 0)
					break;
			}
			
			return point;
		}

		public static function addFrameScripts(clip:MovieClip, handlers:Object):void
		{
			var labels:Array = clip.currentLabels;

			for each (var label:FrameLabel in labels)
			{
				var handler:Function = handlers[label.name];

				if (handler != null)
					clip.addFrameScript(label.frame - 1, handler);
			}
		}
	}

}