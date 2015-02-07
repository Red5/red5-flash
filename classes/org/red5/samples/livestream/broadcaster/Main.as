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

// ** END AUTO-UI IMPORT STATEMENTS **

import com.neoarchaic.ui.Tooltip;

import org.red5.net.Stream;

import org.red5.utils.Delegate;

import com.blitzagency.xray.util.XrayLoader;



class org.red5.samples.livestream.broadcaster.Main extends MovieClip {

// Constants:

	public static var CLASS_REF = org.red5.samples.livestream.broadcaster.Main;

	public static var LINKAGE_ID:String = "org.red5.samples.livestream.broadcaster.Main";

// Public Properties:

// Private Properties:

	private var stream:Stream;

	private var cam:Camera;

	private var mic:Microphone;

// UI Elements:



// ** AUTO-UI ELEMENTS **

	private var connector:Connector;

	private var publish_video:Video;

// ** END AUTO-UI ELEMENTS **



// Initialization:

	private function Main() {XrayLoader.loadConnector("xray.swf");}

	private function onLoad():Void { configUI(); }



// Public Methods:

// Semi-Private Methods:

// Private Methods:

	private function configUI():Void 

	{

		// setup the tooltip defaults

		Tooltip.options = {size:10, font:"_sans", corner:0};

		

		// setup cam

		cam = Camera.get();

		cam.setMode(480, 320, 15);

		cam.setQuality(0,80);

		

		// setup mic

		mic = Microphone.get();

		

		// get notified of connection changes

		connector.addEventListener("connectionChange", this);

		

		// set the uri

		Connector.red5URI = "rtmp://localhost/oflaDemo";

		

		// initialize the connector

		connector.configUI();	

	}

	

	private function status(evtObj:Object):Void

	{

		// deal with the status messages here

	}

	

	private function error(evtObj:Object):Void

	{

		// deal with the errors here

	}

	

	private function connectionChange(evtObj:Object):Void

	{

		if(evtObj.connected) 

		{

			// setup stream

			stream = new Stream(evtObj.connection);

			// add stream status events listeners here

			stream.addEventListener("status", Delegate.create(this, status));

			stream.addEventListener("error", Delegate.create(this, error));

			// attach camera

			stream.attachVideo(cam);

			// add audio

			stream.attachAudio(mic);

			stream.publish("red5StreamDemo", "live");

			// show it on screen

			publish_video.attachVideo(cam);

		}else

		{

			publish_video.attachVideo(null);

			publish_video.clear();

		}

	}



}
