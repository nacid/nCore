package ru.nacid.base.services.lan.loaders
{
	import ru.nacid.base.services.lan.loaders.types.UploadType;
	import ru.nacid.utils.Multipart;

	public class DataSender extends DataLoader
	{
		protected var files:Vector.<UploadType>;

		private var _multipart:Multipart;

		public function DataSender($url:String=null, $data:Object=null, $dataFormat:String=null)
		{
			super($url,$data,$dataFormat);

			files = Vector.<UploadType>([])
		}

		override protected function execInternal():void {
			_multipart = new Multipart(url);
			_multipart.addFields(data);
			while (files.length)
				addFile(files.pop());

			loader.load(req = _multipart.request);
		}

		private function addFile($type:UploadType):void {
			if ($type)
				_multipart.addFile($type.name, $type.makeRaw(), $type.mimeType, $type.symbol)
		}
	}
}