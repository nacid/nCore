package ru.nacid.base.services.windows
{
	import ru.nacid.base.services.windows.interfaces.IWindowStorage;
	import ru.nacid.base.services.windows.policy.WindowPolicy;
	import ru.nacid.base.view.ViewObject;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class Window extends ViewObject implements IWindowStorage
	{
		private var windowParam:WindowParam;
		
		public function Window($param:WindowParam)
		{
			windowParam = $param;
			tabEnabled = true;
			focusRect = false;
			
			super(windowParam.id);
		}
		
		public function get policy():WindowPolicy
		{
			return windowParam.policy;
		}
		
		public function get render():Class
		{
			return windowParam.render;
		}
		
		public function get cached():Boolean
		{
			return windowParam.cached;
		}
		
		public function get modal():Boolean
		{
			return windowParam.modal;
		}
		
		public function setData($data:Object):void
		{
			showData = $data;
		}
		
		public function onFocus():void
		{
			
		}
	}

}