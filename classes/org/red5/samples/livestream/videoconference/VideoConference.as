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
import org.red5.samples.livestream.videoconference.Broadcaster;
import mx.controls.Button;
import mx.controls.TextArea;
import org.red5.ui.controls.IconButton;
import org.red5.samples.livestream.videoconference.Chat;
import org.red5.samples.livestream.videoconference.VideoPool;
// ** END AUTO-UI IMPORT STATEMENTS **

import org.red5.samples.livestream.videoconference.GlobalObject;
import com.blitzagency.xray.util.XrayLoader;

import org.red5.utils.Delegate;
import org.red5.samples.livestream.videoconference.Connection;

class org.red5.samples.livestream.videoconference.VideoConference extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.samples.livestream.videoconference.VideoConference;
	public static var LINKAGE_ID:String = "org.red5.samples.livestream.videoconference.VideoConference";
// Public Properties:
	public var SO:GlobalObject;
	public var videoID:Number;
// Private Properties:
	private var connection:Connection;
	private var result:Object;
	private var streamQue:Array;
	private var si:Number;
	private var snd:Sound;
	private var sndTarget:MovieClip;
	private var muted:Boolean = false;
	
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var broadcaster:Broadcaster;
	private var chat:Chat;
	private var clearTrace:Button;
	private var output:TextArea;
	private var soundMute:IconButton;
	private var soundPlay:IconButton;
	private var videoPool:VideoPool;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function VideoConference() 
	{
		XrayLoader.addEventListener("LoadComplete", this, "xrayLoadComplete"); 
		XrayLoader.loadConnector("xrayconnector.swf");
	}
	private function onLoad():Void { configUI(); }

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		clearTrace.onRelease = Delegate.create(this, clearOutput);
		//SO = new GlobalObject();
		result = {};
		result.onResult = Delegate.create(this, onResult);

		broadcaster.registerController(this);
		broadcaster.addEventListener("connected", this);
		broadcaster.addEventListener("disconnected", this);
		broadcaster.addEventListener("onSetID", this);
		
		chat.registerBroadcaster(broadcaster);
		chat.addEventListener("onNewName", Delegate.create(videoPool, videoPool.updateName));
		chat.addEventListener("newChat", Delegate.create(this, playNewChatSound));
		
		// create sound obj
		sndTarget = this.createEmptyMovieClip("sndTarget", this.getNextHighestDepth());
		snd = new Sound (sndTarget);
		snd.attachSound("newChatMessage");
		snd.setVolume(80);
		
		soundPlay._visible = false;
		soundMute.addEventListener("click", Delegate.create(this, updateMute));
		soundPlay.addEventListener("click", Delegate.create(this, updateMute));
		soundMute.tooltip = "Mute new chat sound";
		soundPlay.tooltip = "Un-mute new chat sound";
	}
	
	private function playNewChatSound():Void
	{
		if(muted) return;
		snd.stop();
		snd.start();
	}
	
	private function updateMute():Void
	{
		muted = !muted;
		soundMute._visible = !muted;
		soundPlay._visible = muted;
	}
	
	private function clearOutput():Void
	{
		output.text = "";
	}
	
	private function xrayLoadComplete():Void
	{
		var xr = _global.com.blitzagency.xray.XrayTrace.getInstance();
		xr.addEventListener("onTrace", this);
	}
	
	private function onTrace(traceInfo):Void
	{
		output.text += traceInfo.sInfo+"\n";	
	//	info.maxScroll
	}
	
	private function onResult(evtObj:Array):Void
	{
		_global.tt("Streams List recieved", evtObj);
		if(evtObj.length > 0) streamQue = evtObj;
		si = setInterval(this, "processQue", 250);
	}
	
	private function processQue():Void
	{
		if(streamQue.length <= 0) 
		{
			chat.getNames();
			clearInterval(si);
			return;
		}
		
		var id:Number = Number(streamQue.shift().split("_")[1]);
		_global.tt("SUBSCRIBING", id, streamQue.length);
		videoPool.subscribe(id);
	}
	
	private function setID(p_id:Number, p_connection:Connection):Void
	{
		//set local videoID
		videoID = Number(p_id);
		_global.tt("VideoConference.setID called", p_id);
		
		// set connection
		connection = p_connection;
		
		chat.configUI();
		chat.registerConnection(p_connection);
		chat.connectSO("videoConferenceChat");
		
		// connect to so
		//SO.connect("fitcDemoSO", p_connection, false);
		//SO.addEventListener("onSync", this);
		
		// let everyone else know your ID so they can subscribe
		//SO.setData("videoID", videoID);
		
		// get list of current streams and subscribe
		getStreams();
	}
	
	private function getStreams():Void
	{
		connection.call("getStreams", this.result);
	}
	
	private function newStream(evtObj:Object):Void
	{
		_global.tt("NewStream Recieved", evtObj.newStream);
		// new user, updates names
		//chat.getNames();
		videoPool.subscribe(evtObj.newStream.split("_")[1]);
	}
	
	private function onSync():Void
	{
		// fetch latest
		/*
		var newSubscription:Number = SO.getData("videoID");
		
		if(newSubscription != videoID) 
		{
			_global.tt("received new video stream", newSubscription);
			videoPool.subscribe(newSubscription);
		}
		*/
	}
	
	private function connected(evtObj:Object):Void
	{
		// connect to the SO after making connection
		
		videoPool.setConnection(evtObj.connection);
	}
	
	private function disconnected(evtObj:Object):Void
	{
		// reset the video pool	
		videoPool.resetAll();
	}
	
	private function updateSO():Void
	{
		
	}
}
