package Managers 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class manages all buttons in the game
	public class ButtonManager 
	{
		private var mButtons:Array;
		private var buttonTween:Tween;

		private static var instance:ButtonManager;
		private static var privatecall:Boolean;
		
		public function ButtonManager() 
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
		public static function GetInstance():ButtonManager
		{
			if (instance == null)
			{
				privatecall = true;
				ButtonManager.instance = new ButtonManager();
				privatecall = false;
			}
			return ButtonManager.instance;
		}
		private function Init():void
		{
			mButtons = new Array();
		}
		//create a button in the game
		public function CreateButton(theButtonText:String, X:int = 0, Y:int = 0,CallBack:Function = null):uint
		{
			var mFormat:TextFormat = new TextFormat();
			var newItem:MovieClip = new MovieClip();
			var mText:TextField = new TextField();
			
            mFormat.font = "Arcade";
			mFormat.size = 25;
			mFormat.align = TextFormatAlign.LEFT;
			
			mText.embedFonts = true;
			mText.defaultTextFormat = mFormat;
			mText.text = theButtonText;
			mText.autoSize = TextFieldAutoSize.LEFT;

			mText.wordWrap = false;
			newItem.buttonMode = false;
			newItem.mouseChildren = false;
			
			newItem.addChild(mText);
			newItem.x = X;
			newItem.y = Y;
			
			//Add event handlers (used for animating the buttons)
			newItem.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			newItem.addEventListener(MouseEvent.CLICK, CallBack);
			newItem.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			mButtons.push(newItem);
			return mButtons.length - 1;
		}
		//render the buttons
		public function RenderButton(ButtonID:uint,theDisplayObjectContainer:DisplayObjectContainer):void
		{
			if (ButtonID <  mButtons.length)
			{
				if (mButtons[ButtonID].parent != null) 
					if (mButtons[ButtonID].parent.contains(mButtons[ButtonID]))
					{
						mButtons[ButtonID].buttonMode = false;
						mButtons[ButtonID].parent.removeChild(mButtons[ButtonID]);
					}

				if (!theDisplayObjectContainer.contains(mButtons[ButtonID]))
				{
					mButtons[ButtonID].buttonMode = false;
					theDisplayObjectContainer.addChild(mButtons[ButtonID]);
				}
			}
		}
		
		public function GetButtonID(theButton:MovieClip):int
		{
			var i:int;
			for (i = 0; i < mButtons.length; i++ )
			{
				if (mButtons[i] === theButton)
				{
					return i;
				}
			}
			return -1;
		}
		public function UnRenderButton(ButtonID:uint):void
		{
			if (ButtonID <  mButtons.length)
				if (mButtons[ButtonID].parent != null)
					if (mButtons[ButtonID].parent.contains(mButtons[ButtonID]))
					{
						mButtons[ButtonID].buttonMode = false;
						mButtons[ButtonID].parent.removeChild(mButtons[ButtonID]);
					}
		}
		public function ClearCache():void
		{
			while (mButtons.length > 0)
				mButtons.pop();
		}
		private function mouseOverHandler(evt:Event):void
		{
			buttonTween = new Tween(evt.target, "scaleX", Elastic.easeOut, 1, 1.3, 1, true); 
		}
		private function mouseOutHandler(evt:Event):void
		{
			buttonTween = new Tween(evt.target, "scaleX", Elastic.easeOut, evt.target.scaleX, 1, 1, true);
		}
	}
	
}