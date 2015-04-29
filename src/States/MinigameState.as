package States {
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import Interface.KeyBoardInterface;
	import Minigames.Minigame;
	import Minigames.Lumines.Model.Lumines;
	import flash.utils.*;
	import Controller.*;
	import View.KeyboardInputView;
	/**
	* ...
	* @author Default
	*/
	public class MinigameState extends State 
	{
		public static const MINIGAME_LUMINES:String = getQualifiedClassName(Lumines);
	
		private var mCurrentMinigame:int;
		private var mMinigameController:KeyBoardInterface;
		private var mMinigameInputView:KeyboardInputView;
		
		private var mMinigameNames:Array;
		private var mMinigames:Array;
		
		private var mMinigameControllers:Array;
		
		
		public function MinigameState() 
		{
			mMinigameInputView = null;
			mCurrentMinigame = -1;
			
			
			var mLuminesMinigame:Minigame = new Lumines();
			mMinigames = new Array();
			mMinigames.push(mLuminesMinigame);
			
			var mLuminesController:KeyBoardInterface = new LuminesController(mLuminesMinigame);
			mMinigameControllers = new Array();
			mMinigameControllers.push(mLuminesController);
			
			
			mMinigameNames = new Array();
			for each (var temp:Minigame in mMinigames)
			{
				mMinigameNames.push(getQualifiedClassName(temp));
			}
		}
		public function SetMinigame(theMinigame:String):void
		{
			for (var i:int = 0; i < mMinigameNames.length; i++ )
			{
				if (mMinigameNames[i] == theMinigame)
				{
					Cleanup();
					mCurrentMinigame = i;
					mMinigames[i].Init();
					mMinigameInputView = new KeyboardInputView(mMinigames[i], mMinigameControllers[mCurrentMinigame]);
					break;
				}
			}
		}
		public function EndMiniGame():void
		{
			mMinigames[mCurrentMinigame].EndGame();
		}
		public override function Init():void
		{
			super.Init();
		}
		public override function Cleanup():void 
		{
			super.Cleanup();
			
			if (mCurrentMinigame > -1)
			{
				mMinigames[mCurrentMinigame].Cleanup();
			}
			mCurrentMinigame = -1;
			mMinigameInputView = null;//clear away the input view. let garbage collector delete it
		}
		public override function Update():void 
		{
			super.Update();
			if (mCurrentMinigame > -1)
			{
				mMinigames[mCurrentMinigame].Update();
			}
		}
		public override function UnRender():void 
		{
			super.UnRender();
			if (mCurrentMinigame > -1)
			{
				mMinigames[mCurrentMinigame].UnRender();
			}
		}
		public override function Render():void 
		{
			super.Render();
			if (mCurrentMinigame > -1)
			{
				mMinigames[mCurrentMinigame].Render();
			}
		}
		public override function UpdateKeyboard(event:KeyboardEvent):void 
		{
			super.UpdateKeyboard(event);
			if (mMinigameInputView != null)
			{
				mMinigameInputView.onKeyPress(event);
			}
		}
		public override function UpdateMouse(event:MouseEvent):void 
		{
			super.UpdateMouse(event);
		}
	}
	
}