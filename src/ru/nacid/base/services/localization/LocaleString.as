package ru.nacid.base.services.localization
{
	import com.junkbyte.console.Cc;
	import mx.utils.StringUtil;
	import ru.nacid.base.data.ValueObject;
	import ru.nacid.utils.StringUtils;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class LocaleString extends ValueObject
	{
		protected var settings:LocaleMapSetting;
		protected var vars:Vector.<String>;
		protected var string:String;
		
		public function LocaleString($settings:LocaleMapSetting, $id:String = null, $data:Object = null)
		{
			settings = $settings;
			vars = Vector.<String>([]);
			string = '';
			
			super($id, $data);
		}
		
		override protected function init():void
		{
			addParser(settings.valueField, parseValue);
		}
		
		protected function parseValue($input:String):void
		{
			var f:int = $input.search(settings.varBegin);
			if (f > 0)
			{
				if ($input.charAt(f - 1) == settings.screen)
				{
					string = string.concat($input.substr(0, f + 1).replace(settings.screenEndBegin, settings.varBegin));
					return parseValue($input.substr(f + 1));
				}
				
				string = string.concat($input.substr(0, f));
				return parseValue($input.substr(f));
			}
			else if (f == 0)
			{
				var endI:int = $input.indexOf(settings.varEnd, 1);
				if (endI > 0)
				{
					string = string.concat('{', vars.length, '}');
					vars.push($input.substr(1, endI - 1));
					return parseValue($input.substr(endI + 1));
				}
				else
				{
					Cc.errorch(VO_CHANNEL, 'incorrect locale:', id);
				}
			}
			string = string.concat($input);
		}
		
		public function getString($data:Object = null):String {
			if ($data) {
				var params:Array = [];
				
				for (var i :int = 0; i < vars.length; i++) {
					params[i] = $data.hasOwnProperty(vars[i]) ? $data[vars[i]] : settings.undefinedValue;
				}
				
				return StringUtil.substitute(string, params);
			}
			return string;
		}
		
		public function dump():Object {
			var r:String = StringUtils.replaceAll(string, settings.varBegin, settings.screenEndBegin);
			var params:Array = [];
			var response:Object = { id:id };
			
			for (var i :int = 0; i < vars.length; i++) {
				params[i] = settings.varBegin.concat(vars[i], settings.varEnd);
			}
			response[settings.valueField] = StringUtil.substitute(r, params);
			
			return response;
		}
	
	}

}