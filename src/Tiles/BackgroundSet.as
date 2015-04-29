package Tiles {
	import flash.display.Bitmap;
	
	/**
	* ...
	* @author Default
	*/
	public class BackgroundSet {
		
		public var mName:String;
		public var mTileWidth:int;
		public var mTileHeight:int;
		public var mNumBackgrounds:int;
		private var mBackgrounds:Array;
		private var mBackgroundNames:Array;
		public function BackgroundSet() 
		{
			mBackgrounds = new Array();
			mBackgroundNames  = new Array();
		}
		//this is to add a tile to the tileset. 
		public function AddBackground(BackgroundBitMap:Bitmap, theBackgroundName:String):void
		{
			mBackgrounds.push(BackgroundBitMap);
			mBackgroundNames.push(theBackgroundName);
		}
		//this is to get the bitmapdata from a specific tile stored in an array.
		public function GetBackground(theBackgroundName:String):Bitmap
		{
			var mbitmap:Bitmap;
			for (var i:int = 0; i < mBackgroundNames.length; i++)
			{
				if (mBackgroundNames[i] == theBackgroundName)
				{
					mbitmap = new Bitmap(mBackgrounds[i].bitmapData);
				}
			}
			return mbitmap;
		}
		
	}
	
}