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
import com.blitzagency.util.SimpleDialog;
import mx.controls.ComboBox;
import org.red5.samples.livestream.videoconference.ConnectionLight;
import org.red5.ui.controls.IconButton;
// ** END AUTO-UI IMPORT STATEMENTS **
import org.red5.samples.livestream.videoconference.Connection;
import org.red5.utils.Delegate;
import com.gskinner.events.GDispatcher;
import com.blitzagency.util.LSOUserPreferences;

class org.red5.samples.livestream.videoconference.Connector extends MovieClip 
{
// Constants:
	public static var CLASS_REF = org.red5.samples.livestream.videoconference.Connector;
	public static var LINKAGE_ID:String = "org.red5.samples.livestream.videoconference.Connector";
	public static var red5URI:String = "rtmp://localhost/";
// Public Properties:
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var connection:Connection;
	public var connected:Boolean;
// Private Properties:
	private var dispatchEvent:Function;
	
	
// UI Elements:

// ** AUTO-UI ELEMENTS **
	public var alert:SimpleDialog;
	private var connect:IconButton;
	private var disconnect:IconButton;
	private var light:ConnectionLight;
	private var uri:ComboBox;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Connector() {GDispatcher.initialize(this);}
	private function onLoad():Void {}

// Public Methods:
	public function configUI():Void 
	{
		// instantiate the con 	qnection
		connection  = new Connection();
		
		// register the connection with the light so it can add a listener
		light.registerNC(connection);
		
		// hide disconnect button
		disconnect._visible = false;
		
		// set the URI
		//uri.text = red5URI;
		uri.addEventListener("change", Delegate.create(this, uriChange));
		initURIList();		
		
		// setup the buttons
		connect.addEventListener("click", Delegate.create(this, makeConnection));
		disconnect.addEventListener("click", Delegate.create(this, closeConnection));
		connect.tooltip = "Connect to Red5";
		disconnect.tooltip = "Disconnect from Red5";
		
		// add listener for connection changes
		connection.addEventListener("success", Delegate.create(this, manageButtons));
		connection.addEventListener("onSetID", this);
		
		// FITC VIDEO CONFERENCE
		connection.addEventListener("newStream", this);
		connection.addEventListener("close", Delegate.create(this, manageButtons));
	}
	
	public function initURIList():Void
	{
		LSOUserPreferences.load("VideoConference");
		
		var uriList:Array = LSOUserPreferences.getPreference("uriList");
		if(uriList != undefined && uriList.length > 0)
		{
			uri.dataProvider = uriList;
		}else
		{
			// add default values for now:
			uri.addItem("rtmp://192.168.1.2/fitcDemo");
			uri.addItem("rtmp://fancycode.com/fitcDemo");
			uri.addItem("rtmp://69.64.37.77/fitcDemo");
		}
	}
	
	public function makeConnection(evtObj:Object):Void
	{
		if(uri.length > 0) 
		{
			var goodURI = connection.connect(uri.value, getTimer());
			if(!goodURI) 
			{
				alert.show("Please check connection URI String and try again.");
			}else
			{
				connected = true;
				// update LSO
				LSOUserPreferences.setPreference("uriList", uri.dataProvider, true);
				addNewURI(uri.text);
				
			}
		}
	}
// Semi-Private Methods:
// Private Methods:
	private function addNewURI(p_value:String):Void
	{
		if(!checkDuplicates(p_value)) uri.addItem({label:uri.text})
	}
	
	private function checkDuplicates(p_value:String):Boolean
	{
		for(var i:Number=0;i<uri.dataProvider.length;i++)
		{
			if(uri.getItemAt(i).label == p_value) 
			{
				return true;
			}
		}
		return false;
	}

	private function uriChange(evtObj:Object):Void
	{
		if(uri.value.indexOf(" - clr") > -1)
		{
			removeFromList(String(uri.value.split(" -")[0]));
		}
	}
	
	private function removeFromList(p_value:String):Void
	{
		for(var i:Number=0;i<uri.dataProvider.length;i++)
		{
			if(uri.getItemAt(i).label == p_value) 
			{
				uri.removeItemAt(i);
				uri.text = "";
				break;
			}
		}
	}

	// FITC VIDEO CONFERENCE
	private function newStream(evtObj:Object):Void
	{
		dispatchEvent({type:"newStream", newStream:evtObj.newStream});
	}
	
	// FITC VIDEO CONFERENCE
	private function onSetID(evtObj:Object):Void
	{
		dispatchEvent({type:"onSetID", id:evtObj.id})
	}	
	
	public function closeConnection(evtObj:Object):Void
	{
		if(connection.connected) 
		{
			connected = false;
			connection.close();
		}
	}
	
	private function manageButtons(evtObj:Object):Void
	{
		// based on the connection value, hide/show the respective buttons
		connect._visible = !evtObj.connected;
		disconnect._visible = evtObj.connected;
		
		// since Main doesn't really have access to Light, we're going to pass along the notification
		dispatchEvent({type:"connectionChange", connected: evtObj.connected});
	}
}
