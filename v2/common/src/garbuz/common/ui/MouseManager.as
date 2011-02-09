package garbuz.common.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import garbuz.common.utils.DisplayUtil;
	/**
	 * ...
	 * @author canab
	 */
	public class MouseManager
	{
		static private var _instance:MouseManager;
		
		private var _root:Sprite;
		private var _pointer:DisplayObject; 
		private var _targets:Dictionary = new Dictionary(true);
		
		public function MouseManager(param:PrivateConstructor) 
		{
			super();
		}
		
		static public function get instance():MouseManager
		{
			if (!_instance)
				_instance = new MouseManager(new PrivateConstructor);
			
			return _instance;
		}
		
		public function initialize(root:Sprite):void 
		{
			_root = root;
		}
		
		/**
		 * 
		 * @param	pointer
		 * DisplayObject or Class
		 * @param	hideMouse
		 */
		public function setPointer(pointer:Object, hideMouse:Boolean = true):void
		{
			resetPointer();
			
			if (pointer is DisplayObject)
				_pointer = DisplayObject(pointer);
			else if (_pointer is Class)
				_pointer = new (pointer as Class)();
			else
				throw new ArgumentError("Pointer should be Sprite or Class");
				
			if (_pointer is InteractiveObject)
				InteractiveObject(_pointer).mouseEnabled = false;
			
			if (_pointer is DisplayObjectContainer)
				DisplayObjectContainer(_pointer).mouseChildren = false;
			
			_root.addChild(_pointer);
			_root.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if (hideMouse)
				Mouse.hide();
			
			updatePointer();
		}
		
		public function registerObject(target:DisplayObject, pointer:Object, hideMouse:Boolean = true):void
		{
			var info:PointerInfo = new PointerInfo(pointer, hideMouse);
			
			target.addEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
			target.addEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
			
			if (target.hitTestPoint(_root.stage.mouseX, _root.stage.mouseY, true))
				setPointer(info.pointer, info.hideMouse);
			
			_targets[target] = info;
		}
		
		public function unRegisterObject(target:DisplayObject):void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
			target.removeEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
			
			delete _targets[target];
		}
		
		private function onSpriteOver(e:MouseEvent):void
		{
			var info:PointerInfo = _targets[e.currentTarget];
			setPointer(info.pointer, info.hideMouse);
		}
		
		private function onSpriteOut(e:MouseEvent):void
		{
			resetPointer();
		}
		
		public function resetPointer():void
		{
			if (_pointer)
			{
				DisplayUtil.detachFromDisplay(_pointer);
				_root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_pointer = null;
			}
			
			Mouse.show();
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			updatePointer();
			e.updateAfterEvent();
		}
		
		private function updatePointer():void
		{
			_pointer.x = _root.mouseX;
			_pointer.y = _root.mouseY;
		}
		
		public function get initialized():Boolean
		{
			return Boolean(_root);
		}
	}
}

internal class PrivateConstructor { }

internal class PointerInfo
{
	public var pointer:Object;
	public var hideMouse:Boolean;
	
	public function PointerInfo(pointer:Object, hideMouse:Boolean)
	{
		this.pointer = pointer;
		this.hideMouse = hideMouse;
	}
}