package ru.nacid.base.services.logs.interfaces
{
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public interface IChannelParent
	{
		function log($string:String):void;
		function warning($string:String):void;
		function info($string:String):void;
		function error($string:String):void;
		function critical($string:String):void;
	}

}