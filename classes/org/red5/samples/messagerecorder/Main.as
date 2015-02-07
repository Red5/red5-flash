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
import org.red5.utils.Connector;
import org.red5.samples.messagerecorder.ThankYou;
import org.red5.samples.messagerecorder.Recorder;
// ** END AUTO-UI IMPORT STATEMENTS **
import com.neoarchaic.ui.Tooltip;
import org.red5.utils.Delegate;
import com.blitzagency.xray.util.XrayLoader;
import com.blitzagency.xray.logger.XrayLog;
import com.acmewebworks.controls.BaseClip;
import com.mosesSupposes.fuse.*;

class org.red5.samples.messagerecorder.Main extends BaseClip {
// Constants:
	public static var CLASS_REF = org.red5.samples.messagerecorder.Main;
	public static var LINKAGE_ID:String = "org.red5.samples.messagerecorder.Main";
// Public Properties:
// Private Properties:
	var log:XrayLog;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var connector:Connector;
	private var recorder:Recorder;
	private var thankYou:ThankYou;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Main() {}
	private function onLoad():Void 
	{ 
		fscommand("fullscreen", true);
		fscommand("allowscale", false);
		
		mx.styles.StyleManager.registerColorName("special_orange", 0xFF9900);

		_global.style.setStyle ("themeColor", "special_orange");
		_global.style.setStyle("fontFamily", "_sans");
		_global.style.setStyle("fontSize", 10);
		
		ZigoEngine.register(Shortcuts, FuseItem, PennerEasing, Fuse, FuseFMP);
		
		// hide the connector
		connector._visible = false;
		
		// hide thank you
		thankYou.addEventListener("onHide", Delegate.create(recorder, recorder.enableControls));
		
		XrayLoader.addEventListener(XrayLoader.LOADCOMPLETE, this, "configUI");
		XrayLoader.loadConnector("xrayConnector_1.6.1.swf", null, false);
		log = new XrayLog();
	}

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		_level0.__xrayConnector._visible = false;
		
		// to show / hide the connector
		Key.addListener(this);
		
		// register for stopRecording messages
		recorder.addEventListener("stopRecording", Delegate.create(thankYou, thankYou.show));

		// setup the tooltip defaults
		Tooltip.options = {size:10, font:"_sans", corner:0};
		
		// get notified of connection changes
		connector.addEventListener("connectionChange", this);
		
		// set the uri
		Connector.red5URI = "rtmp://localhost/messageRecorder";
		
		// initialize the connector
		connector.configUI();
		
		// connect automatically
		connector.makeConnection();
	}
	
	private function connectionChange(evtObj:Object):Void
	{		
		if(evtObj.connected) 
		{				
			recorder.registerConnection(evtObj.connection);
		}
	}
	
	private function onKeyDown():Void
	{
		
		var key:Number = Key.getAscii();
		// SHIFT + ~
		if(Key.isDown(Key.SHIFT) && key == 126)
		{
			//trace(log.debug("key!!", Key.getAscii()));
			connector._visible = !connector._visible;
		}
	}
}
