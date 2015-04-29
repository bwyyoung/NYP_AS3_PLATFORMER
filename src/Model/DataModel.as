package Model 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	/**
	* ...
	* @author $(DefaultUser)
	*/
	//this class contains information about loading from an 
	public class DataModel 
	{	
		private var mLoader:Loader;
		private var mURLLoader:URLLoader;
		private var mBytesLoaded:int;
		private var mBytesTotal:int;
		private var mFunction:Function;
		public var Info:String;
		
		//this class is a helper class for loading data of all types, such as images and xml files
		public function DataModel(theRequest:URLRequest,  DataName:String = "", FunctionCall:Function = null) 
		{
			Info = DataName;
			var a:Array = theRequest.url.match("([a-zA-Z0-9]*$)");
			
			mFunction = FunctionCall;
			//if it is xml, use the url loader, otherwise just use a normal loader
			if (a[0] == "xml")
			{
				mURLLoader = new URLLoader();
				mURLLoader.load(theRequest);
				mURLLoader.addEventListener(ProgressEvent.PROGRESS, Update);
				mURLLoader.addEventListener(Event.COMPLETE, Complete);
			}
			else
			{
				mLoader = new Loader();
				mLoader.load(theRequest);
				mLoader.contentLoaderInfo.addEventListener(Event.OPEN, Start);
				mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Update);
				mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, doError);
				mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, Complete);
			}
		}
		
					
		
		public function doError(evt:IOErrorEvent):void 
		{
			trace("ERROR " +  Info);
		}
		private function Start(evt:Event):void
		{

		}
		
		//update on how many bytes have been loaded and the total bytes
		private function Update(evt:ProgressEvent):void
		{
			mBytesLoaded = evt.bytesLoaded;
			mBytesTotal = evt.bytesTotal;
				
		}
		private function Complete(evt:Event):void
		{

			if (evt.target is LoaderInfo)
				evt.currentTarget.content.parent.name = Info;
			mFunction(evt);
		}
		public function get Loaded():int
		{
			return mBytesLoaded;
		}
		public function get Total():int
		{
			return mBytesTotal;
		}
	}
	
}