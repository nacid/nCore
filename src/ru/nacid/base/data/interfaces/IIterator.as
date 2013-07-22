package ru.nacid.base.data.interfaces
{
	public interface IIterator
	{
		function reset():void;
		function hasNext():Boolean;
		function get step():int;
	}
}