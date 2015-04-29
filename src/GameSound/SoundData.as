package GameSound {
	

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.events.Event;
	public class SoundData
	{
		//this class stores data about sound, like the sound name and type.
		public var mName:String;
		public var mType:String;
		private var mSound:Sound;
		private var mChannel:SoundChannel;
		public var IsPlaying:Boolean;
		private var mLoop:Boolean;
		public function SoundData()
		{
			
		}
		public function LoadSound(theRequest:URLRequest, theCallback:Function):void
		{
			mSound = new Sound(theRequest);
			mSound.addEventListener(Event.COMPLETE, theCallback);
		}
		public function CopyData(theSoundData:SoundData):void
		{
			theSoundData.SetData(mSound, mType);
		}
		public function SetData(theSound:Sound, thetype:String):void
		{
			mSound = theSound;
			mType = thetype;
		}
		//play the sound
		public function Play(Loop:Boolean = false):void
		{
			Stop();
			mLoop = Loop;
			mChannel = mSound.play();
			mChannel.addEventListener(Event.SOUND_COMPLETE, Replay);
			IsPlaying = true;
		}
		//play the sound again even though it is already playing
		public function PlayContinuous():void
		{
			mChannel = mSound.play();
		}
		private function Replay(event:Event):void
		{
			mChannel.removeEventListener(Event.SOUND_COMPLETE, Replay);
			if (mLoop)
			{
				mChannel.stop();
				mChannel = mSound.play(0,0);
				mChannel.addEventListener(Event.SOUND_COMPLETE, Replay);
			}
			else
			{
				IsPlaying = false;
			}
		}
		public function Stop():void
		{
			IsPlaying = false;
			if (mChannel != null)
			{
				mChannel.stop();
				if (mChannel.hasEventListener(Event.SOUND_COMPLETE))
					mChannel.removeEventListener(Event.SOUND_COMPLETE, Replay);
				mChannel = null;
			}
		}
	}
	
}