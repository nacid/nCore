package ru.nacid.base.services.skins.interfaces
{
	import ru.nacid.base.services.interfaces.ICommand;
	import ru.nacid.utils.interfaces.ILoader;

	public interface ISkinLoader extends ICommand,ILoader
	{
		function getInstance():*;
		function getEmpty():*;
		function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader;
		function get embed():Boolean;
	}
}
