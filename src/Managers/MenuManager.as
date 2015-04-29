package Managers 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import Managers.StateManager;
	import Menus.*;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.utils.*;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class MenuManager
	{
		//this is the class that manages all menus
		public static const DEFINITION:String = "Menus";
		public static const MAINMENU:String = getQualifiedClassName(MainMenu);
		public static const OPTIONS:String = getQualifiedClassName(Options);
		public static const PAUSE:String = getQualifiedClassName(Pause);
		public static const CLOSE:String = "Menus::Close";
		private var mMenuNames:Array;
		private var mMenus:Array;
		public var mLoaded:Boolean = false;
		public static var instance:MenuManager=null;
		private static var privatecall:Boolean;
		private var mCurrentMenu:int = -1 ;
		
		public function MenuManager()
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
			var mainmenu:Menu = new MainMenu();
			var options:Menu = new Options();
			var pause:Menu = new Pause();
			mMenus = new Array();
			mMenuNames = new Array();
			mMenus.push(mainmenu);
			mMenus.push(options);
			mMenus.push(pause);
			
			for each (var item:Menu in mMenus)
			{
				mMenuNames.push(getQualifiedClassName(item));
			}
			//load all information about menu buttons
			LoadManager.getInstance().RequestLoad(new URLRequest("MenuButtons.xml"), "Button Information", ButtonsLoaded);
		}
		//once the buttons are loaded, process the data
		private function ButtonsLoaded(evt:Event):void
		{
			var data:XML = new XML(evt.target.data);
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(data.toXMLString());
			
			var numMenus:int = data.Menu.length();
			
			for (var i:int = 0; i < numMenus; i++)
			{
				for (var j:int = 0; j < mMenus.length; j++ )
				{
					if (data.Menu[i].@type == getQualifiedClassName(mMenus[j]))
					{
						
						for (var k:int = 0; k < data.Menu[i].Buttons.button.length(); k++)
						{
							var numLinks:int = data.Menu[i].Buttons.button[k].Link.length();
							var MyLinks:Array = new Array();
							for (var l:int = 0; l < numLinks; l++ )
							{
								MyLinks.push(data.Menu[i].Buttons.button[k].Link[l].@name.toString());
							}
							mMenus[j].AddButton(data.Menu[i].Buttons.button[k].@name.toString(), 
							data.Menu[i].Buttons.button[k].x, data.Menu[i].Buttons.button[k].y,
							MyLinks);
						}
					}
				}
			}
			mLoaded = true;
		}
		//Returns the Singleton instance of LoadManager
        public static function GetInstance() : MenuManager
        {
            if (instance == null)
            {
				privatecall = true;
                instance = new MenuManager();	
				privatecall = false;
            }
            return MenuManager.instance;
        }
		//toggle the menu that should currently be displayed
		public function ToggleMenu(theMenuName:String):void
		{
			var i:int;
			if (theMenuName == CLOSE)
				UnSetCurrentMenu();
			for (i = 0; i < mMenuNames.length; i++)
			{
				if (mMenuNames[i] == theMenuName)
				{
					SetMenu(i);
				}
			}
		}
		private function SetMenu(i:int):void
		{
			if (mCurrentMenu >=0)
				mMenus[mCurrentMenu].CleanUp();
			mCurrentMenu = i;
			mMenus[mCurrentMenu].Init();
		}
		public function UnSetCurrentMenu():void
		{
			if (mCurrentMenu >=0)
				mMenus[mCurrentMenu].CleanUp();
			mCurrentMenu = -1;
		}
		
		
	}
	
}