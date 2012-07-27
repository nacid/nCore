package ru.nacid.utils.encoders.interfaces 
{
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public interface IEncoder 
	{
		function encodeObject($data:Object):Object;
		function encodeString($data:String):Object;
		function encodeFloat($data:Number):Object;
		
		function decodeObject($data:Object):Object;
		function decodeString($data:Object):String;
		function decodeFloat($data:Object):Number;
	}
	
}