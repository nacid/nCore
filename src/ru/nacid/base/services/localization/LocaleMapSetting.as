package ru.nacid.base.services.localization
{
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class LocaleMapSetting
	{
		private var _valueField:String;
		private var _varBegin:String;
		private var _screen:String;
		private var _undefinedValue:String;
		private var _varEnd:String;
		
		private var _screenEndBegin:String;
		
		public function LocaleMapSetting($valueField:String = 'value', $varBegin:String = '%', $screen:String = '/',$undefinedValue:String = '???', $varEnd:String = null)
		{
			_valueField = $valueField;
			_varBegin = $varBegin;
			_screen = $screen;
			_undefinedValue = $undefinedValue;
			_varEnd = $varEnd || _varBegin;
			
			_screenEndBegin = _screen.concat(_varBegin);
		}
		
		public function get valueField():String
		{
			return _valueField;
		}
		
		public function get varBegin():String
		{
			return _varBegin;
		}
		
		public function get screen():String
		{
			return _screen;
		}
		
		public function get varEnd():String
		{
			return _varEnd;
		}
		
		public function get screenEndBegin():String 
		{
			return _screenEndBegin;
		}
		
		public function get undefinedValue():String 
		{
			return _undefinedValue;
		}
	
	}

}