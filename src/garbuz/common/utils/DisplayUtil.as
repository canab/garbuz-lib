package garbuz.common.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import garbuz.common.comparing.AnimationRequirement;
	import garbuz.common.query.fromDisplay;

	/**
	 * ...
	 * @author canab
	 */
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
		
		static public function detachFromDisplay(displyObject:DisplayObject):void
		{
			displyObject.parent.removeChild(displyObject);
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
			var maxX : Number = Number.MIN_VALUE;
			var minY : Number = Number.MAX_VALUE;
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


		public static function stopChildren(content:Sprite, recursive:Boolean = false):void
		{
			var clips:Array = fromDisplay(content)
				.byRequirement(new AnimationRequirement())
				.findAll(recursive);

			if (content is MovieClip)
				clips.push(content);

			for each (var clip:MovieClip in clips)
			{
				clip.stop();
			}
		}

		public static function playChildren(content:Sprite, recursive:Boolean = false):void
		{
			var clips:Array = fromDisplay(content)
				.byRequirement(new AnimationRequirement())
				.findAll(recursive);

			if (content is MovieClip)
				clips.push(content);

			for each (var clip:MovieClip in clips)
			{
				clip.play();
			}
		}
		
	}

}