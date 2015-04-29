package 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import Managers.*;
	import States.*;
	import Minigames.Lumines.Properties.LuminesProperties;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import Model.PlayerModel;

	public class Main extends Sprite
	{
		
		public function Main():void
		{
			var Enable:Boolean = false;
			addChild(GraphicsManager.GetInstance());
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyUpHandler);
			stage.displayState = StageDisplayState.NORMAL;
			var timer:uint = setInterval(Start, 50);
			//check if all components have loaded first. then initialize states
			function Start():void
			{
				if (SoundManager.GetInstance().LoadComplete)
				if (TextManager.GetInstance().LoadComplete)
				if (LuminesProperties.GetInstance().LoadComplete)
				if (TileManager.GetInstance().LoadComplete)
				if (MenuManager.GetInstance().mLoaded)
				if (EntityManager.GetInstance().LoadComplete)
				{
					Enable = true;
					StateManager.GetInstance().Init();
					GraphicsManager.GetInstance().addEventListener(Event.ENTER_FRAME, Update);
					(StateManager.GetInstance().ToggleState(StateManager.MAINMENUSTATE) )//as MinigameState).SetMinigame(MinigameState.MINIGAME_LUMINES);
					clearInterval(timer);
				}
			}
			//update state that key down has been pressed
			function KeyDownHandler(evt:KeyboardEvent):void
			{
				KeyboardManager.getInstance().keyDown(evt);
				if (Enable)
				{
					StateManager.GetInstance().UpdateKeyboard(evt);
				}
			}
			//update state that key has lifted
			function KeyUpHandler(evt:KeyboardEvent):void
			{
				KeyboardManager.getInstance().keyUp(evt);
				if (Enable)
					StateManager.GetInstance().UpdateKeyboard(evt);
			}
			//update states every frame 
			function Update():void
			{
				if (Enable)
					StateManager.GetInstance().Update();
			}
		}

		
	}
}