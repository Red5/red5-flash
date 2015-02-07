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
import mx.controls.NumericStepper;
//import mx.controls.CheckBox;
import org.red5.samples.livestream.videoconference.Connector;
// ** END AUTO-UI IMPORT STATEMENTS **
import com.neoarchaic.ui.Tooltip;
import org.red5.net.Stream;
import org.red5.utils.Delegate;
import com.gskinner.events.GDispatcher;
import com.blitzagency.util.SimpleDialog;
import org.red5.samples.livestream.videoconference.VideoConference;

class org.red5.samples.livestream.videoconference.Broadcaster extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.samples.livestream.videoconference.Broadcaster;
	public static var LINKAGE_ID:String = "org.red5.samples.livestream.videoconference.Broadcaster";
	public static var instance:MovieClip;
// Public Properties:
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var videoID:Number;
// Private Properties:
	private var dispatchEvent:Function;
	private var stream:Stream;
	private var cam:Camera;
	private var mic:Microphone;
	private var controller:MovieClip;
	private var alert:SimpleDialog;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	//private var broadcastAudio:CheckBox;
	private var connector:Connector;
	private var public_video:MovieClip;
	private var videoQuality:NumericStepper;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Broadcaster() {GDispatcher.initialize(this);}
	private function onLoad():Void { configUI(); }

// Public Methods:
	public function registerController(p_controller:VideoConference):Void
	{
		controller = p_controller;
	}
	
	public function closeConnection():Void
	{
		connector.closeConnection();
	}
	
	public function registerAlert(p_alert:SimpleDialog):Void
	{
		alert = p_alert;
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{		
		instance = this;
		
		// setup the tooltip defaults
		Tooltip.options = {size:10, font:"_sans", corner:0};
		
		// setup alerts
		//broadcastAudio.addEventListener("click", Delegate.create(this, broadcastAudioChange));
		videoQuality.addEventListener("change", Delegate.create(this, videoQualityChange));
		alert = connector.alert;
		
		// setup cam
		cam = Camera.get();
		cam.setMode(160, 110, 8);
		
		// 4.18.2006 - removed per discussion with Luke/John about performance issues
		//cam.setQuality(0,80);
		cam.setQuality(0,videoQuality.value);
		cam.setKeyFrameInterval(35);
		cam.setMotionLevel(0,35000);
		cam.setLoopback(false);
		
		// setup mic
		//mic = Microphone.get();
		
		// get notified of connection changes
		connector.addEventListener("onSetID", this);
		connector.addEventListener("connectionChange", this);
		connector.addEventListener("newStream", Delegate.create(controller, controller.newStream));
		
		// set the uri
		Connector.red5URI = "rtmp://fancycode.com/fitcDemo";
		
		var live:Boolean = _level0._url.indexOf("http://") > -1 ? true : false;
		/*
		* if(live) Connector.red5URI = "rtmp://67.78.20.202/fitcDemo";
		*/
		
		// luke's server: 62.75.214.100
		if(live) Connector.red5URI = "rtmp://fancycode.com/fitcDemo";
		if(!live) Connector.red5URI = "rtmp://192.168.1.2/fitcDemo";
		
		
		// initialize the connector
		connector.configUI();	
	}
	
	private function broadcastAudioChange(evtObj:Object):Void
	{
		if(!connector.connected) return;
		alert.show("You need to reconnect to the server for this change to take affect");
	}
	
	private function videoQualityChange(evtObj:Object):Void
	{
		if(!connector.connected) return;
		alert.show("You need to reconnect to the server for this change to take affect");
	}
	
	private function status(evtObj:Object):Void
	{
		// deal with the status messages here
	}
	
	private function error(evtObj:Object):Void
	{
		// deal with the errors here
	}
	
	private function onSetID(evtObj:Object):Void
	{
		if(evtObj.id == "undefined" || isNaN(evtObj.id) || evtObj.id == "") return;
				
		videoID = evtObj.id;
		
		// setup stream
		stream = new Stream(connector.connection);
		
		// add stream status events listeners here
		stream.addEventListener("status", Delegate.create(this, status));
		stream.addEventListener("error", Delegate.create(this, error));
		
		// attach camera
		stream.attachVideo(cam);
		
		// add audio
		// 4.18.2006 - removed per discussion with Luke/John about performance issues
		//if(broadcastAudio.selected) stream.attachAudio(mic);
		
		_global.tt("Broadcaster.onSetID", videoID);
		stream.publish("videoStream_" + videoID, "live");
		
		// show it on screen
		public_video.video.attachVideo(cam);
		
		
		controller.setID(evtObj.id, connector.connection);
		
		//dispatchEvent({type:"onSetID", id:evtObj.id})
	}	
	
	private function connectionChange(evtObj:Object):Void
	{
		if(evtObj.connected) 
		{
			dispatchEvent({type:"connected", connection:connector.connection});
		}else
		{
			public_video.video.attachVideo(null);
			public_video.video.clear();
			dispatchEvent({type:"disconnected", connection:connector.connection});
		}
	}

}
