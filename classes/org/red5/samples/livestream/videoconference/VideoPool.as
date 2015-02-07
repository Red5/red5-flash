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
import org.red5.samples.livestream.videoconference.Subscriber;
// ** END AUTO-UI IMPORT STATEMENTS **

import org.red5.samples.livestream.videoconference.Connection;

class org.red5.samples.livestream.videoconference.VideoPool extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.samples.livestream.videoconference.VideoPool;
	public static var LINKAGE_ID:String = "org.red5.samples.livestream.videoconference.VideoPool";
// Public Properties:
	public var connection:Connection;
// Private Properties:
	private var subscriberList:Array;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var subscriber_0:Subscriber;
	private var subscriber_1:Subscriber;
	private var subscriber_2:Subscriber;
	private var subscriber_3:Subscriber;
	private var subscriber_4:Subscriber;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function VideoPool() {}
	private function onLoad():Void { configUI(); }

// Public Methods:

	public function updateName(evtObj:Object):Void
	{
		if(evtObj.name == undefined) return;
		//_global.tt("VideoPool.updateName", evtObj.name, evtObj.videoID);
		
		for(var i:Number=0;i<subscriberList.length;i++)
		{
			var videoID:Number = subscriberList[i].videoStream.split("_")[1];
			if(videoID == evtObj.videoID)
			{
				// we have a match, update the name
				//_global.tt("found match", subscriberList[i]);
				subscriberList[i].setUserName(evtObj.name);
			}
		}
	}

	public function resetAll():Void
	{
		// if the user disconnects, but doesn't close the client, reset all subscribers
		for(var i:Number=0;i<subscriberList.length;i++)
		{
			if(subscriberList[i].connected)
			{
				subscriberList[i].reset();
			}
		}
	}
	
	public function subscribe(p_id:Number):Void
	{
		// VideoPool recieves an id to subscribe to
		// if bogus id is returned, don't add
		if(p_id == "undefined" || isNaN(p_id) || p_id == "") return;
		
		_global.tt("isNaN", isNaN(p_id), p_id);
		// it first has to manage which of the video screens is available, if any
		var video = getVideoContainer();
		if(video != null) 
		{
			video.subscribe("videoStream_" + p_id, connection);
		}
	}
	
	public function setConnection(p_connection:Connection):Void
	{
		connection = p_connection;
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		subscriberList = [];
		for(var i:Number=0;i<5;i++)
		{
			subscriberList.push(this["subscriber_" + i]);
		}
	}
	
	private function getVideoContainer():Subscriber
	{
		for(var i:Number=0;i<subscriberList.length;i++)
		{
			if(!subscriberList[i].connected)
			{
				return subscriberList[i];
				break;
			}
		}
		
		return null;
	}
}
