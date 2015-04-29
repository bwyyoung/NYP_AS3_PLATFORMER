package Managers 
{
	import fl.motion.Animator;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
    import flash.text.TextField;
	import flash.net.URLRequest;
	import flash.text.Font;
    import flash.text.TextFieldAutoSize;
	import flash.system.ApplicationDomain;
    import flash.text.TextFormat;
    import flash.text.AntiAliasType;
	import flash.display.Loader;


	import flash.utils.*;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class manages rendering of all text in the game, not buttons
	public class TextManager
	{
		public var LoadComplete:Boolean;
		//this is the manager to render text on the screen
        private var mFields:Array;
		private static var instance:TextManager;
		private static var privatecall:Boolean;
		
		private var mFontDomain:ApplicationDomain;
		private var mArcadeFormat:TextFormat;
		private var mLoader:Loader;
		private var mFontNames:Array;
		private var FontLibrary:Class ;
		public function TextManager() 
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
		public static function GetInstance():TextManager
		{
			if (instance == null)
			{
				privatecall = true;
				TextManager.instance = new TextManager();
				privatecall = false;
			}
			return TextManager.instance;
		}
		private function Init():void
		{
			LoadComplete = false;
			mLoader = new Loader();
			mFields =  new Array();
			LoadComplete = true;
			
			/*Here, I tried loading fonts externally by loader, but it didnt work. */
			//mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,FontLoaded);
 	 	 	//mLoader.load(new URLRequest("../lib/Font/Font.swf"));
		}
		private function FontLoaded(evt:Event):void
		{
			FontLibrary = evt.target.applicationDomain.getDefinition("Arcade") as Class;
			var temp:Font = FontLibrary as Font;
			//the failure occurs below, I cannot register my font to the Font class. It says its an invalid parameter, although it is a class containing data about the font.
			//I can even trace the qualifiedclassname of the font, and it is correct. 
			Font.registerFont(FontLibrary);

			LoadComplete = true;
 	 	}

		//draw text on the screen
		public function CreateText(theText:String = "", X:int = 0, Y:int = 0, TextSize:int = 18) :uint
		{
			//Note to examiner:
			//I have no choice but to embed my fonts in my game, because loading fonts externally without embedding them does not work, and I have tried all methods I could find.
			[Embed(source = '../../lib/Font/ARCADE.TTF', fontFamily = "Arcade")]
			var string:String;
			var mFormat:TextFormat = new TextFormat();
            mFormat.font = "Arcade";
            mFormat.size = TextSize*0.67;
            
			var Field:TextField = new TextField();
            Field.embedFonts = true;
            Field.autoSize = TextFieldAutoSize.LEFT;
            Field.defaultTextFormat = mFormat;
            Field.text = theText;
			Field.x = X;
			Field.y = Y;
		
			mFields.push(Field);
			return mFields.length - 1;
		}
		//render the text
		public function Render(TextID:uint,theDisplayObjectContainer:DisplayObjectContainer):void
		{
			if (TextID < mFields.length)
			{
				if (mFields[TextID].parent != null)
					if (mFields[TextID].parent.contains(mFields[TextID]))
						mFields[TextID].parent.removeChild(mFields[TextID]);

				if (!theDisplayObjectContainer.contains(mFields[TextID]))
					theDisplayObjectContainer.addChild(mFields[TextID]);
			}
		}
		public function UnRender(TextID:uint):void
		{
			if (TextID < mFields.length)
			{
				if (mFields[TextID].parent != null)
					if (mFields[TextID].parent.contains(mFields[TextID]))
						mFields[TextID].parent.removeChild(mFields[TextID]);
			}
		}
		public function SetText(TextID:uint, theText:String):void
		{
			if (TextID < mFields.length)
				mFields[TextID].text = theText;
		}
		public function SetPosition(TextID:uint,X:int, Y:int):void
		{
			if (TextID < mFields.length)
			{
				mFields[TextID].x = X;
				mFields[TextID].y = Y;
			}
		}
		public function SetColor(TextID:int, R:Number, G:Number, B:Number):void
		{
			var temp:String = R.toString(16)+G.toString(16)+B.toString( 16);
			var hex:uint = parseInt(temp,16);
			mFields[TextID].textColor = hex;
		}
		public function GetX(TextID:uint):int
		{
			return mFields[TextID].x;
		}
		public function GetY(TextID:uint):int
		{
			return mFields[TextID].y;
		}
		public function  GetWidth(TextID:uint):Number
		{
			if (TextID < mFields.length)
				return mFields[TextID].textWidth;
			else
				return 0;
		}
		public function GetHeight(TextID:uint):Number
		{
			if (TextID < mFields.length)
				return mFields[TextID].textHeight;
			else
				return 0;
		}		
	}
	
}