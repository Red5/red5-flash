/**
* RED5 Open Source Flash Server - http://www.osflash.org/red5
*
* Copyright (c) 2006-2009 by respective authors (see below). All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this library; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/
	 
import mx.events.EventDispatcher;

class org.red5.controls.GraphicButton extends MovieClip {
// ui elements:
	private var hitAreaMC:MovieClip;
	private var _enabled:Boolean=true;
	
// methods for EventDispatcher:
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
// initialization:
	private function GraphicButton() 
	{
		EventDispatcher.initialize(this);
	}
	
	function onLoad() 
	{
		
		enabled = _enabled;
		if (hitAreaMC) { hitArea = hitAreaMC; }
	}
	
	function onRollOver():Void {
		if (!_enabled) { return; }
		this.gotoAndPlay("over");
		dispatchEvent({type:"over"});
	}
	function onDragOver():Void { onRollOver(); }
	
	function onRollOut():Void {
		if (!_enabled) { return; }
		this.gotoAndPlay("out");
		dispatchEvent({type:"out"});
	}
	function onDragOut():Void { onRollOut(); }
	
	function onPress():Void {
		if (!_enabled) { return; }
		//_global.lastButtonClicked = this
		this.gotoAndStop("down");
		dispatchEvent({type:"down"});
	}
	
	function onRelease():Void {
		if (!_enabled) { return; }
		//_global.lastButtonClicked = this
		onRollOver();
		
		dispatchEvent({type:"click"});
	}
	
	function onReleaseOutside():Void {
		dispatchEvent({type:"click"});
		//dispatchEvent({type:"releaseOutside"});
	}
	
	public function get enabled():Boolean {
		return _enabled;
	}
	
	public function set enabled(p_enabled:Boolean):Void {
		_enabled = Boolean(p_enabled);
		//useHandCursor = p_enabled;
		if (_enabled) this.gotoAndStop("visible");
		if (!_enabled) this.gotoAndStop("off");
	}
}
