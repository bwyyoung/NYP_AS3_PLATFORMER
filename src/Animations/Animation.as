package Animations 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class stores all the information about a single animation, like walking and running
	public class Animation 
	{
		public var mName:String;//the name of this animation
		public var mKeyFrames:Array;
		public var mFramePoints:Array;
		public var ended:Boolean;
		public var STOP:Boolean;
		public var looping:Boolean;
		public var mFPS:Number;
		private var mDirection:Boolean;
		private var mCurrentFrame:int;
		private var mUTimer:Timer;
		private var mDisplayObjectContainer:DisplayObjectContainer;
		public var framewidth:int;
		public var frameheight:int;
		public var IsRendering:Boolean;
		
		public var mCallback:Function;
		public function Animation( FPS:Number = 2,Loop:Boolean = false) 
		{
			mCallback = null;
			mCurrentFrame = 0;
			looping = Loop;
			ended = false;
			mFPS  = FPS;
			mKeyFrames = new Array();
			mFramePoints = new Array();
			mUTimer = new Timer( 1 / mFPS * 1000);
			mUTimer.addEventListener(TimerEvent.TIMER, UpdateFrames);
		}
		//set the display object container for the animation
		public function SetDOC(theDisplayObjectContainer:DisplayObjectContainer):void
		{
			mDisplayObjectContainer = theDisplayObjectContainer;
		}
		//stop the animation
		public function Stop():void
		{
			STOP = true;
			ended = true;
			mUTimer.stop();
		}
		//add a frame to the animation, or more specifically a bitmap
		public function AddFrame(theImage:Bitmap):void
		{
			var a:Sprite = new Sprite;
			a.addChild(theImage);
			theImage.x = -theImage.width / 2;
			theImage.y = -theImage.height / 2;
			mKeyFrames.push(a);
		}
		//play the animation based on the starting frame, whether it should be played forwards or backwards, and the framerate
		public function Play(theStartFrame:int = 0, Direction:Boolean = true):void
		{
			mCallback = null;
			Stop();
			STOP = false;
			mCurrentFrame = theStartFrame;
			ended = false;
			IsRendering = true;
			Render(mCurrentFrame);
			for each(var a:Sprite in mKeyFrames)
				a.alpha = 1;
			IsRendering = true;
			mDirection = Direction;
			//this animation is played based on the framerate specified
			mUTimer.start();
		}
		//this is for flipping the animation when an entity changes direction
		public function SetXScale(thescale:int):void
		{
			for each (var image:Sprite in mKeyFrames)
			{
				image.scaleX = thescale;
			}
		}
		//this function is called based on the framerate, and is called using setinterval
		private function UpdateFrames(evt:TimerEvent):void
		{
			if (!STOP)
			{
				if (mDirection)
				{
					if (mKeyFrames.length == 1)
					ended = true;
					if(mCurrentFrame == mKeyFrames.length - 1 )
					{
						if (looping)
							Render(0);
					}
					else
					{
						if (mCurrentFrame + 1 == mKeyFrames.length - 1)
							ended = true;
						else
							ended = false;
						Render(mCurrentFrame + 1);
					}
				}
				else
				{
					if(mCurrentFrame == 0)
					{
						if (looping)
							Render(mKeyFrames.length - 1);
					}
					else
					{
						if (mCurrentFrame - 1 == 0)
							ended = true;
						else
							ended = false;
						Render(mCurrentFrame - 1);
					}
				}
			}
			if (mCallback != null)
				mCallback();
		}
		//render the selected frames
		private function Render(theFrame:int):void
		{

			if (!STOP && IsRendering)
			{				
				if (mDisplayObjectContainer.contains
				(mKeyFrames[mCurrentFrame]))
				{
					
					mDisplayObjectContainer.addChildAt(mKeyFrames[theFrame], mDisplayObjectContainer.getChildIndex(mKeyFrames[mCurrentFrame]));
					if (theFrame != mCurrentFrame)
						mDisplayObjectContainer.removeChild(mKeyFrames[mCurrentFrame]);
				}
				else
				{
					mDisplayObjectContainer.addChild(mKeyFrames[theFrame]);
				}
				mCurrentFrame = theFrame;
			}
		}
		//unrender all frames from this animation, in case any are left behind on screen
		public function UnRender():void
		{
			IsRendering = false;
			Stop();
			if (mDisplayObjectContainer != null)
			{
				for each(var a:Sprite in mKeyFrames)
					if (mDisplayObjectContainer.contains(a))
					{
						mDisplayObjectContainer.removeChild(a);	
					}
			}
			
		}
		public function Blink():void
		{
			if (IsRendering)
			{
				IsRendering = false;
				for each(var a:Sprite in mKeyFrames)
						a.alpha = 1;
			}
			else
			{
				for each(a in mKeyFrames)
					a.alpha = 0;
				IsRendering = true;
			}
		}
		//set the position of this animation
		public function SetPosition(x:int, y:int):void
		{
			for each(var image:Sprite in mKeyFrames)
			{
				image.x = x;
				image.y = y;
			}
		}
	}
	
}