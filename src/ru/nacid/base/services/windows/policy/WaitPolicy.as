package ru.nacid.base.services.windows.policy 
{
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	import ru.nacid.base.services.windows.Window;
	import ru.nacid.base.services.windows.Wm;
	/**
	 * ...
	 * @author n.avdeenko
	 */
	public class WaitPolicy extends SinglePolicy
	{
		protected var windows:Array;
		
		public function WaitPolicy($closeOther:Boolean=false, $windows:Array=null, $locks:Array=null) 
		{
			super($closeOther, $locks);
			windows = $windows;
		}
		
		override public function applyOpen(activeList:Vector.<String>, targetId:String, data:Object):void 
		{
			if (windows && windows.length)
			{
				for each(var id:String in activeList)
				{
					if (windows.indexOf(id) >= 0)
					{
						var wnd:Window = Wm.instance.getWindow(id) as Window;
						wnd.visible = false;
					}
				}
			}
			super.applyOpen(activeList, targetId, data);
		}
		
		override public function applyClose(activeList:Vector.<String>, targetId:String, $force:Boolean = false):void 
		{
			if (windows && windows.length)
			{
				for each(var id:String in activeList)
				{
					if (windows.indexOf(id) >= 0)
					{
						var wnd:Window = Wm.instance.getWindow(id) as Window;
						wnd.visible = true;
					}
				}
			}
			super.applyClose(activeList, targetId, $force);
		}
	}

}