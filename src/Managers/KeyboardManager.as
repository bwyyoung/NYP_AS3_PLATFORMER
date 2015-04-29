package Managers 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class manages key input in the game
import flash.events.KeyboardEvent;
    
    public class KeyboardManager
    {
	    //array of the keys that are down
        public var downKeys:Array;
		// Singleton instance 
        private static var instance:KeyboardManager;
		private static var privatecall:Boolean;
		
	    public function KeyboardManager()
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
			downKeys = new Array();
		}
		public function get downKeyCodes():Array
        {
            var a:Array = [];
            for (var i:Number = 0; i < downKeys.length; i++)
            {
                a.push(downKeys[i].keyCode);
            }
            return a;
        }
		
        //Returns the Singleton instance of KeyboardManager
        public static function getInstance() : KeyboardManager
        {
            if (instance == null)
            {
				privatecall = true;
                instance = new KeyboardManager();
				privatecall = false;
            }
            return instance;
        }
        //this function is called when a key is down, and the key is added to the array
        public function keyDown(event:KeyboardEvent):void
        {
			var i:int;
            for(i = 0; i < downKeys.length; i++)
            {
                if(downKeys[i].keyCode == event.keyCode)
                {
                    break;
                }
            }
			if (i == downKeys.length)
			{
				downKeys.push(event);
			} 
        }
         //this function is called when a key is up, and the key is removed from the array
        public function keyUp(event:KeyboardEvent):void
        {
			var i:int;
            for(i = 0; i < downKeys.length; i++)
            {
                if(downKeys[i].keyCode == event.keyCode)
                {
                    break;
                }
            }
            if( i < downKeys.length )
            {
                downKeys.splice(i,1);
            }
        }
		//check for the key that may be town, returns true if it is
        public function isKeyDown(searchKeyCode:Number):Boolean
        {   
            for(var j:int = 0; j < downKeys.length; j++)
            {
                var evt:KeyboardEvent = downKeys[j] as KeyboardEvent;
                if(evt.keyCode == searchKeyCode)
                {
                    return true;
                }
            }
            return false;
        }
    }	
}