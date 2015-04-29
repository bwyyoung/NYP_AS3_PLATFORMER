package Properties 
{
	import flash.net.IDynamicPropertyOutput;
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class GameProperties 
	{
		public static const DEBUG:Boolean = false;
		public static const DEFINITION:String = "GameProperties";
		public static const SOUND:String = "GameProperties::Sound";
		public static const SCROLLING:String = "GameProperties::Scrolling";
		public static const PAUSE:String = "GameProperties::Pause";
		
		public static const TILEWIDTH:int = 48;
		public static const TILEHEIGHT:int = 48;
		public static const FPS:Number = 30;
		public static const SCREENWIDTH:int = 1024;
		public static const SCREENHEIGHT:int = 768;
		public static const MAPWIDTH:int = 100;
		public static const MAPHEIGHT:int = 16;
		
		public static var instance:GameProperties=null;
		private static var privatecall:Boolean;
		private var sound:Boolean;
		private var scrolling:Boolean;
		private var pause:Boolean;
		
		public var PropertyNames:Array;
		private var PropertyArray:Array;
		
		public function GameProperties()
		{
			if (!privatecall)
			{
				throw new Error("This is Singleton Class");
			}
			else
			{
				PropertyNames = new Array();
				PropertyArray = new Array();
				sound = true;
				scrolling = true;
				
				PropertyNames.push(SOUND);
				PropertyNames.push(SCROLLING);
				PropertyNames.push(PAUSE);
				
				PropertyArray.push(sound);
				PropertyArray.push(scrolling);
				PropertyArray.push(pause);
			}
		}
		//Returns the Singleton instance of LoadManager
        public static function GetInstance() : GameProperties
        {
            if (instance == null)
            {
				privatecall = true;
                instance = new GameProperties();	
				privatecall = false;
            }
            return GameProperties.instance;
        }
		public function ToggleProperty(thePropertyName:String, ...args):void
		{
			var i:int;
		
			for (i = 0; i < PropertyNames.length; i++)
			{
				if (PropertyNames[i] ==  thePropertyName)
				{
					if (PropertyArray[i] is Boolean)
					{
						if (args.length == 1)
						{
							if (args[0] is Boolean)
								PropertyArray[i] = args[0];
						}
						else
						{
							PropertyArray[i] = !PropertyArray[i];
						}
					}
				}
			}
		}
		public function GetProperty(thePropertyName:String):Object
		{
			var i:int;
			
			for (i = 0; i < PropertyNames.length; i++)
			{
				if (PropertyNames[i] ==  thePropertyName)
				{
					return PropertyArray[i];
				}
			}
			return 0;
		}
		
	}
	
}