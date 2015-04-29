package Managers 
{

	import flash.display.Bitmap;
	import flash.events.Event;
	import Tiles.TileSet;
	import Tiles.BackgroundSet;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.net.URLRequest;
	import Managers.LoadManager;
	import XML;
	import flash.xml.XMLDocument;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import Properties.GameProperties;
	import fl.transitions.easing.Strong;
	import fl.motion.Animator;
	import flash.display.Bitmap;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class manages all map tiles in the game
	public class TileManager 
	{
		public static const BLOCK:String = "Block";
		public static const DIAGONAL:String = "Diagonal";
		private var TileSetArray:Array;//this is a 2d array for tiles of various types
		private var BackgroundSetArray:Array;
		private var TileTypes:Array;// this stores the various tile types that can be found
		private var TiledLoaded:int = 0;
		private var TotalTiles:int = 0;
		public var LoadComplete:Boolean = false;
		private static var instance:TileManager;
		private static var privatecall:Boolean;
		public function TileManager() 
		{
			if (!privatecall)
			{
				throw new Error("This is Singleton Class");
			}
			else
			{
				Init();
			}
		}
		public static function GetInstance():TileManager
		{
			if (instance == null)
			{
				privatecall = true;
				TileManager.instance = new TileManager();
				privatecall = false;
			}
			return TileManager.instance;
		}
		//get a specific tile set in the game
		public function GetTileSet(theType:String, theName:String):TileSet
		{
			for (var i:int = 0; i < TileTypes.length; i++)
			{
				if (TileTypes[i] == theType)
				{
					for (var j:int = 0; j < TileSetArray[i].length; j++)
					{
						if (TileSetArray[i][j].mName == theName)
						{
							return TileSetArray[i][j];
						}
					}
				}
			}
			throw new Error("Invalid data for tiles " + theType + theName)
			return TileSetArray[0][0];
		}
		//get a background to be rendered in the game
		public function GetBackground(theType:String, theName:String):Bitmap
		{
			var theBGBitmap:Bitmap;
			for (var i:int = 0; i < BackgroundSetArray.length; i++)
			{
				if (BackgroundSetArray[i].mName == theType)
				{
					var theBGSet:BackgroundSet = BackgroundSetArray[i];
					theBGBitmap = theBGSet.GetBackground(theName);
				}
			}
			return theBGBitmap;
		}
		private function Init():void
		{
			BackgroundSetArray = new Array();
			TileTypes = new Array();
			TileTypes.push(BLOCK);
			TileTypes.push(DIAGONAL);
			TileSetArray = new Array(TileTypes.length);
			for (var i:int = 0 ; i < TileSetArray.length; i++)
			{
				TileSetArray[i] = new Array();
			}
			//start loading data about tiles  and backgrounds from the xml files
			LoadManager.getInstance().RequestLoad(new URLRequest("Tiles.xml"), "Tiles Information", TileDataLoaded);
			LoadManager.getInstance().RequestLoad(new URLRequest("Backgrounds.xml"), "Background Information", BackgroundDataLoaded);
		}
		private function BackgroundDataLoaded(evt:Event):void //called when the xml file for background is already loaded
		{
			var i:int;
			var k:int;
			var ext:String;
			var data:XML = new XML(evt.target.data);
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(data.toXMLString());
			var numBackgroundTypes:int = data.Background.length();
			
			for (i = 0; i < numBackgroundTypes; i++)//process the data
			{
				var mBackgroundSet:BackgroundSet = new BackgroundSet();
				mBackgroundSet.mName = data.Background[i].@type;
				mBackgroundSet.mTileWidth = data.Background[i].width;
				mBackgroundSet.mTileHeight = data.Background[i].height;
				ext = data.Background[i].extension;
				for (k = 0; k < data.Background[i].Background.length(); k++)
				{
					LoadManager.getInstance().RequestLoad(new URLRequest(data.Directory.@name + data.Background[i].@type + "/"
					+ data.Background[i].Background[k].@name + "/" + data.Background[i].Background[k].@name + ext),data.Background[i].@type + "/"
					+ data.Background[i].Background[k].@name, BackgroundLoaded); //load the actual background image
					BackgroundSetArray.push(mBackgroundSet);
					TotalTiles++;
				}
			}
	
			var timer:uint = setInterval(LoadCheck, 50);
			function LoadCheck():void //check if everything has already been loaded
			{
				if (TiledLoaded
				>= TotalTiles)
				{
					LoadComplete = true;
					clearInterval(timer);
				}
			}
			
		}
		//once the background itself has been loaded, add it to an array of backgrounds
		private function BackgroundLoaded(evt:Event):void
		{
			var i:int;
			var j:int;
			var k:int;
			var b:Bitmap = evt.currentTarget.content;
			var theName:String = b.parent.name;
			var theArray:Array = theName.split("/");
			for (i = 0; i < BackgroundSetArray.length; i++)
			{
				if (BackgroundSetArray[i].mName == theArray[0])
				{
					var g:int = 0;
					var theBGSet:BackgroundSet = BackgroundSetArray[i];
					theBGSet.AddBackground(b,theArray[1]);
					TiledLoaded++;
				}
			}
		}
		//call this function when the tile data has been loaded
		private function TileDataLoaded(evt:Event):void
		{
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var data:XML = new XML(evt.target.data);
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(data.toXMLString());
			var numTileTypes:int = data.tiles.length();
			
			for (i = 0; i < numTileTypes; i++)
			{
				for (j = 0; j < TileTypes.length; j++ )
				{
					if (data.tiles[i].@type == TileTypes[j])
					{
						for (k = 0; k < data.tiles[i].tile.length(); k++)//process all the data
						{
							var mTileSet:TileSet = new TileSet();
							mTileSet.mName = data.tiles[i].tile[k].@name;
							mTileSet.mTileWidth = data.tiles[i].tile[k].width;
							mTileSet.mTileHeight = data.tiles[i].tile[k].height;
							mTileSet.mNumTiles = data.tiles[i].tile[k].numtiles;
							LoadManager.getInstance().RequestLoad(new URLRequest(data.Directory.@name + data.tiles[i].@type + "/"
							+ data.tiles[i].tile[k].@name + "/" + data.tiles[i].tile[k].@name + ".png"),data.tiles[i].@type + "/"
							+ data.tiles[i].tile[k].@name, TileLoaded);
							TileSetArray[j].push(mTileSet);
							TotalTiles++;
						}
					}
				}
			}
			var timer:uint = setInterval(LoadCheck, 50);
			function LoadCheck():void
			{
				if (TiledLoaded
				>= TotalTiles)
				{
					LoadComplete = true;
					clearInterval(timer);
				}
			}
		}
		private function TileLoaded(evt:Event):void//once the actual tile is loaded, add it into an array
		{
			var i:int;
			var j:int;
			var k:int;
			var b:Bitmap = evt.currentTarget.content;
			for (i = 0; i < TileTypes.length; i++)
			{
				for (j = 0; j < TileSetArray[i].length; j++)
				{
					if (TileTypes[i] + "/" + TileSetArray[i][j].mName == b.parent.name)
					{
						var g:int = 0;
						var theTileSet:TileSet = TileSetArray[i][j];
						for (k = 0; k < theTileSet.mNumTiles; k++)
						{
							var rect:Rectangle = new Rectangle(k * theTileSet.mTileWidth, 0, 
							k * theTileSet.mTileWidth+ theTileSet.mTileWidth, b.height);
							var a:BitmapData = new BitmapData(theTileSet.mTileWidth,b.height);
							var pt:Point = new Point(0, 0);
							a.copyPixels(b.bitmapData, rect, pt);
							theTileSet.AddTile(new Bitmap(a));
							if (GameProperties.DEBUG)
							{
								var c:Bitmap = new Bitmap(theTileSet.GetTileData(k));
								c.y = 10+ TiledLoaded*GameProperties.TILEWIDTH;
								c.x = theTileSet.mTileWidth * (g) + 60 ; 
								g++;
								GraphicsManager.GetInstance().MapGround.addChild(c);
							}
						}
						TiledLoaded++;
					}	
				}
			}
		}
	}
	
}