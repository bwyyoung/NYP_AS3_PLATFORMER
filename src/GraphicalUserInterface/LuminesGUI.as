package GraphicalUserInterface 
{
	import fl.transitions.easing.Strong;
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import GameSound.SoundData;
	import GraphicalUserInterface.GUI;
	import Animations.AnimationSet;
	import Managers.EntityManager;
	import Model.PlayerModel;
	import Properties.GameProperties;
	import Minigames.Lumines.Properties.LuminesProperties;
	import Managers.*;
	import States.GameState;
	import Model.PlayerModel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	* ...
	* @author Default
	*/
	public class LuminesGUI extends GUI
	{
		//Order of value: Red Yellow Green Blue
		
		public static const LUMINES_NORMAL:String = "Stand";
		public static const LUMINES_COMBO:String = "Jump Up";
		public static const LUMINES_ALERT:String = "Alert";
		
		public var mCurrentState:String;
		private var mPreviousState:String;
		private var mEndGame:Boolean;
		private var mShowResults:Boolean;
		
		private var mBlueIcon:AnimationSet;
		private var mRedIcon:AnimationSet;
		private var mGreenIcon:AnimationSet;
		private var mYellowIcon:AnimationSet;
		private var mBonusGame:Bitmap;
		private var mComboBox:Bitmap;
		private var mResultsScreen:Bitmap;
		
		private var mBlueScore:int;
		private var mGreenScore:int;
		private var mRedScore:int;
		private var mYellowScore:int;
		private var mBonusGameFlash:int;
		
		private var mMaxCombo:int;
		
		private var mYMax:Number;
		private var mYSpeed:Number;
		private var JUMP:Boolean;
		
		private var mBlueScoreRef:uint;
		private var mGreenScoreRef:uint;
		private var mRedScoreRef:uint;
		private var mYellowScoreRef:uint;
		private var mComboBoxRef:uint;
		private var mComboDisplayRef:uint;
		
		private var mScoreTypes:Array;
		private var mScoresRef:Array;
		private var mScores:Array;
		private var mScoreBalls:Array;
		private var mScoreMath:Array;
		
		private var mBackground:AnimationSet;
		private var mUI:Bitmap;
		
		private var mMarioIcon:AnimationSet;
		private var mBigMarioIcon:AnimationSet;
		private var mCurMarioIcon:AnimationSet;
		
		private var mBGM:SoundData;
		private var mBGM2:SoundData;
		private var mYatah:SoundData;
		
		public function LuminesGUI() 
		{	
			mScoreTypes = new Array();
			mScoresRef = new Array();
			mScoreBalls = new Array();
			
			mBGM2 = SoundManager.GetInstance().GetSound("Win", "Music");
			mBGM = SoundManager.GetInstance().GetSound("Battle", "Music");
			mYatah = SoundManager.GetInstance().GetSound("Yatah", "FX");
			
			mBackground = EntityManager.GetInstance().GetAnimationSet("Crystal");
			mBackground.mCurContainer = GraphicsManager.GetInstance().BackGround;
			mUI = TileManager.GetInstance().GetBackground("Background", "LuminesBackground");
			mComboBox = TileManager.GetInstance().GetBackground("Combo", "ComboBox");
			mBonusGame = TileManager.GetInstance().GetBackground("Game", "BonusGame");
			mResultsScreen = TileManager.GetInstance().GetBackground("Info", "InfoScreen1");
			
			mBlueIcon = EntityManager.GetInstance().GetAnimationSet("BlueBlockIcon");
			mRedIcon = EntityManager.GetInstance().GetAnimationSet("RedBlockIcon");
			mGreenIcon = EntityManager.GetInstance().GetAnimationSet("GreenBlockIcon");
			mYellowIcon = EntityManager.GetInstance().GetAnimationSet("YellowBlockIcon");
			
			mScoreBalls.push(EntityManager.GetInstance().GetAnimationSet("RedBlockIcon"));
			mScoreBalls.push(EntityManager.GetInstance().GetAnimationSet("YellowBlockIcon"));
			mScoreBalls.push(EntityManager.GetInstance().GetAnimationSet("GreenBlockIcon"));
			mScoreBalls.push(EntityManager.GetInstance().GetAnimationSet("BlueBlockIcon"));
			
			
			mMarioIcon = EntityManager.GetInstance().GetAnimationSet("MarioIcon");
			mBigMarioIcon = EntityManager.GetInstance().GetAnimationSet("BigMarioIcon");
			
			mCurMarioIcon = mMarioIcon;
			
			mScoreTypes.push(LuminesProperties.RED);
			mScoreTypes.push(LuminesProperties.YELLOW);
			mScoreTypes.push(LuminesProperties.GREEN);
			mScoreTypes.push(LuminesProperties.BLUE);
			
			mScores = new Array(mScoreTypes.length);
			mScoreMath = new Array(mScoreTypes.length);
			for (var i:int = 0; i < mScoreMath.length; i++)
			{
				mScoreMath[i] = new Array(2);
				for (var j:int = 0; j < mScoreMath[i].length; j++)
				{
					mScoreMath[i][j] = TextManager.GetInstance().CreateText("", 0, 0, 60);
				}
			}
			
			mBlueScoreRef = TextManager.GetInstance().CreateText("x0",0,0,20);
			mRedScoreRef = TextManager.GetInstance().CreateText("x0",0,0,20);
			mGreenScoreRef = TextManager.GetInstance().CreateText("x0",0,0,20);
			mYellowScoreRef = TextManager.GetInstance().CreateText("x0", 0, 0, 20);
			mComboBoxRef = TextManager.GetInstance().CreateText("0", 0, 0, 50);
			mComboDisplayRef = TextManager.GetInstance().CreateText("", 0, 0, 20);
			
			mScoresRef.push(mRedScoreRef);
			mScoresRef.push(mYellowScoreRef);;
			mScoresRef.push(mGreenScoreRef);
			mScoresRef.push(mBlueScoreRef);
			
			ResetData();
		}
		public override function Init():void 
		{
			super.Init();
			
			ResetData();
			
			mBackground.SetPosition(GameProperties.SCREENWIDTH/2, GameProperties.SCREENHEIGHT/2);

			mUI.x = GameProperties.SCREENWIDTH/2- mUI.width/2;
			mUI.y = GameProperties.SCREENHEIGHT/2- mUI.height/2;
			
			mBonusGame.x = mUI.x + mUI.width/2 - mBonusGame.width/2;
			mBonusGame.y = mUI.y - mUI.height/16 - mBonusGame.height/2;
			
			mRedIcon.SetPosition(GameProperties.SCREENWIDTH/2- mUI.width/2 + 151,
			GameProperties.SCREENHEIGHT/2- mUI.height/2 +398);//top
			
			mGreenIcon.SetPosition(GameProperties.SCREENWIDTH/2- mUI.width/2 + 151,
			GameProperties.SCREENHEIGHT/2- mUI.height/2 + 500);//bottom
			
			mBlueIcon.SetPosition(GameProperties.SCREENWIDTH/2- mUI.width/2 + 58,
			GameProperties.SCREENHEIGHT/2- mUI.height/2 + 450);//left
			
			mYellowIcon.SetPosition(GameProperties.SCREENWIDTH/2- mUI.width/2 + 246,
			GameProperties.SCREENHEIGHT/2- mUI.height/2 + 450);//right
						
			TextManager.GetInstance().SetPosition(mRedScoreRef,mRedIcon.mX - TextManager.GetInstance().GetWidth(mRedScoreRef)/2,mRedIcon.mY + mRedIcon.Height/2);//top
			TextManager.GetInstance().SetPosition(mBlueScoreRef, mBlueIcon.mX- TextManager.GetInstance().GetWidth(mBlueScoreRef)/2, mBlueIcon.mY + mBlueIcon.Height / 2);//left
			TextManager.GetInstance().SetPosition(mYellowScoreRef,mYellowIcon.mX- TextManager.GetInstance().GetWidth(mYellowScoreRef)/2,mYellowIcon.mY + mYellowIcon.Height/2);
			TextManager.GetInstance().SetPosition(mGreenScoreRef , mGreenIcon.mX - TextManager.GetInstance().GetWidth(mGreenScoreRef)/2, mGreenIcon.mY + mGreenIcon.Height / 2);
			TextManager.GetInstance().SetPosition(mComboDisplayRef, 
			LuminesProperties.GetInstance().StackOffsetX - TextManager.GetInstance().GetWidth(mComboDisplayRef),
			LuminesProperties.GetInstance().StackOffsetY + LuminesProperties.GetInstance().QuadSize*LuminesProperties.GetInstance().BlockSize);
			
			mMarioIcon.SetPosition(
			LuminesProperties.GetInstance().StackOffsetX - mMarioIcon.Width/2 -mMarioIcon.Width/4,
			LuminesProperties.GetInstance().StackSize *
			LuminesProperties.GetInstance().BlockSize *
			LuminesProperties.GetInstance().QuadSize + 
			LuminesProperties.GetInstance().StackOffsetY - mMarioIcon.Height / 2 
			+ LuminesProperties.GetInstance().BlockSize/2);
			
			mBigMarioIcon.SetPosition(
			LuminesProperties.GetInstance().StackOffsetX - mBigMarioIcon.Width/2,
			LuminesProperties.GetInstance().StackSize *
			LuminesProperties.GetInstance().BlockSize *
			LuminesProperties.GetInstance().QuadSize + 
			LuminesProperties.GetInstance().StackOffsetY - mBigMarioIcon.Height / 2
			+ LuminesProperties.GetInstance().BlockSize/2);
		}
		public override function CleanUp():void 
		{
			super.CleanUp();
		}
		public override function Update():void 
		{
			super.Update();
			if (!mEndGame)
			{
				mBonusGameFlash++;
				if (mBonusGameFlash >= GameProperties.FPS)
				{
					mBonusGameFlash = 0;
					if (GraphicsManager.GetInstance().ForeGround.contains(mBonusGame))
						GraphicsManager.GetInstance().ForeGround.removeChild(mBonusGame);
					else if (!GraphicsManager.GetInstance().ForeGround.contains(mBonusGame))
						GraphicsManager.GetInstance().ForeGround.addChild(mBonusGame);
				}
				
				if (JUMP)
				{
					if (mCurMarioIcon.mY + mYSpeed> mYMax)
					{
						mYSpeed = 0;
						mCurrentState = mPreviousState;
						mCurMarioIcon.PlayAnimation(mPreviousState);
						mCurMarioIcon.SetPosition(mCurMarioIcon.mX, mYMax);
						TextManager.GetInstance().UnRender(mComboDisplayRef);
						JUMP = false;
					}
					else
					{
						mYSpeed += 1;
						if (mYSpeed >= 0)
							if (mCurMarioIcon.mCurrentAnimName != "Jump Down")
								mCurMarioIcon.PlayAnimation("Jump Down");
						if (mYSpeed > 7)
							mYSpeed = 7;
						mCurMarioIcon.SetPosition(mCurMarioIcon.mX, mCurMarioIcon.mY + mYSpeed);
					}
				}
			}
			else
			{
				mYSpeed += 1;

				if (mYSpeed > 10)
					mYSpeed = 10;
				if (mResultsScreen.y + mResultsScreen.height/2>GameProperties.SCREENHEIGHT/2)
				{
					if (!mShowResults)
					{
						mShowResults = true;
						ShowResults();
					}
				}
				else
				{
					mResultsScreen.y += mYSpeed;
				}
			}
		}
		private function ShowResults():void
		{
			for (var i:int = 0; i < mScoreBalls.length; i++)
			{
				var tempanim:AnimationSet = mScoreBalls[i];
				tempanim.SetPosition(mResultsScreen.x + mResultsScreen.width / 4,
				mResultsScreen.y + tempanim.Height/2 + mResultsScreen.height/20 
				+ i * tempanim.Height  + i*(mResultsScreen.height/80));
				tempanim.Render(GraphicsManager.GetInstance().ForeGround);
				
				TextManager.GetInstance().SetText(mScoreMath[i][0], String(mScores[i]));
				TextManager.GetInstance().SetColor(mScoreMath[i][0], 128, 224, 176);
				TextManager.GetInstance().SetPosition(mScoreMath[i][0],
				tempanim.mX - tempanim.Width/2 - TextManager.GetInstance().GetWidth(mScoreMath[i][0]),
				tempanim.mY - tempanim.Height/2);
				TextManager.GetInstance().Render(mScoreMath[i][0], GraphicsManager.GetInstance().ForeGround);

				TextManager.GetInstance().SetText(mScoreMath[i][1], "x"+ String(i*10+10) + "="+String(mScores[i]*(i*10+10)));
				TextManager.GetInstance().SetColor(mScoreMath[i][1], 128, 224, 176);
				TextManager.GetInstance().SetPosition(mScoreMath[i][1],
				tempanim.mX + tempanim.Width/2 + TextManager.GetInstance().GetWidth(mScoreMath[i][1])/20,
				tempanim.mY - tempanim.Height/2);
				TextManager.GetInstance().Render(mScoreMath[i][1], GraphicsManager.GetInstance().ForeGround);
			}
			var theTimer:Timer = new Timer(3000, 1);
			theTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ReturnToMainGame);
			theTimer.start();
		}
		public function ReturnToMainGame(evt:TimerEvent):void
		{
			StateManager.GetInstance().RenderPreviousState();
		}
		public function EndGame():void
		{
			mBGM.Stop();
			mBGM2.Play(true);
			mBlueIcon.Stop();
			mRedIcon.Stop();
			mGreenIcon.Stop();
			mYellowIcon.Stop();
			mBackground.Stop();
			mMarioIcon.Stop();
			mBigMarioIcon.Stop();
			mCurMarioIcon.Stop();
			
			mYSpeed = 0;
			if (!GraphicsManager.GetInstance().ForeGround.contains(mResultsScreen))
				GraphicsManager.GetInstance().ForeGround.addChild(mResultsScreen);
			mResultsScreen.x = GameProperties.SCREENWIDTH/2 - mResultsScreen.width/2;
			mResultsScreen.y = -mResultsScreen.height;
			mEndGame = true;
		}
		public function SetAlertState(thestate:String):void
		{
			if (mCurrentState == LUMINES_COMBO)
			{
				mPreviousState = thestate;
			}
			else
			{
				switch(thestate)
				{
					case LUMINES_NORMAL:
						mCurMarioIcon.PlayAnimation(LUMINES_NORMAL);
					break;
					case LUMINES_COMBO:
						mYatah.Play();
						mPreviousState = mCurrentState;
						JUMP = true;
						mCurMarioIcon.PlayAnimation(LUMINES_COMBO);
						mYSpeed = -15;
						TextManager.GetInstance().SetText(mComboDisplayRef, String(int(mMaxCombo /
						(LuminesProperties.GetInstance().QuadSize*LuminesProperties.GetInstance().QuadSize)))+"X Combo!");
						TextManager.GetInstance().SetPosition(mComboDisplayRef, 
						LuminesProperties.GetInstance().StackOffsetX - TextManager.GetInstance().GetWidth(mComboDisplayRef)-TextManager.GetInstance().GetWidth(mComboDisplayRef)/10
						+ TextManager.GetInstance().GetWidth(mComboDisplayRef)/20,
						LuminesProperties.GetInstance().StackOffsetY + LuminesProperties.GetInstance().QuadSize 
						* LuminesProperties.GetInstance().BlockSize - TextManager.GetInstance().GetHeight(mComboDisplayRef)*2);
						TextManager.GetInstance().Render(mComboDisplayRef, GraphicsManager.GetInstance().ForeGround);
					break;
					case LUMINES_ALERT:
						mCurMarioIcon.PlayAnimation(LUMINES_ALERT);
					break;
					default:
					break;
				}
				mCurrentState = thestate;
			}
		}
		public function CheckCombo():void
		{
			if (mMaxCombo >= LuminesProperties.GetInstance().MaxCombo)
			{
				SetAlertState(LUMINES_COMBO);
			}
			mMaxCombo = 0;
			TextManager.GetInstance().SetText(mComboBoxRef, String(mMaxCombo));
		}
		public function SetComboBoxPosition(X:Number, Y:Number):void
		{
			mComboBox.x = X-mComboBox.width/2 -mComboBox.width/10;
			mComboBox.y = Y - mComboBox.height;
			TextManager.GetInstance().SetPosition(mComboBoxRef,
			mComboBox.x + mComboBox.width - TextManager.GetInstance().GetWidth(mComboBoxRef)- mComboBox.width/10,
			mComboBox.y + mComboBox.height/10);
		}
		public function SetScore(theScoreType:int, thevalue:int):void
		{
			for (var i:int = 0; i < mScoreTypes.length; i++)
			{
				if (mScoreTypes[i] == theScoreType)
				{
					TextManager.GetInstance().SetText(mScoresRef[i], "x " + String(thevalue));
					mMaxCombo += thevalue - mScores[i];
					
					var ComboDisplay:int = mMaxCombo / (LuminesProperties.
					
					GetInstance().QuadSize * LuminesProperties.GetInstance().QuadSize);
					
					TextManager.GetInstance().SetText(mComboBoxRef, String(ComboDisplay));
					
					mScores[i] = thevalue;
					break;
				}
			}
			TextManager.GetInstance().SetPosition(mBlueScoreRef,mBlueIcon.mX - TextManager.GetInstance().GetWidth(mBlueScoreRef)/2,mBlueIcon.mY + mBlueIcon.Height/2);
			TextManager.GetInstance().SetPosition(mRedScoreRef, mRedIcon.mX- TextManager.GetInstance().GetWidth(mRedScoreRef)/2, mRedIcon.mY + mRedIcon.Height / 2);
			TextManager.GetInstance().SetPosition(mGreenScoreRef,mGreenIcon.mX- TextManager.GetInstance().GetWidth(mGreenScoreRef)/2,mGreenIcon.mY + mGreenIcon.Height/2);
			TextManager.GetInstance().SetPosition(mYellowScoreRef, mYellowIcon.mX- TextManager.GetInstance().GetWidth(mYellowScoreRef)/2, mYellowIcon.mY + mYellowIcon.Height / 2);
		}
		public function GetScore(theScoreType:int):int
		{
			for (var i:int = 0; i < mScoreTypes.length; i++)
			{
				if (mScoreTypes[i] == theScoreType)
				{
					break;
				}
			}
			return mScores[i];
		}
		public override function Render():void 
		{
			ResetData();
			
			super.Render();
			mBackground.Render();
			mBackground.PlayAnimation("Spin");
			
			if (!GraphicsManager.GetInstance().ForeGround.contains(mComboBox))
				GraphicsManager.GetInstance().ForeGround.addChild(mComboBox);
				
			if (!GraphicsManager.GetInstance().ForeGround.contains(mBonusGame))
				GraphicsManager.GetInstance().ForeGround.addChild(mBonusGame);
			
			if (!GraphicsManager.GetInstance().BackGround.contains(mUI))
				GraphicsManager.GetInstance().BackGround.addChild(mUI);
			
			TextManager.GetInstance().Render(mBlueScoreRef, GraphicsManager.GetInstance().MapGround);
			TextManager.GetInstance().Render(mRedScoreRef, GraphicsManager.GetInstance().MapGround);
			TextManager.GetInstance().Render(mGreenScoreRef, GraphicsManager.GetInstance().MapGround);
			TextManager.GetInstance().Render(mYellowScoreRef, GraphicsManager.GetInstance().MapGround);
			TextManager.GetInstance().Render(mComboBoxRef, GraphicsManager.GetInstance().ForeGround);

			mRedIcon.Render(GraphicsManager.GetInstance().MapGround);
			mGreenIcon.Render(GraphicsManager.GetInstance().MapGround);
			mBlueIcon.Render(GraphicsManager.GetInstance().MapGround);
			mYellowIcon.Render(GraphicsManager.GetInstance().MapGround);
			
			if (((StateManager.GetInstance().GetState(StateManager.GAMESTATE) as GameState).GetCurrentMap().GetPlayer() as PlayerModel).mIsBig)
			{
				mCurMarioIcon = mBigMarioIcon;
			}
			else
			{
				mCurMarioIcon = mMarioIcon;
			}
			
			mYMax = mCurMarioIcon.mY;
			
			mCurMarioIcon.Render(GraphicsManager.GetInstance().MapGround);
			mCurMarioIcon.PlayAnimation(LUMINES_NORMAL);
			mBGM.Play(true);
		}
		public override function ResetData():void 
		{
			super.ResetData();
			mShowResults = false;
			mEndGame = false;
			mBonusGameFlash = 0;
			
			for each (var temp:int in mScores)
			{
				temp = 0;
			}			
			for (var i:int = 0; i < mScoreTypes.length; i++)
			{
				SetScore(mScoreTypes[i], 0);
			}
			mYSpeed = 0;
			JUMP = false;
			
			mPreviousState = mCurrentState = LUMINES_NORMAL;

			mMarioIcon.SetPosition(
			LuminesProperties.GetInstance().StackOffsetX - mMarioIcon.Width/2 -mMarioIcon.Width/4,
			LuminesProperties.GetInstance().StackSize *
			LuminesProperties.GetInstance().BlockSize *
			LuminesProperties.GetInstance().QuadSize + 
			LuminesProperties.GetInstance().StackOffsetY - mMarioIcon.Height / 2 
			+ LuminesProperties.GetInstance().BlockSize/2);
			
			mBigMarioIcon.SetPosition(
			LuminesProperties.GetInstance().StackOffsetX - mBigMarioIcon.Width/2,
			LuminesProperties.GetInstance().StackSize *
			LuminesProperties.GetInstance().BlockSize *
			LuminesProperties.GetInstance().QuadSize + 
			LuminesProperties.GetInstance().StackOffsetY - mBigMarioIcon.Height / 2
			+ LuminesProperties.GetInstance().BlockSize / 2);
			
			mMaxCombo = 0;

			TextManager.GetInstance().SetText(mComboBoxRef, String(mMaxCombo));
		}
		public override function UnRender():void 
		{

			
			super.UnRender();
			mBackground.UnRender();
			
			if (GraphicsManager.GetInstance().ForeGround.contains(mBonusGame))
				GraphicsManager.GetInstance().ForeGround.removeChild(mBonusGame);
				
			if (GraphicsManager.GetInstance().ForeGround.contains(mComboBox))
				GraphicsManager.GetInstance().ForeGround.removeChild(mComboBox);
				
			if (GraphicsManager.GetInstance().BackGround.contains(mUI))
				GraphicsManager.GetInstance().BackGround.removeChild(mUI);
			
			if (GraphicsManager.GetInstance().ForeGround.contains(mResultsScreen))
				GraphicsManager.GetInstance().ForeGround.removeChild(mResultsScreen);
			
			mRedIcon.UnRender();
			mGreenIcon.UnRender();
			mBlueIcon.UnRender();
			mYellowIcon.UnRender();
			mCurMarioIcon.UnRender();
			
			TextManager.GetInstance().UnRender(mBlueScoreRef);
			TextManager.GetInstance().UnRender(mRedScoreRef);
			TextManager.GetInstance().UnRender(mGreenScoreRef);
			TextManager.GetInstance().UnRender(mYellowScoreRef);
			TextManager.GetInstance().UnRender(mComboBoxRef);
			TextManager.GetInstance().UnRender(mComboDisplayRef);
			
			for (var i:int = 0; i < mScoreMath.length; i++)
			{
				for (var j:int = 0; j < mScoreMath[i].length; j++)
				{
					TextManager.GetInstance().UnRender(mScoreMath[i][j]);
				}
			}
			for each(var tempanim:AnimationSet in mScoreBalls)
			{
				tempanim.UnRender();
			}
			mBGM.Stop();
			mBGM2.Stop();
		}
		
	}
	
}