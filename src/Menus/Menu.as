package Menus 
{
	import Managers.ButtonManager;
	import Managers.GraphicsManager;
	import Managers.StateManager;
	import Managers.MenuManager;
	import Properties.GameProperties;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class Menu 
	{
		//this is the base class for all menus
		protected var mButtonManager:ButtonManager = ButtonManager.GetInstance();
		protected var mGraphicsManager:GraphicsManager = GraphicsManager.GetInstance();
		protected var mStateManager:StateManager = StateManager.GetInstance();
		protected var mGameProperties:GameProperties = GameProperties.GetInstance();
		
		public var ButtonArray:Array;
		public var LinkArray:Array;
		
		public function Menu() 
		{
			ButtonArray  = new Array();
			LinkArray  = new Array();
		}
		/*add a button to an existing menu class*/
		public function AddButton(ButtonName:String, x:int, y:int, Link:Array):void
		{
			ButtonArray.push(mButtonManager.CreateButton(ButtonName, x, y,  ButtonPressed));
			LinkArray.push(Link);
		}
		//Render all buttons in this current menu to be shown on screen.
		public function Init():void
		{
			for each(var ID:uint in ButtonArray)
			{
				mButtonManager.RenderButton(ID, mGraphicsManager.ForeGround);
			}
		}
		//Unrender all menu buttons in this current menu. Only one menu can be shown at any one time.
		public function CleanUp():void
		{
			for each(var ID:int in ButtonArray)
			{
				mButtonManager.UnRenderButton(ID);
			}
		}
		//when a button is pressed, this function is called
		public function ButtonPressed(evt:Event):void
		{
			var ID:int = mButtonManager.GetButtonID(evt.target as MovieClip);
			var i:int; 
			for (i = 0; i < ButtonArray.length; i++)
			{
				if (ButtonArray[i] == ID)
					break;
			}
			if (ID >= 0)
			{
				//based on what was specified in the menu buttons xml file, different actions occur,
				//such as a change in menu state, or change in game state
				for (var j:int = 0; j < LinkArray[i].length; j++ )
				{
					var theType:Array = LinkArray[i][j].split(":", 1);
					switch(theType[0])
					{
						case MenuManager.DEFINITION:
							 MenuManager.GetInstance().ToggleMenu(LinkArray[i][j]);
						break;
						case StateManager.DEFINITION:
							mStateManager.ToggleState(LinkArray[i][j]);
						break;
						case GameProperties.DEFINITION:
							mGameProperties.ToggleProperty(LinkArray[i][j]);
						break;
					}
				}

			}
		}
		
	}
	
}