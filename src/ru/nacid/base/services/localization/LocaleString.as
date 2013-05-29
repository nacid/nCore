package ru.nacid.base.services.localization
{
	import com.junkbyte.console.Cc;
	
	import ru.nacid.base.data.ValueObject;
	import ru.nacid.utils.StringUtils;

	/**
	 * LocaleString.as
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
	public class LocaleString extends ValueObject
	{
		protected var settings:LocaleMapSetting;
		protected var vars:Vector.<String>;
		protected var string:String;

		public function LocaleString($settings:LocaleMapSetting, $id:String=null, $data:Object=null)
		{
			settings=$settings;
			vars=Vector.<String>([]);
			string='';

			super($id, $data);
		}

		override protected function init():void
		{
			addParser(settings.keyField,parseKey);
			addParser(settings.valueField, parseValue);
		}
		
		protected function parseKey($input:String):void{
			if(symbol == null){
				symbol = $input;
			}
		}

		protected function parseValue($input:String):void
		{
			var f:int=$input.search(settings.varBegin);
			if (f > 0)
			{
				if ($input.charAt(f - 1) == settings.screen)
				{
					string=string.concat($input.substr(0, f + 1).replace(settings.screenEndBegin, settings.varBegin));
					return parseValue($input.substr(f + 1));
				}

				string=string.concat($input.substr(0, f));
				return parseValue($input.substr(f));
			}
			else if (f == 0)
			{
				var endI:int=$input.indexOf(settings.varEnd, 1);
				if (endI > 0)
				{
					string=string.concat('{', vars.length, '}');
					vars.push($input.substr(1, endI - 1));
					return parseValue($input.substr(endI + 1));
				}
				else
				{
					Cc.errorch(VO_CHANNEL, 'incorrect locale:', symbol);
				}
			}
			string=string.concat($input);
		}

		public function getString($data:Object=null):String
		{
			if ($data)
			{
				var params:Array=[];

				for (var i:int=0; i < vars.length; i++)
				{
					params[i]=$data.hasOwnProperty(vars[i]) ? $data[vars[i]] : settings.undefinedValue;
				}

				return StringUtils.replace(string, params);
			}
			return string;
		}

		public function dump():Object
		{
			var r:String=StringUtils.replaceAll(string, settings.varBegin, settings.screenEndBegin);
			var params:Array=[];
			var response:Object={};

			for (var i:int=0; i < vars.length; i++)
			{
				params[i]=settings.varBegin.concat(vars[i], settings.varEnd);
			}
			
			response[settings.valueField]=StringUtils.replace(r, params);
			response[settings.keyField]=symbol;

			return response;
		}

	}

}
