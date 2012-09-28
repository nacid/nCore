package ru.nacid.utils.encoders.data
{
	import flash.utils.describeType;
	import flash.xml.XMLDocument;
	
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.rpc.xml.SimpleXMLEncoder;
	import mx.utils.ObjectUtil;
	
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	public class Xml implements IEncoder
	{
		public static var MX_MODE:String = 'mxMode';
		
		private var _dec:SimpleXMLDecoder;
		
		private var _mode:String;
		
		public function Xml($mode:String = null)
		{
			_mode = $mode ? $mode : MX_MODE;
			
			if(isMX){
				_dec = new SimpleXMLDecoder(true);
			}
		}
		
		private function get isMX():Boolean{
			return _mode == MX_MODE;
		}
		
		public function encodeObject($data:Object):Object
		{
			var writer:XMLWriter=new XMLWriter();
			var objDescriptor:XML=describeType($data);
			var property:XML; 
			var propertyType:String;    
			var propertyValue:Object;
			var qualifiedClassName:String=objDescriptor.@name;
			qualifiedClassName=qualifiedClassName.replace("::",".");
			writer.xml.setName(qualifiedClassName);                 
			for each(property in objDescriptor.elements("variable")){
				propertyValue=$data[property.@name];
				if (propertyValue!=null){
					if (ObjectUtil.isSimple(propertyValue)){
						writer.addProperty(property.@name, propertyValue.toString());
					}
					else {
						writer.addProperty(property.@name, (new Xml).encodeObject(propertyValue).toXMLString());
					}                                 
				}                           
			}  
			return writer.xml;
		}
		
		public function encodeString($data:String):Object
		{
			return XML($data);
		}
		
		public function encodeFloat($data:Number):Object
		{
			return XML($data);
		}
		
		public function decodeObject($data:Object):Object
		{
			var response:Object;
			
			if(isMX){
				response = _dec.decodeXML(new XMLDocument($data as String));
			}
			
			return response;
		}
		
		public function decodeString($data:Object):String
		{
			var response:Object;
			
			if(isMX){
				response = _dec.decodeXML(new XMLDocument($data as String));
			}
			
			return response.toString();
		}
		
		public function decodeFloat($data:Object):Number
		{
			return parseFloat($data.toString());
		}
	}
}

class XMLWriter 
{
	public var xml:XML;
	
	public function XMLWriter()
	{
		xml=<obj/>;
	}       
	public function addProperty(propertyName:String, propertyValue:String):XML {
		var xmlProperty:XML=<new/>
		xmlProperty.setName(propertyName);
		xmlProperty.appendChild(propertyValue);
		xml.appendChild(xmlProperty);
		return xmlProperty;
	}   
}
