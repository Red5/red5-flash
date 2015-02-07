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



import com.gskinner.events.GDispatcher;

//import org.red5.utils.Delegate;



class org.red5.net.Connection extends NetConnection

{

// Constants:

	public static var CLASS_REF = org.red5.net.Connection;

// Public Properties:

	public var addEventListener:Function;

	public var removeEventListener:Function;

	public var connected:Boolean;

	//public var nc:NetConnection;

// Private Properties:

	private var dispatchEvent:Function;	



// Initialization:

	public function Connection() 

	{

		super();

		GDispatcher.initialize(this);

	}



// Public Methods:

	public function connect():Boolean

	{

		// if the URI is valid, it will return true.  This does NOT mean it's connected however.

		var goodURI:Boolean = super.connect.apply(super, arguments);

		

		return goodURI;

	}

	

	public function close():Void

	{

		// closes the connection to red5

		dispatchEvent({type:"connectionChange", connected:connected});

		super.close();

	}

// Semi-Private Methods:

// Private Methods:

	private function onStatus(evtObj:Object):Void

	{

		switch(evtObj.code)

		{

			case "NetConnection.Connect.Success":

				connected = true;

				dispatchEvent({type:"success", code:evtObj.code, connected:true});

				break;

			

			case "NetConnection.Connect.Closed":

				connected = false;

				dispatchEvent({type:"close", code:evtObj.code, connected:false});

				break;

			

			case"NetConnection.Connect.Failed":

				connected = false;

				dispatchEvent({type:"failed", code:evtObj.code, connected:false});

			break;

			

			case"NetConnection.Connect.AppShutdown":

				connected = false;

				dispatchEvent({type:"appShutDown", code:evtObj.code});

			break;

			

			case"NetConnection.Call.Failed":

				dispatchEvent({type:"callFailed", code:evtObj.code});

			break;

			

			case"NetConnection.Connect.InvalidApp":

				dispatchEvent({type:"invalidApp", code:evtObj.code});

			break;

			

			case"NetConnection.Connect.Rejected":

				dispatchEvent({type:"rejected", code:evtObj.code});

			break;

		}

		

		dispatchEvent({type:evtObj.level.toLowerCase(), code:evtObj.code, description:evtObj.description, details:evtObj.details});

	}

}

