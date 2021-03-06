package ru.nacid.base.services.lan
{
	import ru.nacid.base.data.factory.FactoryBase;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.base.services.lan.data.RequestVO;
	import ru.nacid.base.services.lan.data.UrlStorage;

	/**
	 * URLFactory.as
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
	public class URLFactory extends FactoryBase
	{
		private var aliases:Object

		public function URLFactory()
		{
			cl=RequestVO;
			aliases={};
		}

		override protected function create($key:String, $data:Object):IFactoryData
		{
			return new RequestVO($key, $data);
		}

		public function getUrl($url:String, $data:Object=null):RequestVO
		{
			return read($url, $data) as RequestVO;
		}

		public function writeAlias($key:String, $data:Object):UrlStorage
		{
			return aliases[$key]=new UrlStorage($data.host, $data.params, $data.userData);
		}

		public function readAlias($key:String):UrlStorage
		{
			return aliases[$key] || writeAlias($key, {});
		}
	}

}
