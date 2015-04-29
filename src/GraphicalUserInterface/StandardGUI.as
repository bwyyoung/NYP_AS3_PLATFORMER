package GraphicalUserInterface {
	
	import GraphicalUserInterface.GUI;
	import flash.display.DisplayObjectContainer;
	import Model.Score;
	import Managers.TextManager;
	import Managers.GraphicsManager;
	import Managers.EntityManager;
	import Animations.AnimationSet;
	import Properties.GameProperties;
	/**
	* ...
	* @author Default
	*/
	public class StandardGUI extends GUI{
		
		private var mCoin1:AnimationSet;
		private var mCoin2:AnimationSet;
		private var mCoin3:AnimationSet;
		private var mCoin4:AnimationSet;
		private var mMarioLives:AnimationSet;
		
		public var mLevelName:String;
		private var mScore:Score;
		private var mScoreText:uint;
		private var mHighScoreText:uint;
		private var mLivesText:uint;
		private var mCurrentScoreDescriptionText:uint;
		private var mHighScoreDescriptionText:uint;
		private var mDigitLimit:int;
		private var mCurContainer:DisplayObjectContainer;
		

		
		
		public function StandardGUI() 
		{
			
		}
		public function AddLives(theLives:int):void
		{
			mScore.AddLife(theLives);
			var numLives:int  = mScore.GetLives();
			TextManager.GetInstance().SetText(mLivesText, "x" + numLives);
		}
		public function SetCurrentLevel(theLevelName:String):void
		{
			mScore.mCurrentLevel = theLevelName;
		}
		public override function Init():void
		{
			mCurContainer = GraphicsManager.GetInstance().ForeGround;
			mCoin1 = EntityManager.GetInstance().GetAnimationSet("YellowCoin");
			mCoin2 = EntityManager.GetInstance().GetAnimationSet("YellowCoin");
			mCoin3 = EntityManager.GetInstance().GetAnimationSet("BlueCoin");
			mCoin4 = EntityManager.GetInstance().GetAnimationSet("BlueCoin");
			
			mMarioLives = EntityManager.GetInstance().GetAnimationSet("MarioHead");
			
			mLevelName = "No Name";
			mDigitLimit = 6;
			mScore = new Score();
			mScore.InitLevel(mScore.mCurrentLevel);
			mScoreText = TextManager.GetInstance().CreateText("", 0, 0,50);
			mHighScoreText = TextManager.GetInstance().CreateText("", 0, 0, 50);
			mLivesText = TextManager.GetInstance().CreateText("", 0, 0, 50);
			mHighScoreDescriptionText = TextManager.GetInstance().CreateText("hi score", 0, 0, 50);
			mCurrentScoreDescriptionText = TextManager.GetInstance().CreateText("score", 0, 0, 50);
			
			AddScore(0);
			AddLives(0);
			
			TextManager.GetInstance().SetPosition(mHighScoreDescriptionText, 
			GameProperties.SCREENWIDTH - GameProperties.SCREENWIDTH/24 - mCoin4.Width - 
			TextManager.GetInstance().GetWidth(mHighScoreText), 
			GameProperties.SCREENHEIGHT/48);
			
			TextManager.GetInstance().SetPosition(mCurrentScoreDescriptionText,
			GameProperties.SCREENWIDTH / 2 - 
			TextManager.GetInstance().GetWidth(mScoreText) / 2 , 
			GameProperties.SCREENHEIGHT/48);
			
			TextManager.GetInstance().SetPosition(mScoreText, 
			GameProperties.SCREENWIDTH / 2 - 
			TextManager.GetInstance().GetWidth(mScoreText) / 2 , 
			TextManager.GetInstance().GetY(mCurrentScoreDescriptionText)+
			TextManager.GetInstance().GetHeight(mCurrentScoreDescriptionText) +
			TextManager.GetInstance().GetHeight(mCurrentScoreDescriptionText)/10);


			
			TextManager.GetInstance().SetPosition(mHighScoreText, 
			GameProperties.SCREENWIDTH - GameProperties.SCREENWIDTH/24 - mCoin4.Width - 
			TextManager.GetInstance().GetWidth(mHighScoreText), 
			TextManager.GetInstance().GetY(mHighScoreDescriptionText)+
			TextManager.GetInstance().GetHeight(mHighScoreDescriptionText) +
			TextManager.GetInstance().GetHeight(mHighScoreDescriptionText)/10);

			TextManager.GetInstance().SetPosition(mLivesText, 
			GameProperties.SCREENWIDTH / 24 + mMarioLives.Width/5*4,
			GameProperties.SCREENHEIGHT/24);
			
			
			mMarioLives.mCurContainer 
			= mCoin1.mCurContainer 
			= mCoin2.mCurContainer 
			= mCoin3.mCurContainer 
			= mCoin4.mCurContainer 
			=  mCurContainer;
			mMarioLives.SetPosition(GameProperties.SCREENWIDTH/24 + mMarioLives.Width/2, GameProperties.SCREENHEIGHT/24 + mMarioLives.Height / 2 );
			
			mCoin1.SetPosition(TextManager.GetInstance().GetX(mScoreText) - mCoin1.Width / 2, 
			TextManager.GetInstance().GetY(mScoreText)+ mCoin1.Height/2);
			mCoin2.SetPosition(TextManager.GetInstance().GetX(mScoreText) 
			+ TextManager.GetInstance().GetWidth(mScoreText) + mCoin2.Width/2, 
			TextManager.GetInstance().GetY(mScoreText) + mCoin1.Height / 2);
			mCoin3.SetPosition(TextManager.GetInstance().GetX(mHighScoreText) - mCoin1.Width / 2, 
			TextManager.GetInstance().GetY(mHighScoreText) + mCoin1.Height / 2);
			
			mCoin4.SetPosition(GameProperties.SCREENWIDTH - GameProperties.SCREENWIDTH/24 - mCoin4.Width/2, 
			TextManager.GetInstance().GetY(mHighScoreText) + mCoin4.Height / 2);
		}
		public override function ResetData():void
		{
			mScore.ResetScore();
		}
		public override function Render():void
		{
			mMarioLives.Render();
			mCoin1.Render();
			mCoin2.Render();
			mCoin3.Render();
			mCoin4.Render();
			TextManager.GetInstance().Render(mCurrentScoreDescriptionText, mCurContainer);
			TextManager.GetInstance().Render(mHighScoreDescriptionText, mCurContainer);
			TextManager.GetInstance().Render(mLivesText, mCurContainer);
			TextManager.GetInstance().Render(mHighScoreText, mCurContainer);
			TextManager.GetInstance().Render(mScoreText, mCurContainer);
		}
		public override function CleanUp():void
		{
			UnRender();
			mScore.CleanUp();
		}
		public function AddScore(theScore:int):void
		{
			
			var scorestring:String = "";
			mScore.AddScore(theScore);
			var theCurrentScore:int = mScore.GetScore();
			var NumDigits:int = theCurrentScore.toString().length;
			
			if (NumDigits > mDigitLimit)
			{
				for (var i:int = 0; i < mDigitLimit; i++)
				{
					scorestring += "9";
				}
			}
			else
			{
				for (i = 0; i < mDigitLimit-NumDigits; i++)
				{
					scorestring += "0";
				}
				scorestring += theCurrentScore;
			}
			
			TextManager.GetInstance().SetText(mScoreText, scorestring);
			scorestring = "";
			var theHighScore:int = mScore.GetHighScore(mScore.mCurrentLevel);
			NumDigits = theHighScore.toString().length;
			if (NumDigits > mDigitLimit)
			{
				for (i = 0; i < mDigitLimit; i++)
				{
					scorestring += "9";
				}
			}
			else
			{
				for (i = 0; i < mDigitLimit-NumDigits; i++)
				{
					scorestring += "0";
				}
				scorestring += theHighScore;
			}
			TextManager.GetInstance().SetText(mHighScoreText, scorestring);
		}
		public override function UnRender():void
		{
			mMarioLives.UnRender();
			mCoin1.UnRender();
			mCoin2.UnRender();
			mCoin3.UnRender();
			mCoin4.UnRender();
			TextManager.GetInstance().UnRender(mCurrentScoreDescriptionText);
			TextManager.GetInstance().UnRender(mHighScoreDescriptionText);
			TextManager.GetInstance().UnRender(mHighScoreText);
			TextManager.GetInstance().UnRender(mLivesText);
			TextManager.GetInstance().UnRender(mScoreText);
		}
		
	}
	
}