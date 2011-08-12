package garbuz.engine.scene
{
	import flash.display.Sprite;

	import garbuz.engine.core.Component;
	import garbuz.engine.core.Entity;

	public class VectorScene extends Entity
	{
		private var _root:Sprite;

		public function VectorScene(root:Sprite)
		{
			_root = root;
			_root.mouseEnabled = false;
		}

		override public function addComponent(component:Component, name:String = null):void
		{
			if (component is VectorLayer)
				_root.addChild(VectorLayer(component).content);

			super.addComponent(component, name);
		}

		override public function removeComponent(component:Component):void
		{
			if (component is VectorLayer)
				_root.removeChild(VectorLayer(component).content);

			super.removeComponent(component);
		}
	}
}
