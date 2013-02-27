package ru.nacid.utils.encoders.data
{
	import flash.utils.describeType;
	import flash.xml.XMLDocument;

	import ru.nacid.utils.encoders.interfaces.IEncoder;

	public class Xml implements IEncoder
	{

		public function encodeObject($data:Object):Object
		{
			var writer:XMLWriter=new XMLWriter();
			var objDescriptor:XML=describeType($data);
			var property:XML;
			var propertyType:String;
			var propertyValue:Object;
			var qualifiedClassName:String=objDescriptor.@name;
			qualifiedClassName=qualifiedClassName.replace("::", ".");
			writer.xml.setName(qualifiedClassName);
			for each (property in objDescriptor.elements("variable"))
			{
				propertyValue=$data[property.@name];
				if (propertyValue != null)
				{
					if (propertyValue is String || propertyValue is Number || propertyValue is Boolean)
					{
						writer.addProperty(property.@name, propertyValue.toString());
					}
					else
					{
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
			return objectFromXML(XML($data));

			function objectFromXML(xml:XML):Object
			{
				var obj:Object={};

				if (xml.hasSimpleContent())
				{
					return String(xml);
				}

				for each (var attr:XML in xml.@*)
				{
					if (obj[String(attr.name())] == null)
					{
						obj[String(attr.name())]=attr;
					}
					else if (obj[String(attr.name())] is Array)
					{
						obj[String(attr.name())].push(attr);
					}
					else
					{
						obj[String(attr.name())]=[obj[String(attr.name())]];
						obj[String(attr.name())].push(attr);
					}
				}

				for each (var node:XML in xml.*)
				{
					if (obj[String(node.localName())] == null)
					{
						obj[String(node.localName())]=objectFromXML(node);
					}
					else if (obj[String(node.localName())] is Array)
					{
						obj[String(node.localName())].push(objectFromXML(node));
					}
					else
					{
						obj[String(node.localName())]=[obj[String(node.localName())]];
						obj[String(node.localName())].push(objectFromXML(node));
					}
				}

				return obj;
			}
		}

		public function decodeString($data:Object):String
		{
			return $data.toString();

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

	public function addProperty(propertyName:String, propertyValue:String):XML
	{
		var xmlProperty:XML=<new/>
		xmlProperty.setName(propertyName);
		xmlProperty.appendChild(propertyValue);
		xml.appendChild(xmlProperty);
		return xmlProperty;
	}
}
