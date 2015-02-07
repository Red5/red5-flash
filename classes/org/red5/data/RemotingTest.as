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
import mx.controls.Button;
import mx.controls.TextArea;
import mx.controls.CheckBox;
import mx.controls.TextInput;
// ** END AUTO-UI IMPORT STATEMENTS **

import com.dynamicflash.utils.Delegate;
import com.blitzagency.xray.util.XrayLoader;
import org.red5.data.RemotingTestData;

class org.red5.data.RemotingTest extends MovieClip {
// Constants:
	public static var CLASS_REF = org.red5.data.RemotingTest;
	public static var LINKAGE_ID:String = "org.red5.data.RemotingTest";
// Public Properties:
// Private Properties:
	private var xrayConnector:MovieClip;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var chkArray:CheckBox;
	private var chkArrayRepeating:CheckBox;
	private var chkMixedArray:CheckBox;
	private var chkMixedObject:CheckBox;
	private var chkNestedArray:CheckBox;
	private var chkNestedObject:CheckBox;
	private var chkNull:CheckBox;
	private var chkNumber:CheckBox;
	private var chkObject:CheckBox;
	private var chkObjectRepeating:CheckBox;
	private var chkString:CheckBox;
	private var chkUndefined:CheckBox;
	private var clearOutput:Button;
	private var gatewayValue:TextInput;
	private var numberValue:TextInput;
	private var output:TextArea;
	private var remoteMethodValue:TextInput;
	private var serviceValue:TextInput;
	private var stringValue:TextInput;
	private var submit:Button;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function RemotingTest() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		// styles
		mx.styles.StyleManager.registerColorName("special_blue", 0xADD6FD);
		_global.style.setStyle ("themeColor", "special_blue");
		_global.style.setStyle("fontFamily", "_sans");
		_global.style.setStyle("fontSize", 10);
		
		// set tabbing
		gatewayValue.tabIndex = 1;
		serviceValue.tabIndex = 2;
		remoteMethodValue.tabIndex = 3;
		numberValue.tabIndex = 4;
		stringValue.tabIndex = 5;
		
		// load xray
		XrayLoader.addEventListener(XrayLoader.LOADCOMPLETE, this, "xrayLoadComplete");
		xrayConnector = XrayLoader.loadConnector("xrayconnector.swf",_level0, true);
		
		// checkboxes
		chkArray.addEventListener("click", Delegate.create(this, clickHandler));
		chkArrayRepeating.addEventListener("click", Delegate.create(this, clickHandler));
		chkMixedArray.addEventListener("click", Delegate.create(this, clickHandler));
		chkMixedObject.addEventListener("click", Delegate.create(this, clickHandler));
		chkNestedArray.addEventListener("click", Delegate.create(this, clickHandler));
		chkNestedObject.addEventListener("click", Delegate.create(this, clickHandler));
		chkNull.addEventListener("click", Delegate.create(this, clickHandler));
		chkNumber.addEventListener("click", Delegate.create(this, clickHandler));
		chkObject.addEventListener("click", Delegate.create(this, clickHandler));
		chkObjectRepeating.addEventListener("click", Delegate.create(this, clickHandler));
		chkString.addEventListener("click", Delegate.create(this, clickHandler));
		chkUndefined.addEventListener("click", Delegate.create(this, clickHandler));
		
		// buttons
		submit.addEventListener("click", Delegate.create(this, clickHandler));
		clearOutput.addEventListener("click", Delegate.create(this, clickHandler));
		
		// textfields
		gatewayValue.addEventListener("change", Delegate.create(this, textValueChangeHandler));
		serviceValue.addEventListener("change", Delegate.create(this, textValueChangeHandler));
		remoteMethodValue.addEventListener("change", Delegate.create(this, textValueChangeHandler));
		stringValue.addEventListener("change", Delegate.create(this, textValueChangeHandler));
		numberValue.addEventListener("change", Delegate.create(this, textValueChangeHandler));
	}
	
	private function xrayLoadComplete(evtObj:Object):Void
	{
		var xt:Object = _global.com.blitzagency.xray.XrayTrace.getInstance();
		xt.addEventListener("onTrace", Delegate.create(this, xrayTraceHandler));
		xrayConnector._x += Stage.width - xrayConnector._width;
		xrayConnector._y += Stage.height - xrayConnector._height-5;
		RemotingTestData.initialize();
	}
	
	private function xrayTraceHandler(evtObj:Object):Void
	{
		output.text += evtObj.sInfo + "\n";
	}
	
	private function textValueChangeHandler(evtObj:Object):Void
	{
		//handles text changes to the text input fields
		//_global.tt("changed", evtObj.target._name);
		switch(evtObj.target._name)
		{
			case "gatewayValue":
				RemotingTestData.gatewayUrl = evtObj.target.text;
			break;
			
			case "serviceValue":
				RemotingTestData.serviceName = evtObj.target.text;
			break;
			
			case "remoteMethodValue":
				RemotingTestData.remoteMethod = evtObj.target.text;
			break;
			
			case "stringValue":
				RemotingTestData.chkString = evtObj.target.text;
			break;
			
			case "numberValue":
				RemotingTestData.chkNumber = evtObj.target.text;
			break;
		}
	}
	
	private function clickHandler(evtObj:Object):Void
	{
		//_global.tt("click", evtObj);
		switch(evtObj.target._name)
		{
			case "clearOutput":
				output.text = "";
			break;
			
			case "submit":
				RemotingTestData.testRemoteMethod();
			break;
			
			default:
				if(evtObj.target.selected)
				{
					RemotingTestData.argumentsList[evtObj.target._name] = {send:true};
				}else
				{
					RemotingTestData.argumentsList[evtObj.target._name].send = false;
				}
				
				//_global.tt(RemotingTestData.argumentsList)
			
			/*
			case "chkArray":
				
			break;
			
			case "chkArrayRepeating":
				
			break;
			
			case "chkMixedArray":
				
			break;
			
			case "chkMixedObject":
				
			break;
			
			case "chkNestedArray":
				
			break;
			
			case "chkNestedObject":
				
			break;
			
			case "chkNull":
				
			break;
			
			case "chkNumber":
				
			break;
			
			case "chkObject":
				
			break;
			
			case "chkObjectRepeating":
				
			break;
			
			case "chkString":
				
			break;
			
			case "chkUndefined":
				
			break;
			
			case "clearOutput":
				
			break;
			
			case "gatewayValue":
				
			break;
			
			case "numberValue":
				
			break;
			
			case "output":
				
			break;
			
			case "remoteMethodValue":
				
			break;
			
			case "serviceValue":
				
			break;
			
		    case "stringValue":
				
			break;
			*/
		}
	}       
}
