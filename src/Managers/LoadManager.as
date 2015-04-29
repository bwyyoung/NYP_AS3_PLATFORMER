package Managers 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import Model.DataModel;
	import View.ProgressBarView;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.text.TextField;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import Managers.TextManager;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//the loadmanager manages loading of all game resources, like images and data from xml files
	public class LoadManager 
	{
		private var mLoading:Boolean;
		private var mProgressBar:ProgressBarView;
		private var mLoadQueue:Array;
		private var mDisplayText:uint;
		private var mUTimer:uint;
		private static var instance:LoadManager;
		private static var privatecall:Boolean;
		
		public function LoadManager() 
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
		private function Init():void
		{
			mProgressBar = new ProgressBarView((536 - 400) / 2, 360, 400, 30);
			mLoadQueue = new Array();
			mLoading = false;
			mDisplayText = TextManager.GetInstance().CreateText();
			TextManager.GetInstance().SetPosition(mDisplayText,100, 200);			
		}
		//Returns the Singleton instance of LoadManager
        public static function getInstance() : LoadManager
        {
            if (instance == null)
            {
				privatecall = true;
                instance = new LoadManager();
				privatecall = false;
            }
            return instance;
        }
		//request a load of data
		public function RequestLoad(theRequest:URLRequest, DataName:String = "", FunctionCall:Function = null):void
		{
			mLoadQueue.push(new DataModel(theRequest, DataName, FunctionCall));
			if (!mLoading)
			{
				mUTimer = setInterval(RenderPreloader, 50);
				InitPreLoader();
			}
		}
		
		private function InitPreLoader():void
		{
			mLoading = true;			
			TextManager.GetInstance().Render(mDisplayText,GraphicsManager.GetInstance().ForeGround);
			if (!GraphicsManager.GetInstance().ForeGround.contains(mProgressBar))
				GraphicsManager.GetInstance().ForeGround.addChild(mProgressBar);
		}
		//remove the preloader from the screen once all the data has been loaded
		private function LoadComplete():void
		{
			mLoading = false;
			TextManager.GetInstance().UnRender(mDisplayText);
			if (GraphicsManager.GetInstance().ForeGround.contains(mProgressBar))
				GraphicsManager.GetInstance().ForeGround.removeChild(mProgressBar);
			clearInterval(mUTimer);
		}
		//draw the preloader on screen
		private function RenderPreloader():void
		{
			var bytesLoaded:Number = 0;
			var bytesTotal:Number = 0;
			var DisplayString:String = "";
			var Finish:Boolean = true;
			for each (var Element:DataModel in mLoadQueue)
			{
				bytesLoaded += Element.Loaded;
				bytesTotal += Element.Total;
			
				if (Element.Loaded == Element.Total && Element.Total !=0)
				{
					DisplayString = Element.Info;
				}
				else
				{
					Finish = false;
				}
			}
			var Percentage:int = bytesLoaded / bytesTotal * 100;
			DisplayString = "Loading    " + Percentage;
			mProgressBar.Update(bytesLoaded / bytesTotal * 100);
			TextManager.GetInstance().SetText(mDisplayText,DisplayString);
			if (Percentage == 100)
				LoadComplete();
		}
		public function get Loading():Boolean
		{
			return mLoading;
		}
		
	}
	
}