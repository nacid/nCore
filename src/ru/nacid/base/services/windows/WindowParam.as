package ru.nacid.base.services.windows 
{
	import ru.nacid.base.data.ValueObject;
	import ru.nacid.base.services.windows.interfaces.IWindowStorage;
	import ru.nacid.base.services.windows.policy.WindowPolicy;
	/**
	 * ...
	 * @author ...
	 */
	public class WindowParam extends ValueObject implements IWindowStorage
	{
		public var skinName	:String;
		
		private var _policy	:WindowPolicy;
		private var _render :Class;
		private var _cached :Boolean;
		private var _modal	:Boolean;
		
		public function WindowParam($id:String,
									$render:Class,
									$policy:WindowPolicy,
									$cached:Boolean		= false,
									$modal:Boolean		= false,
									$skinName:String 	= null) 
		{
			id 			= $id;
			skinName 	= $skinName;
			
			_policy 	= $policy;
			_render 	= $render;
			_cached 	= $cached;
			_modal 		= $modal;
		}
		
		public function get useSkin():Boolean { return skinName is String };
		
		public function get policy():WindowPolicy { return _policy };
		public function get render():Class { return _render };
		public function get cached():Boolean { return _cached };
		public function get modal():Boolean { return _modal };
		
	}

}