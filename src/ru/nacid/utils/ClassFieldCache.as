package ru.nacid.utils
{
	import flash.utils.*;

	public class ClassFieldCache
	{
		private static var smFieldInfoCache:Dictionary = new Dictionary(true);
		
		public static function getFieldsOfClass(c:*):Dictionary
		{
			if(!(c is Class))
			{
				c = getDefinitionByName(getQualifiedClassName(c));
			}
			
			if(smFieldInfoCache.hasOwnProperty(c))
				return smFieldInfoCache[c];
			
			var typeXml:XML = describeType(c);
			var typeDict:Dictionary = new Dictionary();
			
			for each (var variable:XML in typeXml.factory.variable)
			typeDict[variable.@name.toString()] = variable.@type.toString();
			
			for each (var accessor:XML in typeXml.factory.accessor)
			{
				if(accessor.@access == "readonly")
					continue;
				
				typeDict[accessor.@name.toString()] = accessor.@type.toString();
			}
			
			smFieldInfoCache[c] = typeDict;
			return typeDict;
		}
	}
}