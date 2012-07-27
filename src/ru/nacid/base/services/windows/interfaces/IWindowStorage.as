package ru.nacid.base.services.windows.interfaces 
{
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.windows.policy.WindowPolicy;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public interface IWindowStorage extends IData
	{
		function get policy():WindowPolicy;
		function get render():Class;
		function get cached():Boolean;
		function get modal():Boolean;
	}
	
}