package ru.nacid.base.data.factory
{
	import flash.utils.Dictionary;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.utils.HashUtils;
	
	/**
	 * FactoryBase.as
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
	public class FactoryBase
	{
		protected var cl:Class;
		
		protected var dict:Dictionary = new Dictionary(true);
		protected var hash:Object = {};
		
		protected function write($obj:IFactoryData,$dict:Boolean = true):IFactoryData
		{
			hash[$obj.symbol] = $obj;
			if ($dict) dict[$obj.valueOf()] = $obj;
			return $obj;
		}
		
		protected function read($key:String, $data:Object = null):IFactoryData
		{
			if (hash[$key])
			{
				var dictKey:Number = HashUtils.CRC($data);
				if (dict[dictKey])
				{
					return dict[dictKey];
				}
				else
				{
					return dict[dictKey] = create($key, $data);
				}
			}
			else
			{
				return write(create($key, $data));
			}
		}
		
		protected function create($key:String, $data:Object):IFactoryData
		{
			var newOne:IFactoryData = new cl;
			newOne.setData($data);
			return newOne;
		}
	
	}

}