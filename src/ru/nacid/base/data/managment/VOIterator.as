package ru.nacid.base.data.managment
{
	import ru.nacid.base.data.interfaces.IData;

	/**
	 * VOIterator.as
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
	public class VOIterator
	{
		private var list:Vector.<IData>;
		private var index:int;

		private var nullIndex:int;

		public function VOIterator(aList:Vector.<IData>, $nullIndex:int=0)
		{
			list=aList;
			nullIndex=$nullIndex;

			reset();
		}

		public function reset():void
		{
			index=nullIndex - 1;
		}

		public function next():IData
		{
			return list[++index];
		}

		public function hasNext():Boolean
		{
			return (index < (list.length - 1) && list[index + 1] != null);
		}

		public function get step():int
		{
			return index;
		}
	}
}