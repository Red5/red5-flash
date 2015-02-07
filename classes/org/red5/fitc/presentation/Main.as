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
import com.blitzagency.controls.GraphicButton;
import org.red5.fitc.presentation.Section;
// ** END AUTO-UI IMPORT STATEMENTS **

import com.blitzagency.util.ClipTransitionManager;
import com.dynamicflash.utils.Delegate;
import org.red5.fitc.presentation.ConfigDelegate;
import com.blitzagency.xray.util.XrayLoader;
import com.blitzagency.data.DecodeHTML;
import org.red5.samples.livestream.videoconference.Broadcaster;

class org.red5.fitc.presentation.Main extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.fitc.presentation.Main;
	public static var LINKAGE_ID:String = "org.red5.fitc.presentation.Main";
// Public Properties:
// Private Properties:
	private var sectionCount:Number = 8;
	private var ctm:ClipTransitionManager;
	private var currentSection:Number = 0;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var back:GraphicButton;
	private var forward:GraphicButton;
	private var section_0:Section;
	private var section_1:Section;
	private var section_2:Section;
	private var section_3:Section;
	private var section_4:Section;
	private var section_5:Section;
	private var section_6:Section;
	private var section_7:Section;
	private var section_8:Section;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Main() 
	{
		XrayLoader.loadConnector("xrayconnector.swf");
		ctm = new ClipTransitionManager();
		ctm.debug = false;
		Key.addListener(this);
	}
	private function onLoad():Void 
	{
		//DecodeHTML.addStrings(new Array({from: chr(13), to:"<br>"}));
		//ConfigDelegate.addEventListener("onLoadComplete", Delegate.create(this, configUI));
		//ConfigDelegate.loadData("config.xml");
	}

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		back.addEventListener("click", Delegate.create(this, goBack));
		forward.addEventListener("click", Delegate.create(this, goForward));
		back.gotoAndPlay("transitionIn");
		forward.gotoAndPlay("transitionIn");
	
		ctm.transitionClips(section_0);
		
		/*
		// There are 4 events that CTM dispatches:
		ctm.addEventListener("onTransitionIn", this);
		ctm.addEventListener("onTransitionOut", this);
		ctm.addEventListener("onTransitionInComplete", this);
		ctm.addEventListener("onTransitionOutComplete", this);
		
		function onTransitionIn(evtObj:Object):Void
		{
			tt("event recieved", evtObj.type, evtObj.target);
		}
		function onTransitionOut(evtObj:Object):Void
		{
			tt("event recieved", evtObj.type, evtObj.target);
		}
		function onTransitionInComplete(evtObj:Object):Void
		{
			tt("event recieved", evtObj.type, evtObj.nextClip);
		}
		function onTransitionOutComplete(evtObj:Object):Void
		{
			tt("event recieved", evtObj.type, evtObj.nextClip);
		}
		*/
	}
	
	private function onKeyUp():Void
	{
		if(currentSection == 6) return;
		var key:Number = Key.getAscii();
		if(key == 8) goBack();
		if(key == 32) goForward();
	}
	
	private function goBack(evtObj:Object):Void
	{
		if(currentSection == 6) Broadcaster.instance.closeConnection();
		
		currentSection = Number(ctm.currentClip._name.split("_")[1]);
		_global.tt("back", currentSection, ctm.currentClip._name);
		if(currentSection == 0) return;
		
		currentSection--;
		ctm.transitionClips(this["section_" + currentSection]);
	}
	
	private function goForward(evtObj:Object):Void
	{
		if(currentSection == 6) Broadcaster.instance.closeConnection();
		
		currentSection = Number(ctm.currentClip._name.split("_")[1]);
		_global.tt("forward", currentSection);
		if(currentSection == sectionCount-1) return;
		currentSection++;
		_global.tt("should go Forward", currentSection);
		ctm.transitionClips(this["section_" + currentSection])
	}
}
