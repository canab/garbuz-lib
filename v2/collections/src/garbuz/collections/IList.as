package garbuz.collections
{
	public interface IList extends IIterable
	{
		function contains(item:*):Boolean

		function getItemAt(index:int):*;

		function setItemAt(item:*, index:int):void;

		function addItem(item:*):*;

		function addItemAt(item:Object, index:int):*;

		function removeItem(item:Object):int;

		function removeItemAt(index:int):void;

		function pop():*;

		function shift():*;

		function indexOf(item:*):int ;

		function clear():void;

		function clone():IList;

		function get length():int;

		function get first():*;

		function get last():*;

		function toArray():Array;

	}
}
