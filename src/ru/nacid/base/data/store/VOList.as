package ru.nacid.base.data.store
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.data.managment.VOIterator;
	
	/**
	 * VOList.as
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
	public class VOList extends EventDispatcher
	{
		protected var _list:Vector.<IData>
		protected var _hash:Object;
		
		private var _size:int;
		
		public function VOList($data:* = null)
		{
			clear();
			if ($data)
				for each (var oneObj:IData in $data)
					add(oneObj);
		}
		
		public function buildMap($target:Object, $startIndex:uint = 0):Object
		{
			var response:Object = $target || {};
			var iterator:VOIterator = createIteratorAt($startIndex);
			while (iterator.hasNext())
			{
				response[iterator.next().id] = iterator.step;
			}
			return response;
		}
		
		public function indexOfId($id:String):int
		{
			return _hash.hasOwnProperty($id) ? _hash[$id] : -1;
		}
		
		public function atId($id:String):IData
		{
			return containsId($id) ? _list[_hash[$id]] : null;
		}
		
		public function sort($callBack:Function):void {
			_list.sort($callBack);
			buildMap(_hash);
		}
		
		//***** JAVA
		
		public function get size():int
		{
			return _size;
		}
		
		public function add($obj:IData):Boolean
		{
			return addLast($obj);
		}
		
		public function addTo($obj:IData, $index:int):Boolean
		{
			if (contains($obj))
			{
				return false;
			}
			_list.splice(_hash[$obj.id] = $index, 0, $obj);
			
			while (++$index < _list.length)
			{
				_hash[_list[$index].id] = $index;
			}
			
			++_size;
			return true;
		}
		
		public function addAll($collect:VOList):void
		{
			var iterator:VOIterator = $collect.createIterator();
			while (iterator.hasNext())
			{
				add(iterator.next());
			}
		}
		
		public function addAllFrom($index:int, $collect:VOList):void
		{
			var iterator:VOIterator = $collect.createIteratorAt($index);
			while (iterator.hasNext())
			{
				addTo(iterator.next(), $index + iterator.step);
			}
		}
		
		public function addFirst($element:IData):Boolean
		{
			return addTo($element, 0);
		}
		
		public function addLast($element:IData):Boolean
		{
			return addTo($element, size);
		}
		
		public function clear():void
		{
			_list = Vector.<IData>([]);
			_hash = {};
			_size = 0;
		}
		
		public function createIteratorAt($startIndex:int):VOIterator
		{
			return new VOIterator(_list, $startIndex);
		}
		
		public function containsId($id:String):Boolean
		{
			return containsIndex(indexOfId($id));
		}
		
		public function containsIndex($index:uint):Boolean
		{
			return $index < _list.length;
		}
		
		public function contains($obj:IData):Boolean
		{
			return containsId($obj.id);
		}
		
		public function clone():VOList
		{
			return new VOList(toArray());
		}
		
		public function getFirst():IData
		{
			return at(0);
		}
		
		public function getLast():IData
		{
			return at(size - 1);
		}
		
		public function indexOf($obj:IData):int
		{
			return indexOfId($obj.id);
		}
		
		public function removeAt($index:int):IData
		{
			var response:IData;
			
			if (containsIndex($index))
			{
				response = _list.splice($index, 1).pop();
				--_size;
				delete _hash[response.id];
				buildMap(_hash, $index);
			}
			return response;
		}
		
		// $delCount == -1 >> end;
		public function removeAtMulti($start:int, $delCount:int = -1):Vector.<IData>
		{
			var response:Vector.<IData>;
			
			if (containsIndex($start))
			{
				if ($delCount < 0 || !containsIndex($start + $delCount))
					$delCount = size - $start;
				
				response = _list.splice($start, $delCount);
				_size -= response.length;
				
				for (var i:int = 0; i < response.length; i++)
				{
					delete _hash[response[i].id];
				}
			}
			return response;
		}
		
		public function removeAtId($id:String):IData
		{
			return removeAt(indexOfId($id));
		}
		
		public function remove($obj:IData):IData
		{
			return removeAtId($obj.id);
		}
		
		public function removeFirst():IData
		{
			return removeAt(0);
		}
		
		public function removeLast():IData
		{
			return removeAt(size - 1);
		}
		
		public function setAt($index:int, $obj:IData):void
		{
			_list[_hash[$obj.id] = $index] = $obj;
		}
		
		public function setAtId($id:String, $obj:IData):void
		{
			if (containsId($id))
			{
				_list[indexOfId($id)] = $obj;
			}
			else
			{
				addLast($obj);
			}
		}
		
		public function toArray():Array
		{
			var array:Array = [];
			var iterator:VOIterator = createIterator();
			while (iterator.hasNext())
			{
				array.push(iterator.next());
			}
			return array;
		}
		
		public function createIterator():VOIterator
		{
			return new VOIterator(_list);
		}
		
		public function at($index:uint):IData
		{
			return containsIndex($index) ? _list[$index] : null;
		}
	
	}

}