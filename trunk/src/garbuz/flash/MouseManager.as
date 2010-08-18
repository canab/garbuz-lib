package garbuz.flash 
{
	import flash.display.DisplayObject;
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
		private var _pointer:Sprite; 
		private var _targets:Dictionary = new Dictionary(true);
		
		public function MouseManager(param:PrivateConstructor) 
		{
			super();
		}
		
		static public function get instance():MouseManager
		{
			if (!_instance)
				_instance = new MouseManager(new PrivateConstructor)
			
			return _instance;
		}
		
		public function initialize(root:Sprite):void 
		{
			_root = root;
		}
		
		public function setPointer(pointer:Sprite, hideMouse:Boolean = true):void
		{
			resetPointer();
			
			_pointer = pointer;
			_pointer.mouseEnabled = false;
			_pointer.mouseChildren = false;
			
			_root.addChild(_pointer);
			_root.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if (hideMouse)
				Mouse.hide();
			
			updatePointer();
		}
		
		public function setPointerClass(iconClass:Class, hideMouse:Boolean = true):void
		{
			setPointer(new iconClass(), hideMouse);
		}
		
		public function registerObject(target:DisplayObject, pointerClass:Class, hideMouse:Boolean = true):void
		{
			var info:PointerInfo = new PointerInfo(pointerClass, hideMouse);
			
			target.addEventListener(MouseEvent.MOUSE_OVER, onSpriteOver);
			target.addEventListener(MouseEvent.MOUSE_OUT, onSpriteOut);
			
			if (target.hitTestPoint(_root.stage.mouseX, _root.stage.mouseY, true))
				setPointerClass(info.pointerClass, info.hideMouse);
			
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
			setPointerClass(info.pointerClass, info.hideMouse);
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
	public var pointerClass:Class;
	public var hideMouse:Boolean;
	
	public function PointerInfo(pointerClass:Class, hideMouse:Boolean)
	{
		this.pointerClass = pointerClass;
		this.hideMouse = hideMouse;
	}
}