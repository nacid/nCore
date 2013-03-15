package ru.nacid.utils.binding.types.interfaces
{
	import mx.binding.utils.ChangeWatcher;
	
	import ru.nacid.base.data.interfaces.IData;
	
	public interface IBind extends IData
	{
		function createWatcher($safe:Boolean = true):ChangeWatcher;
	}
}