package ru.nacid.base.services.lan.data
{

	/**
	 * UrlStorage.as
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
	public class UrlStorage extends Object
	{
		private var _host:String;
		private var _data:Object;
		private var _userData:Object;

		public function UrlStorage($host:String, $data:Object=null, $userData:Object=null)
		{
			_host=$host;
			_data=$data || {};
			_userData=$userData || {};
		}

		public function get host():String
		{
			return _host;
		}

		public function get data():Object
		{
			return _data;
		}

		public function get userData():Object
		{
			return _userData;
		}
	}

}
