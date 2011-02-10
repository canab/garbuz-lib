package
{
	import flash.display.Sprite;

	[SWF(width="640", height="480", frameRate="30")]
	public class MotionTest extends Sprite
	{
		public function MotionTest()
		{
			new TestBasicTween().initialize(this);
		}
	}
}
