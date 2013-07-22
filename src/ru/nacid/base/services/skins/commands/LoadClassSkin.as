package ru.nacid.base.services.skins.commands
{
	import flash.display.Bitmap;
	
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;
	
	public class LoadClassSkin extends Command implements ISkinLoader
	{
		private var _class:Class;
		
		public function LoadClassSkin($id:String, $class:Class = null)
		{
			symbol = $id;
			
			if($class is Class){
				_class = $class;
				notifyComplete();
			}else{
				warning('class '.concat(symbol,' not found. Using Sprite...'));
			}
		}
		
		override protected function execInternal():void{
			notifyComplete();
		}
		
		public function getInstance():*
		{
			return new _class;
		}
		
		public function getEmpty():*
		{
			return new Bitmap();
		}
		
		public function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader
		{
			return new LoadSwfSkin($id,$url,$embed);
		}
		
		public function get embed():Boolean
		{
			return false;
		}
		
		public function get loaded():Boolean{
			return completed;
		}
		
		public function load():void{
			execute();
		}
	}
}