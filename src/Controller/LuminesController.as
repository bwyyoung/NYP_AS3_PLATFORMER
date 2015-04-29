package Controller 
{
	import Interface.KeyBoardInterface;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.KeyLocation;
	import Managers.KeyboardManager;
	/**
	* ...
	* @author Default
	*/
	public class LuminesController implements KeyBoardInterface
	{
		private var mModel:Object;
		public function LuminesController(theModel:Object) 
		{
			mModel = theModel;
			Init();
		}
		public function Init():void
		{
			
		}
		public function keyPressHandler(event:KeyboardEvent):void
		{
			if (KeyboardManager.getInstance().isKeyDown(event.keyCode))
			switch (event.keyCode)
			{
				case 90 : //Z
					mModel.RotateLeft();
				break;
				case 88 : //X
					mModel.RotateRight();
				break;
				case Keyboard.LEFT :
					mModel.ShiftLeft();
				break;
				case Keyboard.RIGHT :
					mModel.ShiftRight();
				break;
				case Keyboard.UP :
					
				break;
				case Keyboard.DOWN :
					mModel.ShiftDown();
				break;

			}
		}
	}
	
}