package Managers {

	import GraphicalUserInterface.*;
	

	import flash.utils.*;
	import GraphicalUserInterface.*;
	/**
	* ...
	* @author Default
	*/
	//this class manages all the GUIs in the game.
	public class GUIManager {
		public static const GUI_LUMINES:String = getQualifiedClassName(LuminesGUI);
		public static const GUI_STANDARD:String = getQualifiedClassName(StandardGUI);
		
		private static var instance:GUIManager;
		private static var privatecall:Boolean;
	
		private var mGUIs:Array;
		public function GUIManager() 
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
			var mLuminesGUI:GUI = new LuminesGUI();
			var mStandardGUI:GUI = new StandardGUI();
			
			mGUIs = new Array();
			mGUIs.push(mLuminesGUI);
			mGUIs.push(mStandardGUI);
			
			for each(var mGUI:GUI in mGUIs)
			{
				mGUI.Init();
			}
			
			
		}
		public static function GetInstance():GUIManager
		{
			if (instance == null)
			{
				privatecall = true;
				GUIManager.instance = new GUIManager();
				privatecall = false;
			}
			return GUIManager.instance;
		}
		public function GetGUI(theGUIName:String):GUI
		{
			var theGUI:GUI;
			for each (var mGUI:GUI in mGUIs)
			{
				if (getQualifiedClassName(mGUI) == theGUIName)
				{
					theGUI = mGUI;
					break;
				}
			}
			return theGUI;
		}
		public function DisableAllGUIs():void
		{
			for each (var mGUI:GUI in mGUIs)
			{
				mGUI.CleanUp();
			}
		}

	}
	
}