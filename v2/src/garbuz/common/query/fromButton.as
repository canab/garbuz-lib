package garbuz.common.query
{
	import flash.display.SimpleButton;
	/**
	 * ...
	 * @author canab
	 */
	
	public function fromButton(source:SimpleButton):ButtonQuery
	{
		if (source is SimpleButton)
			return new ButtonQuery(source);
		else
			throw new ArgumentError();
	}
}