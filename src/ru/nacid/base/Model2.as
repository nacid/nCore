package ru.nacid.base
{
	import ru.nacid.base.data.ValueObject;
	import ru.nacid.base.view.data.Position;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class Model extends ValueObject
	{
		
		//-----------------------
		private static var _instance:Model;
		
		public function Model($data:Object)
		{
			if (!instance)
			{
				_instance = this;
				super(null, $data);
				
				log('data model created');
			}
			else
			{
				warning('duplicate Model constructor call');
			}
		}
		
		static public function get instance():Model
		{
			return _instance;
		}
		
	}

}