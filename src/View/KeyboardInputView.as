package View 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import flash.events.*;
	import flash.display.*;
	import Interface.KeyBoardInterface;
	//this is the implementation of the keyboardinputview
	public class KeyboardInputView extends CompositeView
	{
		public function KeyboardInputView(theModel:Object,
		theController:KeyBoardInterface)
		{
			super(theModel, theController);
		}
		public function onKeyPress(event:KeyboardEvent):void
		{
			(controller as KeyBoardInterface).keyPressHandler(event);
		}
	}
	
}