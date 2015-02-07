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



import org.red5.utils.Delegate;

import com.gskinner.events.GDispatcher;

import org.red5.net.Connection;



class org.red5.utils.GlobalObject

{

// Constants:

	public static var CLASS_REF = org.red5.utils.GlobalObject;

// Public Properties:

	public var addEventListener:Function;

	public var removeEventListener:Function;

	public var soName:String;	

	public var connected:Boolean;

	public var data:Object;

	public var so:SharedObject;

// Private Properties:

	private var dispatchEvent:Function;

	

	private var nc:Connection;



// Initialization:

	public function GlobalObject()

	{

		super();

		GDispatcher.initialize(this);

	}



// Public Methods:



	public function connect(p_soName:String, p_nc:Connection, p_persistant:Boolean):Boolean

	{

		// store Connection reference

		nc = p_nc;

		

		// create StoredObject

		so = SharedObject.getRemote(p_soName, nc.uri, p_persistant); 

		

		// setup the onSync events

		so.onSync = Delegate.create(this, onStatus);

		

		// connect to the SO

		connected = so.connect(nc);

		

		return connected;

	}

	

	// status for the sharedobject

	private function onStatus(evtObj):Void

	{

		// an update has been recieved, send out to the concerned parties

		dispatchEvent({type:"onSync"});

	}

// Semi-Private Methods:

// Private Methods:

	public function getData(p_key:String)

	{

		// if no value, return null

		if (so.data[p_key] == undefined) return null;

		return so.data[p_key];

	}



	public function setData(p_key:String, p_value):Void 

	{

		// updating the key causes the SO to update on the server.

		so.data[p_key] = p_value;

	}

	

	public function clear():Void

	{

		// clear not supported on Red5 yet

		so.clear();

	}

}
