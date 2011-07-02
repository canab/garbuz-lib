package garbuz.gui.controls
{
	import flash.display.Sprite;

	import garbuz.common.localization.MessageBundle;
	import garbuz.controls.utils.TextUtil;

	public class TipButton extends PushButton
	{
		public function TipButton(content:Sprite, onClick:Function = null, bundle:MessageBundle = null)
		{
			super(content, onClick);
			setBundle(bundle || defaultBundle);
			initText();
		}

		private function initText():void
		{
			tooltip = TextUtil.surroundWithBraces(name);
		}
	}
}