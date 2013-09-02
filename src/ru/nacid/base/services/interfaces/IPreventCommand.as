package ru.nacid.base.services.interfaces
{
	public interface IPreventCommand extends ICommand
	{
		function prevent($complete:Boolean = true):void;
	}
}