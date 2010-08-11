package garbuz.common.query
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author canab
	 */
	
	public function fromDisplay(source:Sprite):DisplayQuery
	{
		if (source is Sprite)
			return new DisplayQuery(source);
		else
			throw new ArgumentError();
	}
}