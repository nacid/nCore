package ru.nacid.base.services.localization.commands 
{
	import flash.net.FileReference;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.localization.Lm;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class DumpLocaleMap extends Command 
	{
		private var mapId:String;
		private var encoder:IEncoder;
		private var saver:FileReference;
		
		public function DumpLocaleMap($mapId:String,$encoder:IEncoder) 
		{
			id = 'dumpLocaleMap';
			mapId = $mapId;
			encoder = $encoder;
			saver = new FileReference();
		}
		
		override protected function execInternal():void 
		{
			var dumpData:Object = Lm.instance.getMap(mapId).dump();
			var formattedDump:Object = encoder.encodeObject(dumpData);
			
			saver.save(formattedDump, mapId.concat('_localeDump'));
			notifyComplete();
		}
		
	}

}