package garbuz.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import garbuz.common.display.StageReference;
	import garbuz.common.localization.MessageBundle;
	import garbuz.common.utils.AlignUtil;
	import garbuz.common.utils.DisplayUtil;
	import garbuz.controls.managers.ToolTipManager;

	public class ControlBase extends Sprite
	{
		public static var defaultBundle:MessageBundle;
		public static var loaderViewClass:Class;

		protected var _width:Number = -1;
		protected var _height:Number = -1;
		protected var _data:Object;

		private var _bundle:MessageBundle;
		private var _enabled:Boolean = true;
		private var _disabledAlpha:Number = 0.5;
		private var _invalidated:Boolean = false;

		private var _tooltip:String;
		private var _loadingClip:Sprite;

		private var _x:Number = 0;
		private var _y:Number = 0;

		public function ControlBase()
		{
			mouseEnabled = false;
			mouseChildren = false;
		}

		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}

		public function wrapContent(target:DisplayObjectContainer):void
		{
			if (target.numChildren == 0)
				throw new Error("Target is already wrapped");

			name = target.name;

			while (target.numChildren > 0)
			{
				addChild(target.getChildAt(0));
			}

			replaceTarget(target);
		}

		public function wrapTarget(target:DisplayObject):void
		{
			name = target.name;
			replaceTarget(target);
			addChild(target);
			target.x = 0;
			target.y = 0;
		}

		protected function replaceTarget(target:DisplayObject):void
		{
			x = target.x;
			y = target.y;

			var container:DisplayObjectContainer = target.parent;

			if (container)
			{
				container.addChildAt(this, container.getChildIndex(target));
				container.removeChild(target);
			}
		}

		protected function applyEnabled():void
		{
			alpha = _enabled ? 1.0 : _disabledAlpha;
		}

		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}

		public function setPlacement(source:Sprite):void
		{
			move(source.x, source.y);
			setSize(source.width, source.height);
		}

		public function applyLayout():void
		{
			if (_loadingClip)
				applyLoadingClipLayout();
		}

		private function applyLoadingClipLayout():void
		{
			AlignUtil.alignCenter(_loadingClip, new Rectangle(0, 0, width, height));
		}

		public function showLoading():void
		{
			_loadingClip = new loaderViewClass();
			addChild(_loadingClip);
			applyLoadingClipLayout();
		}

		public function hideLoading():void
		{
			DisplayUtil.stopAllClips(_loadingClip);
			DisplayUtil.detachFromDisplay(_loadingClip);
		}

		protected function getSprite(name:String):Sprite
		{
			return Sprite(getChildByName(name));
		}

		protected function getField(name:String):TextField
		{
			return TextField(getChildByName(name));
		}

		protected virtual function applyData():void {}

		protected virtual function applyLocalization():void {}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// localization
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		protected function setBundle(value:MessageBundle):void
		{
			if (_bundle)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

				if (stage)
					onRemovedFromStage(null);
			}

			_bundle = value;

			if (_bundle)
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

				if (stage)
					onAddedToStage(null);
			}
		}

		private function onAddedToStage(e:Event):void
		{
			_bundle.changeEvent.addListener(applyLocalization);
		}

		private function onRemovedFromStage(e:Event):void
		{
			_bundle.changeEvent.removeListener(applyLocalization);
		}

		/*///////////////////////////////////////////////////////////////////////////////////
		//
		// get/set
		//
		///////////////////////////////////////////////////////////////////////////////////*/

		override public function get width():Number
		{
			return (_width == -1) ? super.width : _width;
		}

		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				invalidate();
			}
		}

		override public function get height():Number
		{
			return (_height == -1) ? super.height : _height;
		}

		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				invalidate();
			}
		}

		override public function get x():Number
		{
			return _x;
		}

		override public function set x(value:Number):void
		{
			_x = value;
			super.x = int(value);
		}

		override public function get y():Number
		{
			return _y;
		}

		override public function set y(value:Number):void
		{
			_y = value;
			super.y = int(value);
		}

		public function get bundle():MessageBundle
		{
			return _bundle;
		}

		public function set bundle(value:MessageBundle):void
		{
			setBundle(value);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if (_data != value)
			{
				_data = value;
				applyData();
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (_enabled != value)
			{
				_enabled = value;
				applyEnabled();
			}
		}

		public function get disabledAlpha():Number
		{
			return _disabledAlpha;
		}

		public function set disabledAlpha(value:Number):void
		{
			_disabledAlpha = value;
			applyEnabled();
		}

		public function get tooltip():String
		{
			return _tooltip;
		}

		public function set tooltip(value:String):void
		{
			if (_tooltip != value)
			{
				_tooltip = value;

				if (_tooltip)
					ToolTipManager.instance.registerObject(this, _tooltip, bundle);
				else
					ToolTipManager.instance.unregisterObject(this);
			}
		}

		protected function disableMouseFor(...args):void
		{
			for each (var item:DisplayObject in args)
			{
				if (item is InteractiveObject)
					InteractiveObject(item).mouseEnabled = false;

				if (item is DisplayObjectContainer)
					DisplayObjectContainer(item).mouseChildren = false;
			}
		}

		public function invalidate():void
		{
			if (!_invalidated)
			{
				_invalidated = true;
				StageReference.stage.addEventListener(Event.RENDER, onStageRender, false, 0, true);
				StageReference.stage.invalidate();
			}
		}

		private function onStageRender(e:Event):void
		{
			validate();
		}

		public function validate():void
		{
			if (_invalidated)
			{
				_invalidated = false;
				StageReference.stage.removeEventListener(Event.RENDER, onStageRender, false);
				applyLayout();
			}
		}
	}
}