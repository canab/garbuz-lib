package garbuz.common.query
{
	/**
	 * ...
	 * @author canab
	 */
	
	/**
	 * Query objects from collection
	 * @param	source
	 * object that supports (for each...) iteration
	 * @return
	 */
	public function from(source:Object):Query
	{
		if (source is Object)
			return new Query(source);
		else
			throw new ArgumentError();
	}
}