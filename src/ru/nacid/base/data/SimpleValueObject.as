package ru.nacid.base.data 
{
	import ru.nacid.base.data.interfaces.IData;
	/**
	 * SimpleValueObject.as
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
	public class SimpleValueObject implements IData 
	{
		protected var _id:String;
		protected var _numericId:uint;
		
		public function SimpleValueObject($key:String) 
		{
			_id = $key;
			_numericId = 0;
		}
		
		/* INTERFACE ru.nacid.base.data.interfaces.IData */
		
		public function get id():String 
		{
			return _id;
		}
		
		public function valueOf():Number 
		{
			return _numericId;
		}
		
	}
	
}