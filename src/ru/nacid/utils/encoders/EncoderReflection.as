package ru.nacid.utils.encoders 
{
	import com.junkbyte.console.Cc;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import ru.nacid.utils.encoders.data.Json;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class EncoderReflection 
	{
		private static const DEFAULT_DATA:Class = Json;
		
		public static function data($format:String):IEncoder {
			$format = prepString($format);
			
			try{
				var cl:Class = getDefinitionByName('ru.nacid.utils.encoders.data::'.concat($format)) as Class;
				return new cl()
			}catch (e:ReferenceError) {
				Cc.error(e);
				Cc.warn('encoder for', $format, 'not found! Using default:', DEFAULT_DATA);
			}
			return new DEFAULT_DATA;
		}
		
		private static function prepString($str:String):String {
			return $str ? $str.charAt(0).toUpperCase().concat($str.substr(1).toLowerCase()):'';
		}
		
	}

}