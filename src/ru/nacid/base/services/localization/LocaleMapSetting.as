package ru.nacid.base.services.localization
{

	/**
	 * LocaleMapSetting.as
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
	public class LocaleMapSetting
	{
		private var _keyField:String;
		private var _valueField:String;
		private var _varBegin:String;
		private var _screen:String;
		private var _undefinedValue:String;
		private var _varEnd:String;

		private var _screenEndBegin:String;

		public function LocaleMapSetting($keyField:String = 'key',$valueField:String='value', $varBegin:String='%', $screen:String='/', $undefinedValue:String='???', $varEnd:String=null)
		{
			_keyField = $keyField;
			_valueField=$valueField;
			_varBegin=$varBegin;
			_screen=$screen;
			_undefinedValue=$undefinedValue;
			_varEnd=$varEnd || _varBegin;

			_screenEndBegin=_screen.concat(_varBegin);
		}

		public function get keyField():String
		{
			return _keyField;
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
