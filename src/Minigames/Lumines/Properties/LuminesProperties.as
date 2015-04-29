package Minigames.Lumines.Properties
{
	
	/**
	* ...
	* @author Brian Young
	*/
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	//this class stores the properties of the game
	public class LuminesProperties 
	{
		/////////////////////Block Types/////////////////////////
		// There are various types of blocks in the game. here is an explanation of each type of block.
		// Type '0'  - EMPTY : They are empty slots in the map, and do not contain any blocks of any type
		// Type '1'  - COLOR1 : These are blocks which are of the first type.
		// Type '2'  - COLOR2 : These are blocks which are of the second type.
		// Type '3'  - X COLOR1 : These are blocks which are of the first type, 
		//                       but cause a chain reaction of neighbouring blocks of the same colour.
		// Type '4'  - X COLOR2 : These are blocks which are of the second type, 
		//                       but cause a chain reaction of neighbouring blocks of the same colour.
		public static var NUMVARIETIES:int = 4;
		public static var NUMXVARIETIES:int = 3;
		public static var EMPTY:int = 0;
		public static var RED:int =  1;
		public static var XRED:int = 2;
		public static var GREEN:int  = 3;
		public static var XGREEN:int = 4;
		public static var BLUE:int = 5;
		public static var XBLUE:int = 6;
		public static var YELLOW:int = 7;
		public static var XYELLOW:int = 8;
		
		//public static var CLRCOLOR:int = 5;
		
		public var LoadComplete:Boolean;
		//Game Map Properties
		private var mWidth:int;     //Map Width
		private var mHeight:int;    //Map Height
		private var mBlockSize:int; //Individual block space size
		private var mQuadSize:int;  //Breadth of a player controlled piece
		private var mMatchSize:int; //Breadth of the set of matching blocks
		private var mStackSize:int; //Reserve Stack size
		private var mStackSpace:int; //Spacing in between stacks of quads
		private var mStartX:int; 	//Starting X position for piece on map
		private var mStartY:int;    //Starting Y position for piece on map
		private var mMapOffsetX:int;//X Offset from upper right hand corner of screen for map
		private var mMapOffsetY:int;//Y Offset from upper right hand corner of screen for map
		private var mStackOffsetX:int;//X Offset from upper right hand corner of screen for stack
		private var mStackOffsetY:int;//Y Offset from upper right hand corner of screen for stack
		private var mAnimSpeed:Number; //Animation Speed of falling blocks
		private var mTimeLineSpeed:Number;//speed of the moving timeline
		private var mMapFillAlert:int;//the number of cubes in the map required for an alert of losing
		private var mMaxCombo:int;
		private var mXMLLoader:URLLoader;
		private var mXMLData:XML;
		
		
		private static var privatecall:Boolean;
		private static var Instance:LuminesProperties;
		public function LuminesProperties() 
		{
			if (!privatecall)
			{
				throw new Error("This is a singleton");
			}
			else
			{
				Init();
			
			}
		}
		public static function GetInstance():LuminesProperties
		{
			if (!Instance)
			{
				privatecall = true;
				Instance =  new LuminesProperties();
				privatecall = false;
			}
			return Instance;
		}
		public function Init():void
		{
			LoadComplete = false;
			LoadFile("LuminesSettings.xml");
		}
		public function LoadFile(theFile:String):void
		{
			mXMLLoader = new URLLoader();
			mXMLLoader.load(new URLRequest(theFile));
			mXMLLoader.addEventListener(Event.COMPLETE, DataLoaded);
		}
		private function DataLoaded(e:Event):void
		{
			mXMLData = new XML(e.target.data);
			mWidth = mXMLData.Settings.(@type == "Map").width;
			mHeight = mXMLData.Settings.(@type == "Map").height;
			mBlockSize = mXMLData.Settings.(@type == "Map").blocksize;
			mStackSize = mXMLData.Settings.(@type == "Map").stacksize;
			mMatchSize = mXMLData.Settings.(@type == "Map").matchsize;
			mStackSpace = mXMLData.Settings.(@type == "Map").stackspace;
			mQuadSize = mXMLData.Settings.(@type == "Map").quadsize;
			mStartX = mXMLData.Settings.(@type == "Map").startx;
			mStartY = mXMLData.Settings.(@type == "Map").starty;
			mMapOffsetX = mXMLData.Settings.(@type == "Map").mapoffsetx;
			mMapOffsetY = mXMLData.Settings.(@type == "Map").mapoffsety;
			mStackOffsetX = mXMLData.Settings.(@type == "Map").stackoffsetx;
			mStackOffsetY = mXMLData.Settings.(@type == "Map").stackoffsety;
			mAnimSpeed = mXMLData.Settings.(@type == "Map").animspeed;
			mTimeLineSpeed = mXMLData.Settings.(@type == "Map").timelinespeed;
			mMapFillAlert = mXMLData.Settings.(@type == "Map").mapfillalert;
			mMaxCombo = mXMLData.Settings.(@type == "Map").maxcombo;
			LoadComplete = true;
		}
		public function get MaxCombo():int
		{
			return mMaxCombo;
		}
		public function get MapFillAlert():int
		{
			return mMapFillAlert;
		}
		public function get TimeLineSpeed():Number
		{
			return mTimeLineSpeed;
		}
		public function get MatchSize():int
		{
			return mMatchSize;
		}
		public function get MapWidth() : int
		{
			return mWidth;
		}
		public function get MapHeight() : int
		{
			return mHeight;
		}
		public function get BlockSize() : int
		{
			return mBlockSize;
		}
		public function get StackSize():int
		{
			return mStackSize;
		}
		public function get StackSpace():int
		{
			return mStackSpace;
		}
		public function get StartX():int
		{
			return mStartX;
		}
		public function get StartY():int
		{
			return mStartY;
		}
		public function get MapOffsetX():int
		{
			return mMapOffsetX;
		}
		public function get MapOffsetY():int
		{
			return mMapOffsetY;
		}
		public function get StackOffsetX():int
		{
			return mStackOffsetX;
		}
		public function get StackOffsetY():int
		{
			return mStackOffsetY;
		}
		public function get QuadSize():int
		{
			return mQuadSize;
		}
		public function get AnimSpeed():Number
		{
			return mAnimSpeed;
		}
	}
	
}