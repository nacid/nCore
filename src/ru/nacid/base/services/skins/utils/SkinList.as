package ru.nacid.base.services.skins.utils
{
	import flash.events.EventDispatcher;
	
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;
	
	/**
	 * SkinList.as
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
	dynamic public class SkinList extends EventDispatcher
	{
		protected var _list:Vector.<ISkinLoader>
		protected var _hash:Object;
		
		private var _size:int;
		
		public function SkinList($data:*=null)
		{
			clear();
			if ($data)
				for each (var oneObj:ISkinLoader in $data)
				add(oneObj);
		}
		
		public function buildMap($target:Object, $startIndex:uint=0):Object
		{
			var response:Object=$target || {};
			var iterator:SkinIterator=createIteratorAt($startIndex);
			while (iterator.hasNext())
			{
				response[iterator.next().symbol]=iterator.step;
			}
			return response;
		}
		
		public function indexOfId($id:String):int
		{
			return _hash.hasOwnProperty($id) ? _hash[$id] : -1;
		}
		
		public function atId($id:String):ISkinLoader
		{
			return containsId($id) ? _list[_hash[$id]] : null;
		}
		
		public function sort($callBack:Function):void
		{
			_list.sort($callBack);
			buildMap(_hash);
		}
		
		//***** JAVA
		
		public function get size():int
		{
			return _size;
		}
		
		public function add($obj:ISkinLoader):Boolean
		{
			return addLast($obj);
		}
		
		public function addTo($obj:ISkinLoader, $index:int):Boolean
		{
			if (contains($obj))
			{
				return false;
			}
			_list.splice(_hash[$obj.symbol]=$index, 0, $obj);
			
			while (++$index < _list.length)
			{
				_hash[_list[$index].symbol]=$index;
			}
			
			++_size;
			return true;
		}
		
		public function addAll($collect:SkinList):void
		{
			var iterator:SkinIterator=$collect.createIterator();
			while (iterator.hasNext())
			{
				add(iterator.next());
			}
		}
		
		public function addAllFrom($index:int, $collect:SkinList):void
		{
			var iterator:SkinIterator=$collect.createIteratorAt($index);
			while (iterator.hasNext())
			{
				addTo(iterator.next(), $index + iterator.step);
			}
		}
		
		public function addFirst($element:ISkinLoader):Boolean
		{
			return addTo($element, 0);
		}
		
		public function addLast($element:ISkinLoader):Boolean
		{
			return addTo($element, size);
		}
		
		public function clear():void
		{
			_list=Vector.<ISkinLoader>([]);
			_hash={};
			_size=0;
		}
		
		public function createIteratorAt($startIndex:int):SkinIterator
		{
			return new SkinIterator(this, $startIndex);
		}
		
		public function containsId($id:String):Boolean
		{
			return containsIndex(indexOfId($id));
		}
		
		public function containsIndex($index:uint):Boolean
		{
			return $index < _list.length;
		}
		
		public function contains($obj:ISkinLoader):Boolean
		{
			return containsId($obj.symbol);
		}
		
		public function clone():SkinList
		{
			return new SkinList(toArray());
		}
		
		public function getFirst():ISkinLoader
		{
			return at(0);
		}
		
		public function getLast():ISkinLoader
		{
			return at(size - 1);
		}
		
		public function indexOf($obj:ISkinLoader):int
		{
			return indexOfId($obj.symbol);
		}
		
		public function removeAt($index:int):ISkinLoader
		{
			var response:ISkinLoader;
			
			if (containsIndex($index))
			{
				response=_list.splice($index, 1).pop();
				--_size;
				delete _hash[response.symbol];
				buildMap(_hash, $index);
			}
			return response;
		}
		
		// $delCount == -1 >> end;
		public function removeAtMulti($start:int, $delCount:int=-1):Vector.<ISkinLoader>
		{
			var response:Vector.<ISkinLoader>;
			
			if (containsIndex($start))
			{
				if ($delCount < 0 || !containsIndex($start + $delCount))
					$delCount=size - $start;
				
				response=_list.splice($start, $delCount);
				_size-=response.length;
				
				for (var i:int=0; i < response.length; i++)
				{
					delete _hash[response[i].symbol];
				}
			}
			return response;
		}
		
		public function removeAtId($id:String):ISkinLoader
		{
			return removeAt(indexOfId($id));
		}
		
		public function remove($obj:ISkinLoader):ISkinLoader
		{
			return removeAtId($obj.symbol);
		}
		
		public function removeFirst():ISkinLoader
		{
			return removeAt(0);
		}
		
		public function removeLast():ISkinLoader
		{
			return removeAt(size - 1);
		}
		
		public function setAt($index:int, $obj:ISkinLoader):void
		{
			_list[_hash[$obj.symbol]=$index]=$obj;
		}
		
		public function setAtId($id:String, $obj:ISkinLoader):void
		{
			if (containsId($id))
			{
				_list[indexOfId($id)]=$obj;
			}
			else
			{
				addLast($obj);
			}
		}
		
		public function toArray():Array
		{
			var array:Array=[];
			var iterator:SkinIterator=createIterator();
			while (iterator.hasNext())
			{
				array.push(iterator.next());
			}
			return array;
		}
		
		public function createIterator():SkinIterator
		{
			return new SkinIterator(this);
		}
		
		public function at($index:uint):ISkinLoader
		{
			return containsIndex($index) ? _list[$index] : null;
		}
		
	}
	
}

