package ru.nacid.utils.encoders
{
	import com.junkbyte.console.Cc;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import ru.nacid.utils.encoders.data.Amf;
	import ru.nacid.utils.encoders.data.Csv;
	import ru.nacid.utils.encoders.data.Json;
	import ru.nacid.utils.encoders.data.Xml;
	import ru.nacid.utils.encoders.interfaces.IEncoder;

	/**
	 * EncoderReflection.as
	 * Created On: 5.8 20:22
	 *
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/nCore
	 *
	 *
	 *		Copyright 2012 Nikolay nacid Bondarev
	 *
	 *	Licensed under the Apache License, Version 2.0 (the "License");
	 *	you may not use this file except in compliance with the License.
	 *	You may obtain a copy of the License at
	 *
	 *		http://www.apache.org/licenses/LICENSE-2.0
	 *
	 *	Unless required by applicable law or agreed to in writing, software
	 *	distributed under the License is distributed on an "AS IS" BASIS,
	 *	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 *	See the License for the specific language governing permissions and
	 *	limitations under the License.
	 *
	 */
	public class EncoderReflection
	{
		private static const DEFAULT_DATA:Class=Json;

		private static var __cache:Array=[(new Json()), (new Xml()), (new Amf()), (new Csv())];

		public static function data($format:String):IEncoder
		{
			$format=prepString($format);

			try
			{
				var cl:Class=getDefinitionByName('ru.nacid.utils.encoders.data::'.concat($format)) as Class;
				return new cl()
			}
			catch (e:ReferenceError)
			{
				Cc.error(e);
				Cc.warn('encoder for', $format, 'not found! Using default:', DEFAULT_DATA);
			}
			return new DEFAULT_DATA;
		}

		private static function prepString($str:String):String
		{
			return $str ? $str.charAt(0).toUpperCase().concat($str.substr(1).toLowerCase()) : '';
		}

	}

}
