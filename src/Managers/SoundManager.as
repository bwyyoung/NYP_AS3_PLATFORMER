package Managers {
	
	/**
	* ...
	* @author Default
	*/
	import flash.media.Sound;
	import flash.events.Event;
	import Managers.LoadManager;
	import flash.utils.*;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import GameSound.SoundData;
	
	public class SoundManager {
		public var LoadComplete:Boolean = false;
		private var SoundsLoaded:int = 0;
		private var TotalSounds:int = 0;
		private var mSoundArray:Array;
		private static var instance:SoundManager;
		private static var privatecall:Boolean;
		public function SoundManager() 
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
		public static function GetInstance():SoundManager
		{
			if (instance == null)
			{
				privatecall = true;
				SoundManager.instance = new SoundManager();
				privatecall = false;
			}
			return SoundManager.instance;
		}
		public function GetSound(theName:String, theType:String):SoundData
		{
			var temp:SoundData = new SoundData();
			for (var i:int = 0; i < mSoundArray.length; i++)
			{
				if (mSoundArray[i].mName == theName)
					if (mSoundArray[i].mType == theType)
						break;
			}
			if (i < mSoundArray.length)
			{
				var thedata:SoundData = mSoundArray[i];
				thedata.CopyData(temp);
				temp.mName = thedata.mName;
			}
			return temp;
		}
		private function Init():void
		{
			mSoundArray = new Array();
			
			LoadComplete = false;
			LoadManager.getInstance().RequestLoad(new URLRequest("Sounds.xml"), "Sound Information", SoundInfoLoaded);
		}
		private function SoundInfoLoaded(evt:Event):void
		{
			var i:int;
			var j:int;
			var ext:String;
			var data:XML = new XML(evt.target.data);
			var doc:XMLDocument = new XMLDocument();
			doc.ignoreWhite = true;
			doc.parseXML(data.toXMLString());
			var numSoundTypes:int = data.Sound.length();
			var theDirectory:String = data.Directory.@name;
			
			for (i = 0; i < numSoundTypes; i++)
			{
				for (j = 0; j < data.Sound[i].Sound.length(); j++ )
				{
					var CurData:SoundData = new SoundData();
					CurData.LoadSound(
					new URLRequest(theDirectory+data.Sound[i].@type + "/" + 
					data.Sound[i].Sound[j].@name + 
					data.Sound[i].extension), SoundDataLoaded);
					CurData.mName = data.Sound[i].Sound[j].@name;
					CurData.mType = data.Sound[i].@type;
					TotalSounds++;
					mSoundArray.push(CurData);
				}
			}
			var timer:uint = setInterval(LoadCheck, 50);
			function LoadCheck():void
			{
				if (SoundsLoaded
				>= TotalSounds)
				{
					LoadComplete = true;
					clearInterval(timer);
				}
			}
		}
		private function SoundDataLoaded(evt:Event):void
		{
			SoundsLoaded++;
		}
	}
}

