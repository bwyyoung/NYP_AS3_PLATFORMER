package Managers 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class handles the drawing of graphics in the game
	public class GraphicsManager extends Sprite
	{
		private var mForeGround:Sprite;
		private var mMapGround:Sprite;
		private var mBackGround:Sprite;
		private var mStage:Stage;
		
		private static var instance:GraphicsManager;
		private static var privatecall:Boolean;
		
		public function GraphicsManager() 
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
		public static function GetInstance():GraphicsManager
		{
			if (instance == null)
			{
				privatecall = true;
				GraphicsManager.instance = new GraphicsManager();
				privatecall = false;
			}
			return GraphicsManager.instance;
		}
		private function Init():void 
		{
			mForeGround = new Sprite();
			mMapGround= new Sprite();
			mBackGround = new Sprite();
			this.addChild(mBackGround);
			this.addChild(mMapGround);
			this.addChild(mForeGround);
		}
		//set the stage, which will be the parent of the 3 layers of our game
		public function SetStage(theStage:Stage):void
		{
			mStage = theStage;
		}
		
		public function GetStage():Stage
		{
			return mStage;
		}
		//these three layers are display object containers which can be used to hold display objects
		public function get BackGround():Sprite
		{
			return mBackGround;
		}
		public function get MapGround():Sprite
		{
			return mMapGround;
		}
		public function get ForeGround():Sprite
		{
			return mForeGround;
		}
	
		
	}
	
}