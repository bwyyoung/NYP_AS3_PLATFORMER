package Animations 
{
	import Animations.Animation;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	public class AnimationSet 
	{
		//an animation set contains a group of animations, like an animationset for mario and another for bigmario
		//An animation set is used for each variant of an entity, be it a enemy or item
		//examples of variants are red and yellow itemboxes.
		public var Width:int;
		public var Height:int;
		public var mCurrentAnimName:String;
		public var mName:String; //this is the name of the specific variant, eg redturtle.
		public var mType:String; // the type of entity, like turtle or smallturtle
		public var mAnimationsArray:Array;
		public var mHighlightColor:uint; // an overall color to highlight the sprite.
		private var mCurrentAnimation:int; //the current animation
		private var mAnimationQueue:Array;//an array of animations specified to be played in a queue
		private var mPlaying:Boolean;//is the animation currently playing
		public var mCurContainer:DisplayObjectContainer;
		public var IsQueing:Boolean;//is the animation currently being played based on a queue
		public var IsRendering:Boolean;
		public var mX:int;//the x and y coordinate for the animationset
		public var mY:int;
		public var mLatestAnim:String;
		public function AnimationSet() 
		{
			mX = mY = 0;
			mPlaying = false;
			IsQueing = false;
			mAnimationsArray = new Array();
			mAnimationQueue = new Array();
			mCurrentAnimation = 0;
		}
		//add an animation to this animationset
		public function AddAnimation(theAnimation:Animation):void
		{
			Width = theAnimation.framewidth;
			Height = theAnimation.frameheight;
			mAnimationsArray.push(theAnimation);
		}
		//create a duplicate of this animation to have an instance for each unique entity
		public function CopyData(theAnimationSet:AnimationSet):void
		{
			theAnimationSet.mName = mName;
			theAnimationSet.mType = mType;
			theAnimationSet.mHighlightColor = mHighlightColor;
			theAnimationSet.Width = Width;
			theAnimationSet.Height = Height;
			theAnimationSet.mCurContainer = mCurContainer;
			for each (var anim:Animation in mAnimationsArray)
			{
				var theanim:Animation = new Animation(anim.mFPS, anim.looping);
				theanim.mName = anim.mName;
				theanim.framewidth = anim.framewidth;
				theanim.frameheight = anim.frameheight;
				for each (var thesprite:Sprite in anim.mKeyFrames)
				{
					var thebitmap:Bitmap = thesprite.getChildAt(0) as Bitmap;
					theanim.AddFrame(new Bitmap(thebitmap.bitmapData));//the same bitmapdata is referenced to in each animation copied out.
				}
				theAnimationSet.AddAnimation(theanim);
			}
		}
		//set the position 
		public function SetPosition(x:int, y:int):void
		{
			mX = x;
			mY = y;
			for each (var theanimation:Animation in mAnimationsArray)
			{
				theanimation.SetPosition(x, y);
			}
		}
		//set the framerate of a specific animation
		public function SetFPS(ID:uint, theFPS:uint):void
		{
			mAnimationsArray[ID].mFPS = theFPS;
		}
		//play the current animation
		public function PlayAnimation(AnimationName:String, atEnd:Boolean = false,StartFrame:int = 0,Direction:Boolean = true):void
		{
			mLatestAnim = AnimationName;
			var ID:int = -1;
			for (var i:int = 0; i < mAnimationsArray.length; i++)
			{
				if (mAnimationsArray[i].mName == AnimationName)
				{
					mCurrentAnimName = AnimationName;
					ID = i;
				}
			}
			if (ID < 0)
				throw new Error("Invalid animation: " + AnimationName);
			if (atEnd)
			{
				//if you want to play the animation at the end, add it to a queue
				mAnimationQueue.push(AnimationName);
				if (mCurrentAnimation<0)
					mCurrentAnimation = ID;
				if (!IsQueing)
				{
					//only call then
					IsQueing = true;
				}
				mAnimationsArray[mCurrentAnimation].mCallback = CheckAnimation;
			}
			else
			{
				mAnimationsArray[mCurrentAnimation].UnRender();
				mCurrentAnimation = ID;
				mAnimationsArray[mCurrentAnimation].Play(StartFrame);
			}
			mPlaying = true;
		}
		//stop the current animation
		public function Stop():void
		{
			mAnimationsArray[mCurrentAnimation].Stop();
			mPlaying = false;
		}
		//play the current animation
		public function Play():void
		{
			if (!mPlaying)
			{
				mAnimationsArray[mCurrentAnimation].Play();
				mPlaying = true;
			}
		}
		//set the x scale to flip the animations horizontally
		public function SetXScale(thescale:int):void
		{
			for each(var anim:Animation in mAnimationsArray)
			{
				anim.SetXScale(thescale);
			}
		}
		//remove the animation from the screen
		public function UnRender():void
		{
			IsRendering = false;
			Stop();
			for each(var anim:Animation in mAnimationsArray)
				anim.UnRender();
		}
		public function Blink():void
		{
				for each(var anim:Animation in mAnimationsArray)
					anim.Blink();
		}
		//render the current animation to the screen
		public function Render(theDisplayObjectContainer:DisplayObjectContainer = null):void
		{
			if (!IsRendering)
			{
			//if (mCurContainer != theDisplayObjectContainer)
			//{
				IsRendering = true;
				if (theDisplayObjectContainer != null)
					mCurContainer = theDisplayObjectContainer;
				for each (var anim:Animation in mAnimationsArray)
				{
					anim.SetDOC(mCurContainer);
				}
				if (mName == "RedBlockIcon")
					trace(mCurrentAnimation)
			//}
				mAnimationsArray[mCurrentAnimation].Play();
			}
		}
		//this function is used when you want to play an animation after another
		//when one animation is finished, the next one will play in sequence
		private function CheckAnimation():void
		{
			if (mPlaying)
			{
				if (mAnimationQueue.length > 0)
				{
					if (mAnimationsArray[mCurrentAnimation].ended)
					{
						mAnimationsArray[mCurrentAnimation].UnRender();
						for (var i:int = 0; i < mAnimationsArray.length ; i++)
						{
							if (mAnimationsArray[i].mName == mAnimationQueue[0])
								mCurrentAnimation = i;
						}
						mAnimationsArray[mCurrentAnimation].Play(arguments[0],arguments[1]);
						mAnimationQueue.splice(0, 1);
						mAnimationsArray[mCurrentAnimation].mCallback = CheckAnimation;
					}
				}
				else
				{
					mAnimationsArray[mCurrentAnimation].mCallback = null;
					//there are no more animations in the queue, so clear the interval for calling this function
					IsQueing = false;
				}
			}
		}
	}
	
}