package garbuz.common.query
{
	/**
	 * Query objects from collection
	 * @param	source
	 * object that supports (for each...) iteration
	 * @return
	 */
	public function from(source:Object):Query
	{
		return new Query(source);
	}
}