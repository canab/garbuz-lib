package garbuz.common.query
{
	import flash.display.SimpleButton;

	/**
	 * ...
	 * @author canab
	 */
	
	public function fromButton(source:SimpleButton):ButtonQuery
	{
		return new ButtonQuery(source);
	}
}