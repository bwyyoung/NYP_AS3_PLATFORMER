package Controller 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import Interface.KeyBoardInterface;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import Managers.KeyboardManager;
	import Managers.MenuManager;
	import Properties.GameProperties;
	import flash.ui.KeyLocation;
	//this class handles key input from the keyboard handler class
	public class PlayerController implements KeyBoardInterface
	{
		private var mModel:Object;
		public function PlayerController(theModel:Object) 
		{
			mModel = theModel;
			Init();
		}
		public function Init():void
		{
			
		}
		//it handles all the specific key input for the game
		public function keyPressHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{   //press the shift key to pause the game
				case Keyboard.SHIFT:
					if (event.type == KeyboardEvent.KEY_DOWN)
					{
						GameProperties.GetInstance().ToggleProperty(GameProperties.PAUSE);
						if (GameProperties.GetInstance().GetProperty(GameProperties.PAUSE))
						{
							mModel.Pause();
							MenuManager.GetInstance().ToggleMenu(MenuManager.PAUSE);
						}
						else
						{
							MenuManager.GetInstance().UnSetCurrentMenu();
						}
					}
				break;
				case Keyboard.SPACE:
					mModel.Jump(event);
				break;
				case Keyboard.LEFT:
					mModel.WalkLeft(event);
				break;
				case Keyboard.RIGHT:
					mModel.WalkRight(event);	
				break;
				case Keyboard.UP:
					mModel.LookUp(event);
				break;
				case Keyboard.DOWN:
					mModel.Crouch(event);
				break;
			}		
		}
	}
}