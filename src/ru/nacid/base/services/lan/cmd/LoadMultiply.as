package ru.nacid.base.services.lan.cmd
{
	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.services.CommandQueue;
	import ru.nacid.base.services.lan.loaders.MovieLoader;

	public class LoadMultiply extends CommandQueue
	{
		private var _result:Vector.<Object>;
		
		protected var ready:Boolean;
		protected var started:Boolean;

		public function LoadMultiply(... urls)
		{
			symbol='multiLoad';

			for each (var url:String in urls)
			{
				addCommand(new MovieLoader(url));
			}
		}

		override protected function execInternal():void
		{
			_result=new Vector.<Object>(size, true);
			super.execInternal();
		}
		
		override public function execute($data:Object=null):void{
			started = true;
			
			if(ready && started){
				super.execute($data);
			}else{
				channelInfo(symbol.concat(' will be launched after the internal readiness'));
			}
		}
		
		protected function readResponse():void{
			var listIterator:VOIterator=list.createIterator();
			while (listIterator.hasNext())
			{
				var cmd:MovieLoader=listIterator.next() as MovieLoader;
				_result[listIterator.step]=cmd.response;
			}
		}
		
		public function get response():Vector.<Object>{
			return _result;
		}
		
		public function isReady():Boolean{
			return ready;
		}
		
		public function isStarted():Boolean{
			return started;
		}
	}
}
