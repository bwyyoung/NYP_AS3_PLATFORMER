package View 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import Managers.GraphicsManager;
	import flash.display.Sprite;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class MapNode 
	{
		public var ArrayX:int;
		public var ArrayY:int;
		private var mX:int;
		private var mY:int;
		public var mTile:Bitmap;
		public var mCollide:Boolean = false;
		//these are the notes in each map
		public function MapNode(theArrayX:int, theArrayY:int) 
		{
			ArrayX = theArrayX;
			ArrayY = theArrayY;
			mTile = null;
		}
		//set the tile of each mapnode to be rendered
		public function SetTile(theBitmapData:BitmapData):void
		{
			if (mTile)
			{
				mTile = null;
			}
			mTile = new Bitmap(theBitmapData);
			mTile.x = mX;
			mTile.y = mY;
		}
		public function get X():int
		{
			return mX;
		}
		public function get Y():int
		{
			return mY;
		}
		//render the tile
		public function Render(thedp:DisplayObjectContainer):void
		{
			UnRender();
			if (mTile != null)
				thedp.addChild(mTile);
		}

		//get the tile width and height
		public function get Width():int
		{
			return mTile.width;
		}
		public function get Height():int
		{
			return mTile.height;
		}
		//remove the tile from rendering
		public function CleanUp():void
		{
			UnRender();
		}
		public function UnRender():void
		{
			if (mTile != null)
				if (mTile.parent != null)
					mTile.parent.removeChild(mTile);
		}
		//set the position of each tile
		public function SetPosition(x:int, y:int):void
		{
			mX = x;
			mY = y;
			if (mTile != null)
			{
				mTile.x = x;
				mTile.y = y;
			}
		}
		
	}
	
}