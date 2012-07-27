package ru.nacid.utils.encoders.interfaces 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public interface IByteEncoder extends IEncoder
	{
		function encodeBytes($data:ByteArray):ByteArray;
		function decodeBytes($data:ByteArray):ByteArray;
	}
	
}