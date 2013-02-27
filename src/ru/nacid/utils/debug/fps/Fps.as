package ru.nacid.utils.debug.fps
{
	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.view.interfaces.IDisplayContainerProxy;
	import ru.nacid.base.view.interfaces.IDisplayObject;
	
	public class Fps extends Command
	{
		public static const COMMAND_LINE:String='fps';
		
		private static var _enabled:Boolean;
		private static var _stats:IDisplayContainerProxy;
		private static var _container:IDisplayContainerProxy;
		
		public function Fps($container:IDisplayContainerProxy = null)
		{
			if (_container == null)
			{
				_container=$container;
			}
			
			symbol='statsBlock';
		}
		
		protected function createStats():IDisplayObject{
			return new Stats
		}
		
		override protected function execInternal():void
		{
			
			if (_stats == null)
			{
				_stats=_container.empty();
				_stats.add(createStats());
			}
			
			
			if (!_enabled)
			{
				_container.add(_stats);
				_enabled=true;
			}
			else
			{
				_container.rem(_stats);
				_enabled=false;
			}
			
			notifyComplete();
			reset();
		}
	}
}
