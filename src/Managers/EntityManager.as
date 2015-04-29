package Managers 
{
	import Animations.Animation;
	import Animations.AnimationSet;
	import Enemies.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import flash.display.Loader;
	import flash.geom.*;
	import flash.media.*;
	import Item.*;
	import Model.Entity;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.utils.*;
	

	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class EntityManager 
	{
		private static var instance:EntityManager;
		private static var privatecall:Boolean;
		public var LoadComplete:Boolean = false;
		private var CurrentName:String;
		private var AnimationSetsArray:Array;//this stores various types of AnimationSet, like redturtles and blueturtles
		private var CompletedSets:int = 0;

		
		//this class manages all entities in the game
		public function GetAnimationSet(theSetName:String):AnimationSet
		{
			for each (var a:AnimationSet in AnimationSetsArray)
			{
				if (a.mName == theSetName)
				{
					var result:AnimationSet = new AnimationSet();
					a.CopyData(result);
					return result;
				}
			}
			return AnimationSetsArray[0];
		}
		public function EntityManager() 
		{
			if (!privatecall)
			{
				throw new Error("This is Singleton Class");
			}
			else
			{
				Init();
			}
		}
		public static function GetInstance():EntityManager
		{
			if (instance == null)
			{
				privatecall = true;
				EntityManager.instance = new EntityManager();
				privatecall = false;
			}
			return EntityManager.instance;
		}

		private function Init():void
		{
			AnimationSetsArray = new Array();
			LoadManager.getInstance().RequestLoad(new URLRequest("Entities.xml"), "Entity Information", EntitiesLoaded);
		}

		public function Cleanup():void
		{

		}
		//when all the data has been loaded from xml, call this function
		private function EntitiesLoaded(evt:Event):void
		{
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var Anim:Animation;
			var AnimSet:AnimationSet;
			var data:XML = new XML(evt.target.data);
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(data.toXMLString());
			var numEnemies:int = data.enemies.enemies.length();
			var numItems:int  = data.items.item.length();
			var numPlayers:int = data.players.player.length();
			var numAssets:int =  data.minigames.asset.length();
			
			//load in player data
			for (i = 0; i < data.players.player.length(); i++)
			{
				AnimSet = new AnimationSet();
				AnimSet.mName = data.players.player[i].@name;
				LoadManager.getInstance().RequestLoad(new URLRequest(data.players.Directory.@name + 
				data.players.player[i].@name + "/" + data.players.player[i].@name + ".png"), data.players.player[i].@name, LoadFrames);
				for (j = 0; j < data.players.player[i].Animation.length(); j++)
				{
					Anim= new Animation(data.players.player[i].Animation[j].Framerate, data.players.player[i].Animation[j].Loop);
					Anim.framewidth = data.players.player[i].width;
					Anim.frameheight = data.players.player[i].height;
					Anim.mName = data.players.player[i].Animation[j].@name;
					for (k = 0; k < data.players.player[i].Animation[j].Frame.length(); k++)
					{
						Anim.mFramePoints.push(data.players.player[i].Animation[j].Frame[k]);
					}
					AnimSet.AddAnimation(Anim);
				}
				AnimationSetsArray.push(AnimSet);
			}
			
			//load in enemy data
			for (i = 0; i < numEnemies; i++)
			{
				for (j = 0; j < data.enemies.enemies[i].enemy.length(); j++)
				{
					AnimSet = new AnimationSet();
					AnimSet.mName = data.enemies.enemies[i].enemy[j].@name;
					AnimSet.mType = data.enemies.enemies[i].@type;
					try
					{
						LoadManager.getInstance().RequestLoad(new URLRequest(data.enemies.Directory.@name +data.enemies.enemies[i].@name+"/" +
						data.enemies.enemies[i].enemy[j].@name + "/" + data.enemies.enemies[i].enemy[j].@name + ".png"),
						data.enemies.enemies[i].enemy[j].@name, LoadFrames);
					}
					catch(errObject:Error)
					{
						trace(data.enemies.Directory.@name);
					}
					for (k = 0; k < data.enemies.enemies[i].Animation.length(); k++)
					{
						Anim = new Animation(data.enemies.enemies[i].Animation[k].Framerate,
						data.enemies.enemies[i].Animation[k].Loop);
						Anim.framewidth = data.enemies.enemies[i].width;
						Anim.frameheight = data.enemies.enemies[i].height;
						Anim.mName = data.enemies.enemies[i].Animation[k].@name;
						for (l = 0; l < data.enemies.enemies[i].Animation[k].Frame.length(); l++)
						{
							Anim.mFramePoints.push(data.enemies.enemies[i].Animation[k].Frame[l]);
						}
						AnimSet.AddAnimation(Anim);
					}
					AnimationSetsArray.push(AnimSet);
				}
			}
			//load in item data
			for (i = 0; i < numItems; i++)
			{
				for (j = 0; j < data.items.item[i].item.length(); j++)
				{
					AnimSet = new AnimationSet();
					AnimSet.mName = data.items.item[i].item[j].@name;
					AnimSet.mType = data.items.item[i].@type;		
					LoadManager.getInstance().RequestLoad(new URLRequest(data.items.Directory.@name+ data.items.item[i].@name +"/"+
					data.items.item[i].item[j].@name + "/" + data.items.item[i].item[j].@name + ".png"),
					data.items.item[i].item[j].@name, LoadFrames);

					for (k = 0; k < data.items.item[i].Animation.length(); k++)
					{
						Anim = new Animation(data.items.item[i].Animation[k].Framerate,
						data.items.item[i].Animation[k].Loop);
						Anim.framewidth = data.items.item[i].width;
						Anim.frameheight = data.items.item[i].height;
						Anim.mName = data.items.item[i].Animation[k].@name;
						for (l = 0; l < data.items.item[i].Animation[k].Frame.length(); l++)
						{
							Anim.mFramePoints.push(data.items.item[i].Animation[k].Frame[l]);
						}
						AnimSet.AddAnimation(Anim);
					}
					AnimationSetsArray.push(AnimSet);
				}
			}

			//Load in sprite data for minigames
			for (i = 0; i < numAssets; i++)
			{
				for (j = 0; j < data.minigames.asset[i].asset.length(); j++)
				{
					AnimSet = new AnimationSet();
					
					AnimSet.mName = data.minigames.asset[i].asset[j].@name;

					AnimSet.mType = data.minigames.asset[i].@type;		
					var Extension:String = data.minigames.asset[i].extension;
					AnimSet.mHighlightColor =parseInt(data.minigames.asset[i].asset[j].color,16); //push in the highlighted colors specified from the file									
					LoadManager.getInstance().RequestLoad(new URLRequest(data.minigames.Directory.@name+ data.minigames.asset[i].@name +"/"+
					data.minigames.asset[i].asset[j].@name + "/" + data.minigames.asset[i].asset[j].@name + Extension),
					data.minigames.asset[i].asset[j].@name, LoadFrames);

					for (k = 0; k < data.minigames.asset[i].Animation.length(); k++)
					{
						Anim = new Animation(data.minigames.asset[i].Animation[k].Framerate,
						data.minigames.asset[i].Animation[k].Loop);
						Anim.framewidth = data.minigames.asset[i].width;
						Anim.frameheight = data.minigames.asset[i].height;
						Anim.mName = data.minigames.asset[i].Animation[k].@name;
						for (l = 0; l < data.minigames.asset[i].Animation[k].Frame.length(); l++)
						{
							Anim.mFramePoints.push(data.minigames.asset[i].Animation[k].Frame[l]);
						}
						AnimSet.AddAnimation(Anim);
					}
					AnimationSetsArray.push(AnimSet);
				}
			}
			var timer:uint = setInterval(LoadCheck, 50);
			
			function LoadCheck():void
			{
				if (CompletedSets
				>= numPlayers+numEnemies+numItems + numAssets)
				{
					LoadComplete = true;
					clearInterval(timer);
				}
			}
		}
		//when all the image data, has been loaded, process it here
		public function LoadFrames(evt:Event):void
		{
			var b:Bitmap = evt.currentTarget.content;

			for (var i:int = 0; i < AnimationSetsArray.length; i++)
			{
				if (AnimationSetsArray[i].mName == evt.currentTarget.content.parent.name)
					break;
			}
			if (i < AnimationSetsArray.length)
			{
				for (var j:int = 0; j < AnimationSetsArray[i].mAnimationsArray.length; j++)
				{			
					var Anim:Animation = AnimationSetsArray[i].mAnimationsArray[j];
					for (var k:int = 0; k < Anim.mFramePoints.length; k++ )
					{
						var rect:Rectangle = new Rectangle(Anim.mFramePoints[k] * Anim.framewidth, 0, 
						Anim.mFramePoints[k] * Anim.framewidth + Anim.framewidth, b.height);
						var a:BitmapData = new BitmapData(Anim.framewidth,b.height);
						var pt:Point = new Point(0, 0);
						a.copyPixels(b.bitmapData, rect, pt);
						Anim.AddFrame(new Bitmap(a));
					}
				}
				CompletedSets++;
			}
		}
	}
	
}