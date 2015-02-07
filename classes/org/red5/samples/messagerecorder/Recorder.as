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
import org.red5.controls.GraphicButton;
// ** END AUTO-UI IMPORT STATEMENTS **
import com.blitzagency.xray.logger.XrayLog;
import org.red5.utils.Delegate;
import org.red5.net.Connection;
import com.acmewebworks.controls.BaseClip;
import mx.controls.Alert;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.geom.Matrix;
import com.gskinner.geom.ColorMatrix;
import flash.filters.ColorMatrixFilter;

class org.red5.samples.messagerecorder.Recorder extends BaseClip 
{
// Constants:
	public static var CLASS_REF = org.red5.samples.messagerecorder.Recorder;
	public static var LINKAGE_ID:String = "org.red5.samples.messagerecorder.Recorder";
	
	private static var BRIGHTNESS_START = -30;
	private static var CONTRAST_START = 10;
	private static var SATURATION_START = -100;
	private static var HUE_START = 0;
	
// Public Properties:
	public var recording:Boolean = false;
// Private Properties:
	private var log:XrayLog;
	private var charList:Array;
	private var connection:Connection;
	private var ns:NetStream;
	private var cam:Camera;
	private var mic:Microphone;
	private var timeoutSI:Number;
	private var updateSI:Number;
	private var matrix:Matrix;
	private var bd:BitmapData;
	private var cm:ColorMatrix;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var nameBG:MovieClip;
	private var videoContainer:MovieClip;
	private var record:GraphicButton;
	private var stopRecord:GraphicButton;
	private var txtName:TextField;
	private var videoBitmapContainer:MovieClip;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Recorder() {}
	private function onLoad():Void { configUI(); }

// Public Methods:

	public function registerConnection(p_connection:Connection):Void
	{
		trace(log.debug("registerConnection", p_connection));
		connection = p_connection;
		ns = new NetStream(connection);
	}
	
	public function disableControls():Void
	{
		// we're in record mode
		txtName.type = "dynamic";
		record.enabled = false;
		stopRecord.enabled = true;
		videoBitmapContainer._alpha = 100;
	}
	
	public function enableControls():Void
	{
		// there isn't an enabled property on textfields, so we just switch them between dynamic and input.
		videoBitmapContainer._alpha = 0;
		record.enabled = true;
		stopRecord.enabled = false;
		txtName.type = "input";
		txtName.text = "1.  enter your name(s)";
		Selection.setFocus(null);
		trace(log.debug("enableControls", txtName.text));
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		log = new XrayLog();
		
		// move videoContainer off wayyyyyy off
		videoContainer._x = -1000;
		
		cm = new ColorMatrix();
		cm.adjustColor(BRIGHTNESS_START,CONTRAST_START,SATURATION_START,HUE_START);
		videoContainer.filters = [new ColorMatrixFilter(cm)];
		
		matrix = new Matrix();
		bd = new BitmapData(videoContainer._width, videoContainer._height, false);
		videoBitmapContainer.attachBitmap(bd, 1);
		
		charList = [" ", ".", "&", "@", ":", "\"", "'", ";", "/", "\\", ">", "<"];
	
		txtName.onSetFocus = Delegate.create(this, onSetFocus);
		record.addEventListener("click", Delegate.create(this, recordClickHandler));
		stopRecord.addEventListener("click", Delegate.create(this, stopRecordClickHandler));
		
			// setup cam
		cam = Camera.get();
		cam.setMode(320, 270, 30);
		cam.setQuality(0,80);
		
		// setup mic
		mic = Microphone.get();
		mic.setRate(11);
		
		enableControls();
	}
	
	private function onSetFocus(evtObj:Object):Void
	{
		if(txtName.text.toLowerCase() == "1.  enter your name(s)") txtName.text = "";
	}
	
	private function recordClickHandler(evtObj:Object):Void
	{
		if(txtName.text.toLowerCase() == "1.  enter your name(s)" || txtName.text.length <= 0)
		{
			Alert.show("Please enter a valid name for your video", "Error in Name(s)",Alert.OK, null, enableControls);
		}else
		{
			// clean name
			var flvName:String = cleanString(txtName.text) + "_" + getTimer();
			trace(log.debug("flvName", flvName));
			
			// start recording
			startRecording(flvName);
		}
	}
	
	private function stopRecordClickHandler(evtObj:Object):Void
	{
		stopRecording();
	}
	
	private function startRecording(flvName:String):Void
	{
		if(recording) return;
		// lock down controls
		disableControls();
		recording = true;
		
		// connect for recording
		ns.publish(flvName, "record");
		ns.attachVideo(cam);
		ns.attachAudio(mic);
		
		// attach to video object on stage
		videoContainer.publish_video.attachVideo(cam);
		
		// update the bitmapdataobject
		clearInterval(updateSI);
		updateSI = setInterval(this, "updateBitmap", 25);
		
		// turn off in 3 minutes if not already done so
		timeoutSI = setInterval(this, "stopRecording", 180000);
	}
	
	private function updateBitmap():Void
	{
		bd.draw(videoContainer, matrix);
	}
	
	private function stopRecording():Void
	{
		if(!recording) return;
		trace(log.debug("stopRecording"));
		
		recording = false;
		
		// clear video on stage
		videoContainer.publish_video.attachVideo(null);
		videoContainer.publish_video.clear();
		videoBitmapContainer._alpha = 0;
		
		// close netStream
		ns.close();
		
		dispatchEvent({type:"stopRecording"});
	}
	
	private function cleanString(str:String):String
	{
		for(var i:Number=0;i<charList.length;i++)
		{
			str = str.split(charList[i]).join("");
		}
		return str.toLowerCase();
	}
}
