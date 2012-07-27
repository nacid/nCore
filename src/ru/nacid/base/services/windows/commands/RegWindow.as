package ru.nacid.base.services.windows.commands 
{
	import ru.nacid.base.services.windows.policy.WindowPolicy;
	import ru.nacid.base.services.windows.WindowParam;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class RegWindow extends WindowCommand 
	{
		private var render	:Class;
		private var policy	:WindowPolicy;
		private var cached	:Boolean;
		private var modal	:Boolean;
		private var skinName:String;
		
		
		public function RegWindow(	$id:String,
									$render:Class,
									$policy:WindowPolicy,
									$cached:Boolean		= false,
									$modal:Boolean		= false,
									$skinName:String 	= null)
		{
			super('registrateWindow', $id);
			
			render = $render;
			policy = $policy;
			cached = $cached;
			modal = $modal;
			skinName = $skinName;
		}
		
		override protected function execInternal():void 
		{
			navigator.regWindow(new WindowParam(windowId, render, policy, cached, modal, skinName));
			notifyComplete();
		}
		
	}

}