package Tiles 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this is a set of tiles from a spritesheet
	public class TileSet 
	{
		public var mName:String;
		public var mTileWidth:int;
		public var mTileHeight:int;
		public var mNumTiles:int;
		private var mTiles:Array;
		public function TileSet() 
		{
			mTiles = new Array();
		}
		//this is to add a tile to the tileset. 
		public function AddTile(TileBitMap:Bitmap):void
		{
			mTiles.push(TileBitMap);
		}
		//this is to duplicate the tileset into another tileset
		public function CopyData(theTileSet:TileSet):void
		{
			theTileSet.mName = mName;
			for each (var tile:Bitmap in mTiles)
			{
				var newtile:Bitmap = new Bitmap(tile.bitmapData);
				theTileSet.AddTile(newtile);
			}
		}
		//this is to get the bitmapdata from a specific tile stored in an array.
		public function GetTileData(TileID:int):BitmapData
		{
			var mbitmap:Bitmap;
			if (TileID < mTiles.length)
			{
				mbitmap = mTiles[TileID];
			}
			return mbitmap.bitmapData;
		}
		
	}
	
}