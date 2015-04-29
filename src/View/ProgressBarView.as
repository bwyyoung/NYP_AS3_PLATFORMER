package View 
{
	
	/**
	* ...
	* @author $(DefaultUser)
	*/
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	//this is the view for rendering the loading progress bar
	public class ProgressBarView extends Sprite {

		public var backgroundColour:uint = 0xC9C9C9;
		public var backgroundBorderColour:uint = 0xB2B2B2;
		public var backgroundShadowColors:Array = [0x444444,0x444444,0x444444,0x444444];
		public var backgroundShadowAlphas:Array = [0.2, 0, 0, 0.2];
		public var backgroundShadowRatios:Array = [0,0x07,0xF7,0xFF];
		
		public var barColors:Array = [0xC5FFC5, 0x95EBA6,0x00CB14,0x49EF5D];
		public var barAlphas:Array = [1, 1, 1, 1];
		public var barRatios:Array = [0, 0x6F, 0x80, 0xFF];
		public var barShadowColors:Array = [0x444444,0x444444,0x444444,0x444444];
		public var barShadowAlphas:Array = [0.2, 0, 0, 0.2];
		public var barShadowRatios:Array = [0,0x07,0xF7,0xFF];		

		public var highlightColors:Array = [0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF];
		public var highlightAlphas:Array = [0.7, 0.1, 0, 0];
		public var highlightRatios:Array = [0x0,0x30,0x3F,0xFF];	
		
		public var cornerRadius:int = 2;
		public var borderWidth:int = 1;
		
		private var progress:Number;
		private var min:Number;
		private var max:Number;
		private var barWidth:int;
		private var barHeight:int;
		
		public function ProgressBarView(x:int, y:int, barWidth:int, barHeight:int, min:Number = 0, max:Number = 100) {
			this.min = min;
			this.max = max;
			this.x = x;
			this.y = y;
			this.barWidth = barWidth;
			this.barHeight = barHeight;
		}	
		//this is to update the progress bar
		public function Update(progress:Number=NaN):void {
			if (!isNaN(progress))
				this.progress = progress;
			
			var matrix:Matrix = new Matrix();
			graphics.clear();
			//draw background
			graphics.beginFill(backgroundColour, 1.0);
			graphics.lineStyle(borderWidth, backgroundBorderColour, 1);
			graphics.drawRoundRect(0, 0, barWidth, barHeight, cornerRadius, cornerRadius);
			graphics.endFill();
			//draw side shadows
			graphics.lineStyle(0,0,0);
			matrix.createGradientBox(barWidth, barHeight, (0 / 180) * Math.PI, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, backgroundShadowColors, backgroundShadowAlphas, backgroundShadowRatios, matrix,SpreadMethod.PAD);
			graphics.drawRect(1, 1, barWidth-2, barHeight-2);
			graphics.endFill();
			//draw highlightrect
			graphics.lineStyle(1, 0xFFFFFF, 0.5);
			graphics.drawRect(1, 1, barWidth -2, barHeight -2);
			//draw progress bar
			var drawBarWidth:int = Math.min( (barWidth - 2) / (max - min) * this.progress, barWidth);
			matrix.createGradientBox(barWidth, barHeight, (90 / 180) * Math.PI, 0, 0);
			graphics.lineStyle(0,0,0);
			graphics.beginGradientFill(GradientType.LINEAR, barColors, barAlphas, barRatios, matrix,SpreadMethod.PAD);
			graphics.drawRect(1, 1, drawBarWidth, barHeight - 2);
			graphics.endFill();
			//draw bar shadow
			graphics.lineStyle(0,0,0);
			matrix.createGradientBox(drawBarWidth, barHeight, (0 / 180) * Math.PI, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, barShadowColors, barShadowAlphas, barRatios, matrix,SpreadMethod.PAD);
			graphics.drawRect(1, 1, drawBarWidth, barHeight-2);
			graphics.endFill();	
			//top highlight
			graphics.lineStyle(0,0,0);
			matrix.createGradientBox(barWidth, barHeight, (90 / 180) * Math.PI, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, highlightColors, highlightAlphas, highlightRatios, matrix,SpreadMethod.PAD);
			graphics.drawRect(1, 1, barWidth-2, barHeight-2);
			graphics.endFill();	
		}
		
	}
	
}