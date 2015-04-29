package Model 
{
	import Enemies.SmallTurtle;
	import flash.display.Bitmap;
	import View.MapNode;
	import Managers.*;
	import Model.LevelData;
	import flash.utils.*;
	import Properties.GameProperties;
	import Item.*;
	import Enemies.*;
	

	import GraphicalUserInterface.StandardGUI;
	
	//declare enemy and item classes here, otherwise they will not be defined when GetDefinitionByName() is called to look for them.
	Item.FlagPole;
	Item.Coin;
	Item.ItemBox;
	Item.Shell;
	
	Enemies.Turtle;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class controls all activities in the map during gameplay
	public class MapModel 
	{
		public static var ENUMTYPES:int = 6;
		public static var EMPTY:int = 0;
		public static var BTILE:int = 1; //background tile, has no collision detection
		public static var CTILE:int = 2; //Collidable tile, has collision detection with all entities
		public static var ENEMY:int = 3; //Enemy starting position tile.
		public static var ITEM:int  = 4; //Item starting position tile.
		public static var PLAYER:int = 5; //player starting position.
		
		private var mEntities:Array;
		private var mPlayerModel:Entity;
		private var mMapWidth:int;
		private var mMapHeight:int;
		private var mMapMinX:int; 
		private var mMapMaxX:int; //the current position of the screen in map coordinates
		private var mXOffset:Number;
		private var mMapRightLimit:int;
		private var mMapLeftLimit:int; // the limit in pixels in which mario can run left or right
		private var mTileWidth:int;
		public var mTileHeight:int;
		public var mMapArray:Array;
		public var mBackGroundArray:Array;
		public var PlayerX:int;
		public var PlayerY:int
		
		
		
		
		public function MapModel(theMapWidth:int, theMapHeight:int) 
		{
			mBackGroundArray = new Array();
			mEntities = new Array();
			mMapMinX = mMapMaxX = 0;
			mPlayerModel = new PlayerModel(EntityManager.GetInstance().GetAnimationSet("Mario"), EntityManager.GetInstance().GetAnimationSet("BigMario"));
			mMapWidth = theMapWidth;
			mMapHeight = theMapHeight;
			mMapLeftLimit = 300;
			mMapRightLimit = GameProperties.SCREENWIDTH - mMapLeftLimit;
			mTileHeight = GameProperties.TILEHEIGHT;
			mTileWidth = GameProperties.TILEWIDTH;
		}
		public function GetPlayer():Entity
		{
			return mPlayerModel;
		}
		public function Init():void
		{
			mMapMinX = mMapMaxX = 0;
			mXOffset = 0;
			mPlayerModel.Init();

			mMapArray = new Array(mMapWidth);
			for (var i:int = 0; i < mMapArray.length; i++)
			{
				mMapArray[i] = new Array(mMapHeight);
				for (var j:int = 0 ; j < mMapArray[i].length; j++)
				{
					mMapArray[i][j] = new MapNode(i, j);
					mMapArray[i][j].SetPosition(i * mTileWidth, j * mTileHeight + GameProperties.SCREENHEIGHT - GameProperties.MAPHEIGHT*GameProperties.TILEHEIGHT );
				}
			}
		}
		//the level is loaded in , along with its data
		public function LoadLevel(TheLevel:Array, theLevelData:Array):void
		{
			var i:int;
			var j:int;
			var CurrentData:LevelData;
			var CurrentNode:MapNode;
			var mEntity:Class;
			var mObject:Object;
			var TheLevelData:Array = theLevelData;
			

			var MinX:int;
			var MaxX:int;
			//check for the minimun and maximum values of the map array
			for (i = 0; i < mMapArray.length; i++)
			{
				for (j= 0; j < mMapArray[i].length; j++ )
				{
					if (mMapArray[i][j].ArrayX<MinX)
						MinX = i;
					if (mMapArray[i][j].ArrayX>MaxX)
						MaxX = i;
				}
			}
			
			for (i = 0; i < TheLevel.length; i += mMapWidth)
			{
				for (j = i%mMapWidth; j < mMapWidth; j++)
				{
					CurrentNode = mMapArray[j][i / mMapWidth];
					switch(TheLevel[i + j])
					{
						case EMPTY:
							CurrentData = TheLevelData[EMPTY][0];
						break;
						case BTILE: //this is for a background tile
							CurrentData = TheLevelData[BTILE][0];
							CurrentNode.SetTile(TileManager.GetInstance().GetTileSet(CurrentData.DataType, CurrentData.DataName).GetTileData(CurrentData.DataIndex));
							TheLevelData[BTILE].splice(0, 1);
						break;
						case CTILE: //this is for a collidable tile
							CurrentData = TheLevelData[CTILE][0];
							CurrentNode.SetTile(TileManager.GetInstance().GetTileSet(CurrentData.DataType, CurrentData.DataName).GetTileData(CurrentData.DataIndex));
							CurrentNode.mCollide = true;
							TheLevelData[CTILE].splice(0, 1);
						break;
						case ENEMY: //this is for an enemy in the game
							CurrentData = TheLevelData[ENEMY][0];
							mEntity = getDefinitionByName(CurrentData.DataType) as Class;
							mObject = new mEntity(EntityManager.GetInstance().GetAnimationSet(CurrentData.DataName)) as Entity;
							mObject.SetPosition(CurrentNode.X, CurrentNode.Y);
							AddEntity(mObject as Entity);
							TheLevelData[ENEMY].splice(0, 1);
						break;
						case ITEM: //this is for an item.
							CurrentData = TheLevelData[ITEM][0];
							mEntity = getDefinitionByName(CurrentData.DataType) as Class;
							mObject = new mEntity(EntityManager.GetInstance().GetAnimationSet(CurrentData.DataName)) as Entity;
							mObject.SetPosition(CurrentNode.X, CurrentNode.Y);
							AddEntity(mObject as Entity);
							TheLevelData[ITEM].splice(0, 1);
						break;
						case PLAYER: //this is to initiate the player's starting position
							CurrentData = TheLevelData[PLAYER][0];
							mPlayerModel.SetPosition(CurrentData.x, CurrentData.y + GameProperties.SCREENHEIGHT - GameProperties.MAPHEIGHT * GameProperties.TILEHEIGHT )
							mPlayerModel.SetMapParams(MinX,MaxX);
						break;
						default:
						throw new Error("No such entity type detected " + j);
						break;
					}
				}
				//if the current node is a collidable one, and is greater than mapmax, then set the maximum map x coordinate to be of that node
				if (CurrentNode.mCollide)
				{
					if (CurrentNode.X> mMapMaxX)
						mMapMaxX = CurrentNode.X + CurrentNode.Width;
				}
			}
			//finally, render the map
			//Render();
			//(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)).Render();
			//initialise all entities
			for each (var theEntity:Entity in mEntities)
			{
				theEntity.Init();
				theEntity.SetMapParams(MinX,MaxX);
			}
		}
		//to pause as in go to another state temporarily
		public function UnRender():void
		{
		
			(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).UnRender();
			mPlayerModel.UnRender();
			for (var i:int = 0; i < mMapArray.length; i++)
			{
				for (var j:int = 0 ; j < mMapArray[i].length; j++)
				{
					mMapArray[i][j].UnRender();
				}
			}
			for each(var mEntity:Entity in mEntities)
			{
				mEntity.UnRender();
			}	
			for each(var mbit:Bitmap in mBackGroundArray)
			{
				if (mbit.parent != null)
				{
					mbit.parent.removeChild(mbit);
				}
			}
		}
		public function Stop():void
		{
			for each (var Ent:Entity in mEntities)
			{
				Ent.Stop();
			}
		}
		public function Pause():void
		{
			for each (var Ent:Entity in mEntities)
			{
				Ent.Pause();
			}
		}
		public function Play():void
		{
			for each (var Ent:Entity in mEntities)
			{
				Ent.Play();
			}
		}
		public function AddEntity(theEntity:Entity):void
		{
			mEntities.push(theEntity);
		}
		public function RemoveEntity(theEntity:Entity):void
		{
			for (var i:int = 0; i < mEntities.length; i++)
			{
				if (mEntities[i] === theEntity)
				{
					mEntities[i].CleanUp();
					mEntities.splice(i, 1);
				}
			}
		}
		public function Render():void
		{

			mPlayerModel.Render(GraphicsManager.GetInstance().MapGround);
			(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).Render();
			//render all entities and the player

			for (var i:int = 0; i < mMapArray.length; i++ )
				for each(var node:MapNode in mMapArray[i])
				{
					node.Render(GraphicsManager.GetInstance().MapGround);
				}
			for each(var mEntity:Entity in mEntities)
			{
				mEntity.Render(GraphicsManager.GetInstance().MapGround);
			}	
			for (i = 0; i < mBackGroundArray.length; i++)
			{
				GraphicsManager.GetInstance().BackGround.addChild(mBackGroundArray[i]);
				mBackGroundArray[i].x = mBackGroundArray[i].width * i;
			}	
		}
		public function Update():void
		{
			//the update checks for the player position, and handles scrolling and parallax scrolling
			var XOffset:int;
			//let the player check for collision with his surrounding environment
			mPlayerModel.CheckCollision(mMapArray, mEntities);
			
			//if the player is greater than certain limit, then do scrolling
			if (int(mPlayerModel.mX) >= mMapRightLimit)
			{
				if (int(mPlayerModel.mX) + mMapLeftLimit<= mMapMaxX )
				{
					XOffset += mMapRightLimit - int(mPlayerModel.mX);
					mXOffset += -int(mMapRightLimit -mPlayerModel.mX);
					mPlayerModel.SetPosition(mMapRightLimit, mPlayerModel.mY);
					MoveX(XOffset);	
				}
			}
			//if the player is less than certain limit, then do scrolling
			else if (int(mPlayerModel.mX) <= mMapLeftLimit)
			{
				if (int(mPlayerModel.mX) - mMapLeftLimit >= mMapMinX)
				{
					XOffset += mMapLeftLimit - int(mPlayerModel.mX);
					mXOffset += -int(mMapLeftLimit -mPlayerModel.mX);
					mPlayerModel.SetPosition(mMapLeftLimit,mPlayerModel.mY);
					MoveX(XOffset);
				}
			}
			//check for collisions between entities, if there is, do actions to one another
			var EntityA:Entity;
			var EntityB:Entity;
			for (var i:int = 0; i <mEntities.length; i++)
			{
				EntityA = mEntities[i];
				for (var j:int = 0; j < mEntities.length; j++)
				{
					EntityB = mEntities[j];
					if (i != j)
					{
						if ( Math.abs(int(EntityA.mY)  - (int(EntityB.mY) + int(EntityB.mYSpeed))) < (EntityB.Height + EntityA.Height) / 2)
							if ( Math.abs(int(EntityA.mX)  - (int(EntityB.mX) + int(EntityB.mXSpeed))) < (EntityB.Width + EntityA.Width) / 2)
							{
								EntityA.DoAction(EntityB);
								EntityB.DoAction(EntityA);
							}
					}
				}
			}
			//also, let entity check for collision with surrounding environment
			for each (var theEntity:Entity in mEntities)
			{
				theEntity.CheckCollision(mMapArray, mEntities);
			}
		}
		public function SetBackground(theBackgroundType:String,theBackgroundName:String, numScroll:int):void
		{
			//set the background for parallax scrolling
			//numScroll specifies how many times the background should repeat when scrolling in the game
			for each(var mbit:Bitmap in mBackGroundArray)
			{
				if (mbit.parent != null)
				{
					mbit.parent.removeChild(mbit);
				}
			}
			while (mBackGroundArray.length > 0)
				mBackGroundArray.pop();
			for (var i:int = 0; i < numScroll; i++)
			{
				mBackGroundArray.push(TileManager.GetInstance().GetBackground(theBackgroundType, theBackgroundName));
				mBackGroundArray[i].x = mBackGroundArray[i].width * i;
			}	
		}
		public function MoveX(theXDelta:int):void
		{
			//when the player moves past and the map needs to scroll, this function is called
			//it does the parallax scrolling,and the map scrolling
			mMapMinX+=theXDelta;
			mMapMaxX += theXDelta;
			//move the map
			for (var i:int = 0; i < mMapArray.length; i++)
			{
				for (var j:int = 0 ; j < mMapArray[i].length; j++)
				{
					mMapArray[i][j].SetPosition(mMapArray[i][j].X + theXDelta, mMapArray[i][j].Y);
				}
			}
			//move the entities
			for each (var theEntity:Entity in mEntities)
			{
				theEntity.SetPosition(theEntity.mX + theXDelta, theEntity.mY);
			}
			//and finally, move the background
			if (mBackGroundArray.length > 0)
			{
				//this is the rightmost x coordinate of the background texture i want to position to the right of the screen
				var currentscrollx:Number = GameProperties.SCREENWIDTH +
				mXOffset / (GameProperties.MAPWIDTH * mTileWidth - GameProperties.SCREENWIDTH) * 
				(mBackGroundArray.length * mBackGroundArray[0].width -  GameProperties.SCREENWIDTH);
	
					var theCurrentBack:int = currentscrollx / mBackGroundArray[0].width;
					var theCurrentDiff:int = currentscrollx % mBackGroundArray[0].width;
					if (theCurrentBack < mBackGroundArray.length)
					{
						mBackGroundArray[theCurrentBack].x = GameProperties.SCREENWIDTH - theCurrentDiff;
						for (i = 0; i < mBackGroundArray.length; i++)
						{
							if (i != theCurrentBack)
							{
								var Delta:int = i - theCurrentBack;
								mBackGroundArray[i].x = mBackGroundArray[theCurrentBack].x + Delta * mBackGroundArray[i].width;
							}
						}
					}
				
			}
		}


		
		public function CleanUp():void
		{
			(GUIManager.GetInstance().GetGUI(GUIManager.GUI_STANDARD)as StandardGUI).CleanUp();
			//cleanup the map
			mPlayerModel.CleanUp();
			
			for each(var mEntity:Entity in mEntities)
			{
				mEntity.CleanUp();
			}
			while (mEntities.length > 0)
				mEntities.pop();
				
			for (var i:int = 0; i < mMapArray.length; i++)
			{
				for (var j:int = 0 ; j < mMapArray[i].length; j++)
				{
					mMapArray[i][j].CleanUp();
				}
				while (mMapArray[i].length > 0)
					mMapArray[i].pop();
			}
			while (mMapArray.length > 0)
				mMapArray.pop();
			for each(var mbit:Bitmap in mBackGroundArray)
			{
				if (mbit.parent != null)
				{
					mbit.parent.removeChild(mbit);
				}
			}
			while (mBackGroundArray.length > 0)
				mBackGroundArray.pop();
		}
	}
	
}