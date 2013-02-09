package ru.nacid.base.services.skins.interfaces
{
	import ru.nacid.base.services.interfaces.ICommand;

	public interface ISkinLoader extends ICommand
	{
		function getInstance():*;
		function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader;
		function get embed():Boolean;
	}
}
