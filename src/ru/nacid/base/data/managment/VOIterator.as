package ru.nacid.base.data.managment 
{
	import ru.nacid.base.data.interfaces.IData;
	
    public class VOIterator
    {
        private var list  : Vector.<IData> ;
        private var index : int;
		
		private var nullIndex:int;
		
        public function VOIterator( aList : Vector.<IData>,$nullIndex:int = 0 )
        {
            list = aList;
			nullIndex = $nullIndex;
			
            reset();
        }
        public function reset() : void
        {
            index = nullIndex - 1;
        }
        public function next() : IData
        {
            return list[ ++index ];
        }
		
        public function hasNext() : Boolean
        {
            return ( index < (list.length - 1) && list[index + 1] != null);
        }
		
		public function get step():int { 
			return index ; 
		}
    }
}