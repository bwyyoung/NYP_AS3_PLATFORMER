package Item {
	import Animations.AnimationSet;
	import flash.display.DisplayObjectContainer;
	import Model.Entity;
	import Model.PlayerModel;
	import Managers.EntityManager;
	import flash.utils.*;
	import flash.events.TimerEvent;
	import Managers.StateManager;
	import Properties.GameProperties;
	
	import Managers.SoundManager;
	import GameSound.SoundData;
				
	/**
	* ...
	* @author Default
	*/
	//this is the entity class for flagpole
	public class FlagPole extends Entity
	{
		private var mFlag:AnimationSet;
		private var UpperYOffset:int = 48;
		private var LowerYOffset:int = 48;
		private var thePlayer:PlayerModel;
		private var mTimer:uint;
		
		private var mBGM:SoundData;
		private var mBGM2:SoundData;
		
		public function FlagPole(theanimationset:AnimationSet) 
		{
			mBGM = SoundManager.GetInstance().GetSound("World", "Music");
			mBGM2 = SoundManager.GetInstance().GetSound("LevelComplete", "Music");

			super(theanimationset);
			mFlag = EntityManager.GetInstance().GetAnimationSet("StandardFlag");
			mFlag.SetPosition(mAnimationSet.mX-mFlag.Width/2,mAnimationSet.mY - mAnimationSet.Height/2 + UpperYOffset);
		}
		public override function SetPosition(x:Number, y:Number):void 
		{
			super.SetPosition(x, y);
			mFlag.SetPosition(mAnimationSet.mX-mFlag.Width/2,mAnimationSet.mY - mAnimationSet.Height/2 + UpperYOffset);	
		}
		public override function Render(theDisplayObjectContainer:DisplayObjectContainer):void {
			mBGM.Play(true);
			super.Render(theDisplayObjectContainer);
			mFlag.Render(theDisplayObjectContainer);
		}
		public override function UnRender():void {
			super.UnRender();
			mBGM.Stop();
			mBGM2.Stop();
		}
		public override function CleanUp():void {
			super.CleanUp();
			mFlag.UnRender();
			mBGM.Stop();
			mBGM2.Stop();
		}
		//do an action when an entity collides with the flagpole
		public override function DoAction(theEntity:Entity):void {
			super.DoAction(theEntity);
			
			if (getDefinitionByName(getQualifiedClassName(theEntity)) == PlayerModel)
			{
				thePlayer = theEntity as PlayerModel;
				if (thePlayer.mControl)
				{
					mBGM.Stop();
					mBGM2.Play();
					mTimer = setInterval(Slide, 1/GameProperties.FPS, thePlayer);
					thePlayer.SetState(PlayerModel.PLAYER_SLIDE);
					thePlayer.mControl = false;
				}
			}
		}
		public override function Pause():void
		{
			super.Pause();
		}
		public override function Stop():void
		{
			super.Stop();
			mBGM.Stop();
			mBGM2.Stop();
		}
		public override function Play():void
		{
			super.Play();
			if (mBGM.IsPlaying == false)
				mBGM.Play();
		}
		//make mario slide down the flagpole
		private function Slide():void
		{
			var thePlayer:PlayerModel = arguments[0];
			if (thePlayer.mY < mAnimationSet.mY + mAnimationSet.Height/2 - thePlayer.Height/2)
			{
				var thePlayerX:int = 0;
				if (thePlayer.mCurDirection)
					thePlayerX = mAnimationSet.mX - thePlayer.Width / 2;
				else
					thePlayerX = mAnimationSet.mX + thePlayer.Width / 2;
				mFlag.SetPosition(mFlag.mX, thePlayer.mY - thePlayer.Height/2);
				thePlayer.SetPosition(thePlayerX, thePlayer.mY + 0.3);
			}
			else
			{
				thePlayer.SetPosition(thePlayer.mX + thePlayer.Width, mAnimationSet.mY + mAnimationSet.Height/2 - thePlayer.Height/2);
				thePlayer.SetState(PlayerModel.PLAYER_WIN);
				clearInterval(mTimer);
				var theTimer:Timer = new Timer(5000, 1);
				theTimer.addEventListener(TimerEvent.TIMER_COMPLETE, EndGame);
				theTimer.start();
			}
		}
		//the game ends when mario reaches the ground
		public function EndGame(theTimerEvent:TimerEvent):void
		{
			theTimerEvent.target.stop();
			StateManager.GetInstance().ToggleState(StateManager.MAINMENUSTATE);
		}
	}
	
}