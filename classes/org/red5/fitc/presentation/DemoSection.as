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

import com.blitzagency.data.ContentFarm;

class org.red5.fitc.presentation.DemoSection extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.fitc.presentation.DemoSection;
	public static var LINKAGE_ID:String = "org.red5.fitc.presentation.DemoSection";
// Public Properties:
// Private Properties:
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var title:TextField;
	private var content:MovieClip;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Section() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
	function transitionIn():Void
	{
		//content.htmlText = ContentFarm.getContent("section_0");
		_visible = true;
		gotoAndPlay("transitionIn");
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		//content.loadMovie("FITCvideoConference.swf");
		hide();
	}
	
	private function hide():Void
	{
		//content.htmlText = "";
		_visible = false;
		gotoAndStop(1);
	}
}
