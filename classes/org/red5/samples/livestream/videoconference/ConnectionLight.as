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
import org.red5.utils.Delegate;
import org.red5.samples.livestream.videoconference.Connection;

class org.red5.samples.livestream.videoconference.ConnectionLight extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.samples.livestream.videoconference.ConnectionLight;
	public static var LINKAGE_ID:String = "org.red5.samples.livestream.videoconference.ConnectionLight";
// Public Properties:
// Private Properties:
	private var connection:Connection;
// UI Elements:

// ** AUTO-UI ELEMENTS **
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function ConnectionLight() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
	public function registerNC(p_connection:Connection):Void
	{
		// when we receive the connection reference, we can add the listener
		connection = p_connection;
		connection.addEventListener("success", Delegate.create(this, updateConnection));
		connection.addEventListener("close", Delegate.create(this, updateConnection));
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		// it's a 2 frame moveiclip.  frame 1 is disconnected, frame 2 is connected
		gotoAndStop(1);
	}
	
	private function updateConnection(evtObj:Object):Void
	{
		// when update is received, we change frames
		var frame:Number = evtObj.connected ? 2 : 1;
		gotoAndStop(frame);
	}

}
