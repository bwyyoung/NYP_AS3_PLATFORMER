package  States
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import Managers.TileManager;
	import Animations.AnimationSet;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import Properties.GameProperties;
	import Managers.MenuManager;
	import Managers.GraphicsManager;
	import GameSound.SoundData;
	import Managers.SoundManager;
	/**
	* ...
	* @author Brian Young
	*/
	public class MenuState extends State
	{
		private var mLogo:Bitmap;
		private var mBackground:Bitmap;
		private var mCurContainer:DisplayObjectContainer;
		private var mPower:Number;
		private var mLogoYSpeed:Number;
		private var mMaxY:Number;
		
		private var mBGM:SoundData;
		
		private var mMenuReady:Boolean;
		//this is the state for the main menu
		public function MenuState() 
		{
			mBGM = SoundManager.GetInstance().GetSound("Junior", "Music");
		}
		public override function Init():void
		{
			mMenuReady = false;
			//whenever we are in the main menu, we toggle the main menu to be the current menu that can have interactions

			mLogo = TileManager.GetInstance().GetBackground("Logo","TitleLogo");
			mBackground = TileManager.GetInstance().GetBackground("Background","TitleBackground");
			mCurContainer = GraphicsManager.GetInstance().MapGround;
			mCurContainer.addChild(mBackground);
			mCurContainer.addChild(mLogo);
			mLogo.x = GameProperties.SCREENWIDTH/2 - mLogo.width/2;
			mLogo.y = -mLogo.height;
			mLogoYSpeed = 0;
			mPower = 1;
			mMaxY = GameProperties.SCREENHEIGHT / 2 - mLogo.height;
			mBGM.Play(true);
		}
		
		public override function UpdateKeyboard(event:KeyboardEvent):void
		{
			
		}
		public override function UpdateMouse(event:MouseEvent):void
		{
			
		}
		public function AnimateTitle():void
		{
			if (mLogo.y<mMaxY)
			{
				mLogoYSpeed+=mPower;
				if (mLogoYSpeed>30)
					mLogoYSpeed = 30;
			}
			else
			{
				mLogo.y = mMaxY;
				if (mLogoYSpeed<0.4)
				{
					MenuManager.GetInstance().ToggleMenu(MenuManager.MAINMENU);
					mMenuReady = true;
					mLogoYSpeed = 0;
				}
				else
				{
					mLogoYSpeed = -Math.floor(mLogoYSpeed)/2;
					
				}
			}
			mLogo.y += mLogoYSpeed;
		}
		public override function Update():void
		{
			if(!mMenuReady)
			{
				AnimateTitle();
			}
		}
		public override function Cleanup():void
		{
			mBGM.Stop();
			mCurContainer.removeChild(mBackground);
			mCurContainer.removeChild(mLogo);
			//when we exit this menu state, we unset the menu
			MenuManager.GetInstance().UnSetCurrentMenu();
		}
	}
	
}