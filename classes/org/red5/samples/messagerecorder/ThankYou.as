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

// ** AUTO-UI IMPORT STATEMENTS **
// ** END AUTO-UI IMPORT STATEMENTS **
import com.acmewebworks.controls.BaseClip;
import com.mosesSupposes.fuse.Fuse;

class org.red5.samples.messagerecorder.ThankYou extends BaseClip {
// Constants:
	public static var CLASS_REF = org.red5.samples.messagerecorder.ThankYou;
	public static var LINKAGE_ID:String = "org.red5.samples.messagerecorder.ThankYou";
// Public Properties:
// Private Properties:
	private var si:Number;
// UI Elements:

// ** AUTO-UI ELEMENTS **
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function ThankYou() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
	public function show():Void
	{
		_visible = true;
		var f:Fuse = new Fuse();
		f.push({target:this, start_alpha:0, alpha:100, seconds:2});
		f.start();
		clearInterval(si);
		si = setInterval(this, "hide", 4000);
	}
	
	public function hide():Void
	{
		clearInterval(si);		
		var f:Fuse = new Fuse();
		f.push({target:this, start_alpha:100, alpha:0, seconds:2});
		f.start();
		dispatchEvent({type:"onHide"});
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void {_visible=false};
}
