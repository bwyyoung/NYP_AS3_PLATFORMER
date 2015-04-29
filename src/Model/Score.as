package Model {
	import flash.net.SharedObject;
	/**
	* ...
	* @author Default
	*/
	public class Score 
	{
		private static var privatecall:Boolean;
		private var mSharedObject:SharedObject;
		private var mCurrentScore:int;
		private var mCurrentNumLives:int;
		private var mLevels:Array;
		private var mCurrentPlayerData:Array;
		public var mCurrentLevel:String;
		public function Score() 
		{
			Init();
		}

		public function Init():void
		{
			mCurrentLevel = "No Name";
			mSharedObject = SharedObject.getLocal("MarioSaveData");
			mSharedObject.clear();
			if (mSharedObject.data.LevelScore == undefined)
			{
				mLevels = new Array;
				mCurrentPlayerData = new Array;
			}
			else
			{
				mLevels = mSharedObject.data.LevelScore;
			}
			if (mSharedObject.data.PlayerData == undefined)
			{
				mCurrentPlayerData = new Array(2);
				mCurrentPlayerData[0] = "Player";
				mCurrentNumLives = 3;
				mCurrentPlayerData[1] = mCurrentNumLives;
				mSharedObject.data.PlayerData = mCurrentPlayerData;
			}
			else
			{
				mCurrentPlayerData = mSharedObject.data.PlayerData;
				mCurrentNumLives = mCurrentPlayerData[1];
			}
			mCurrentScore = 0;
		}
		public function ResetScore():void
		{
			mCurrentScore = 0;
		}
		public function AddLife(theLife:int):void
		{
			mCurrentNumLives += theLife;
		}
		public function GetLives():int
		{
			return mCurrentNumLives;
		}
		public function AddScore(theScore:int):void
		{
			mCurrentScore += theScore;
			SetHighScore(mCurrentLevel);
		}
		public function GetScore():int
		{
			return mCurrentScore;
		}
		public function InitLevel(theLevelName:String):void
		{
			mCurrentLevel = theLevelName;
			
			for (var i:int = 0; i < mLevels.length; i++ )
				if (mLevels[i][0] == theLevelName)
				{
					break;
				}
			if (i == mLevels.length)
			{
				var NewLevel:Array = new Array(11);
				NewLevel[0] = theLevelName; //the first slot in newlevel is for the 
				for (i = 1; i < NewLevel.length; i++)
				{
					NewLevel[i] = new Array(2);//This Stores the player name in slot 1, and the score in slot 2
					NewLevel[i][0] = "Nil";
					NewLevel[i][1] = 0;
				}
				mLevels.push(NewLevel);
			}				
		}
		public function GetHighScore(theLevelName:String):int
		{
			var NewLevel:Array;
			for (var i:int = 0; i < mLevels.length; i++ )
				if (mLevels[i][0] == theLevelName)
				{
					NewLevel = mLevels[i];
					return NewLevel[1][1];
				}
			if (i == mLevels.length)
			{
				NewLevel = new Array(11);
				NewLevel[0] = theLevelName; //the first slot in newlevel is for the 
				for (i = 1; i < NewLevel.length; i++)
				{
					NewLevel[i] = new Array(2);//This Stores the player name in slot 1, and the score in slot 2
					NewLevel[i][0] = "Nil";
					NewLevel[i][1] = 0;
				}
				//NewLevel[1] = mCurrentScore;
				mLevels.push(NewLevel);
			}	
			return mCurrentScore;
		}
		public function SetHighScore(theLevelName:String):void
		{
			var NewLevel:Array;
			var ScoreIndex:int = -1;
			for (var i:int = 0; i < mLevels.length; i++ )
			{
				if (mLevels[i][0] == theLevelName)
				{
					NewLevel = mLevels[i];
				}
			}
			
			for (i = 1; i < NewLevel.length; i++)
			{ 
				if (mCurrentScore >= NewLevel[i][1])
				{
					ScoreIndex = i;
					break;
				}
			}
			if (ScoreIndex >= 0)
			{
				for (i = NewLevel.length-1; i > ScoreIndex; i--)
				{ 
					NewLevel[i][0] = NewLevel[i - 1][0];//transferring player name
					NewLevel[i][1] = NewLevel[i - 1][1];//transferring player Score
				}
				NewLevel[ScoreIndex][0] = mCurrentPlayerData[0];
				NewLevel[ScoreIndex][1] = mCurrentScore;
			}
		}
		public function CleanUp():void
		{
			mCurrentPlayerData[1] = mCurrentNumLives;
			mSharedObject.data.PlayerData = mCurrentPlayerData;
			mSharedObject.data.LevelScore = mLevels;
			mSharedObject.flush();
		}
	}
	
}