package Managers
{
	
	/**
	* ...
	* @author Brian Young
	*/
	import fl.motion.easing.Back;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import States.*;
	import Properties.GameProperties;
	
	//this class manages all states in the game
	public class StateManager 
	{
		public static const DEFINITION:String = "States";
		public static const GAMESTATE:String = getQualifiedClassName(GameState);
		public static const MAINMENUSTATE:String = getQualifiedClassName(MenuState);
	
		public static const MINIGAMESTATE:String = getQualifiedClassName(MinigameState);
		
		private var mStates:Array;
		private var mCurrentState:int = -1;
		private var mPreviousState:int = -1;
		
		public var mStateNames:Array;
		public static var instance:StateManager=null;
		private static var privatecall:Boolean;
		public static var Enable:Boolean = false;
		
		public function StateManager()
		{
			if (!privatecall)
			{
				throw new Error("This is Singleton Class");
			}
		}
		//Returns the Singleton instance of LoadManager
        public static function GetInstance() : StateManager
        {
            if (instance == null)
            {
				privatecall = true;
                instance = new StateManager();	
				privatecall = false;
            }
            return StateManager.instance;
        }
		public function Init():void
		{
			mStateNames = new Array();
			mStates = new Array();
			var mGameState:State = new GameState();
			var mMenuState:State = new MenuState();
			var mMinigameState:State = new MinigameState();
			
			mStates.push(mGameState);
			mStates.push(mMenuState);
			mStates.push(mMinigameState);
			
			for each (var state:State in mStates)
			{
				mStateNames.push(getQualifiedClassName(state));
			}
		}
		//update the current state, if the game is not currently paused
		public function Update():void
		{
			if (!GameProperties.GetInstance().GetProperty(GameProperties.PAUSE))
			if (!LoadManager.getInstance().Loading)
				if (mCurrentState>=0)
					mStates[mCurrentState].Update();
		}
		//update the current state on keyboard input
		public function UpdateKeyboard(event:KeyboardEvent):void
		{
			if (KeyboardManager.getInstance().isKeyDown(event.keyCode))
			{
			if (event.keyCode == Keyboard.BACKSPACE)
				if (mCurrentState == 2)
				StateManager.GetInstance().RenderPreviousState();
			if (event.keyCode == Keyboard.ENTER)
				if (mCurrentState == 0)
				(StateManager.GetInstance().UnRenderToggleState(StateManager.MINIGAMESTATE)as MinigameState).SetMinigame(MinigameState.MINIGAME_LUMINES);
			}
			if (!LoadManager.getInstance().Loading)
				if (mCurrentState>-1)
					mStates[mCurrentState].UpdateKeyboard(event);
		}
		//update the current state on mouse input
		public function UpdateMouse(event:MouseEvent):void
		{
			if (!LoadManager.getInstance().Loading)
				if (mCurrentState>=0)
					mStates[mCurrentState].UpdateMouse(event);
		}
		public function Cleanup():void
		{
			
		}
		//set the current state
		private function SetCurrentState(theState:int):void
		{
			if (mCurrentState >= 0)
			{
				mStates[mCurrentState].Cleanup();
			}
			mCurrentState = theState;
			mStates[theState].Init();
		}
		//this is to toggle between states, and the states are cleaned up completely, with the new state being initialised 
		public function ToggleState(theState:String):State
		{
			var i:int;
			for (i = 0; i < mStateNames.length; i++ )
			{
				if (mStateNames[i] == theState)
				{
					SetCurrentState(i);
					break;
				}
			}
			return mStates[mCurrentState];
		}
		
		public function UnRenderToggleState(theTempState:String):State
		{
			var i:int;
			for (i = 0; i < mStateNames.length; i++ )
			{
				if (mStateNames[i] == theTempState)
				{
					if (mCurrentState >= 0)
					{
						mPreviousState = mCurrentState;
						mStates[mPreviousState].UnRender();
						mCurrentState = i;
						mStates[i].Init();
					}
				}
			}
			return mStates[mCurrentState]; 
		}
		public function RenderPreviousState():void
		{
			if (mPreviousState > -1)
			{
				mStates[mCurrentState].Cleanup();
				mCurrentState = mPreviousState; 
				mStates[mPreviousState].Render();
				mPreviousState = -1;
			}
		}
		public function GetState(theState:String):State
		{
			var i:int;
			for (i = 0; i < mStateNames.length; i++ )
			{
				if (mStateNames[i] == theState)
				{
					break;
				}
			}
			return mStates[i];
		}
		public function get CurrentState():int
		{
			return mCurrentState;
		}
		

	}	
}