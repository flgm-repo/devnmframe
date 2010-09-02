package com.nameframe.utils
{
	public class NameframeUtils
	{
		public function NameframeUtils()
		{
		}
		
		
		public static function getMaximum(selectedItems:Array):int
		{
			var mxm:int = selectedItems[0];
			for (var i:int = 0 ; i<selectedItems.length ; i++ ) 
			{
    			if (selectedItems[i]>mxm) 
    			{
    				mxm = selectedItems[i];
    			}
   			}
   			return mxm;
		}
		
		public static function getMinimum(selectedItems:Array):int
		{
			var mnm:int = selectedItems[0];
			for ( var i:int=0; i<selectedItems.length ; i++) 
			{
    			if (selectedItems[i]<mnm) 
    			{
    				mnm = selectedItems[i];
    			}
   			}
   			return mnm;
		}
				
	}
}