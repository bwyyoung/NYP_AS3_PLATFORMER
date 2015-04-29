package Minigames.Lumines.Model 
{
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import flash.utils.Timer;
	import GameSound.SoundData;
	import Menus.Pause;
	import Minigames.Lumines.Observer.Map;
	import Minigames.Lumines.Observer.Stack;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Minigames.Lumines.Observer.QuadCube;
	import flash.events.TimerEvent;
	import Minigames.Minigame;
	import Managers.GUIManager;
	import Managers.SoundManager;
	import GraphicalUserInterface.LuminesGUI;

	// MapModel notifies its observers of changes made
	public class Lumines extends Minigame
	{
		private var mStack:Stack;
		private var mMap:Map;
		private var mTimer:Timer;
		private var mMoveBlockSound:SoundData;
		private var mReloadBlockSound:SoundData;;
		public function Lumines() 
		{
			mStack =  new Stack();
			mMap = new Map();
			mMoveBlockSound = SoundManager.GetInstance().GetSound("MoveBlock", "FX");
			mReloadBlockSound = SoundManager.GetInstance().GetSound("Reload","FX");
		}
		public override function Init():void
		{	
			mPause = false;
			mStack.Init();
			mMap.Init();
			mMap.AttachNewQuad(mStack.GetTopStack());
			//(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).ResetData();
			
			mTimer = new Timer(1500, 0);
			mTimer.addEventListener(TimerEvent.TIMER, CheckUp);
			mTimer.start();
			
			Render();
		}
		public override function Update():void 
		{
			super.Update();
			if (!mPause)
			{
				if (mMap)
					mMap.Update();
				if (mStack)
					mStack.Update();
			}
				
			GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES).Update();
		}
		public override function EndGame():void 
		{
			mTimer.stop();
			mMoveBlockSound.Stop();
			mReloadBlockSound.Stop();
			super.EndGame();
			mPause = true;
			mStack.PauseCubes();
			(GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES) as LuminesGUI).EndGame();
		}
		public override function Cleanup():void
		{
			super.Cleanup();
			UnRender();
			mStack.Cleanup();
			mMap.Cleanup();
			mTimer.stop();
		}
		public override function Render():void 
		{
			super.Render();
			GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES).Render();
		}
		public override function UnRender():void 
		{
			super.UnRender();
			GUIManager.GetInstance().GetGUI(GUIManager.GUI_LUMINES).UnRender();
		}
		public function CheckUp(theTime:TimerEvent):void
		{
			ShiftDown();
		}
		//shift your controlled quad
		public function ShiftDown():void
		{
			if (!mMap.Move(0, 1))
			{
				mTimer.reset();
				mTimer.start();
				mReloadBlockSound.Play();
				ScanMap();
			}
			else
			{
				mMoveBlockSound.PlayContinuous();
			}
		}
		//shift your controlled quad
		public function ShiftLeft():void
		{
			mMoveBlockSound.PlayContinuous();
			mMap.Move( -1, 0);
		}
		//shift your controlled quad
		public function ShiftRight():void
		{
			mMoveBlockSound.PlayContinuous();
			mMap.Move(1, 0);
		}
		//rotate your controlled quad
		public function RotateLeft():void
		{
			mMoveBlockSound.PlayContinuous();
			mMap.Rotate(QuadCube.LEFT);
		}
		//rotate your controlled quad
		public function RotateRight():void
		{
			mMoveBlockSound.PlayContinuous();
			mMap.Rotate(QuadCube.RIGHT);
		}
		public function ScanMap():void
		{
			mMap.AttachNewQuad(mStack.GetTopStack());
		}

	}
	
}