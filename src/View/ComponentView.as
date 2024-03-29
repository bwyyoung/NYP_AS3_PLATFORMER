﻿package View 
{
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.display.Sprite;
	// ABSTRACT Class (should be subclassed and not instantiated)

	public class ComponentView extends Sprite 
	{
		protected var model:Object;
		protected var controller:Object;
		public function ComponentView(aModel:Object, aController:Object = null)
		{
			this.model = aModel;
			this.controller = aController;
		}
		public function add(c:ComponentView):void
		{
			throw new IllegalOperationError("add operation not supported");
		}
		public function remove(c:ComponentView):void
		{
			throw new IllegalOperationError("remove operation not supported");
		}
		public function getChild(n:int):ComponentView
		{
			throw new IllegalOperationError("getChild operation not supported");
			return null;
		}
		// ABSTRACT Method
		public function update(event:Event = null):void {}
	}
}