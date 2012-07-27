package ru.nacid.base.data.factory
{
	import flash.utils.Dictionary;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.utils.HashUtils;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class FactoryBase
	{
		protected var cl:Class;
		
		private var dict:Dictionary = new Dictionary(true);
		private var hash:Object = {};
		
		protected function write($obj:IFactoryData):IFactoryData
		{
			hash[$obj.id] = $obj;
			dict[$obj.valueOf()] = $obj;
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