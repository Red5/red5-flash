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
package org.red5.samples.echo.commands
{	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.NetConnection;
	
	import org.red5.samples.echo.events.SetupConnectionEvent;
	import org.red5.samples.echo.model.ModelLocator;
	
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	 */	
	public class SetupConnectionCommand implements ICommand 
	{		 	
	 	private var _model : ModelLocator = ModelLocator.getInstance();
	 	
	 	/**
	 	 * @param cgEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var event : SetupConnectionEvent = SetupConnectionEvent( cgEvent );
			
			// load url's from flookie when present
        	if ( _model.local_so.data.rtmpUri != null )
        	{
        		_model.rtmpServer = _model.local_so.data.rtmpUri;
        	}
        	if ( _model.local_so.data.httpUri != null )
        	{
        		_model.httpServer = _model.local_so.data.httpUri;
        	}
        	
        	if ( _model.local_so.data.httpMethod != null )
        	{
        		_model.httpMethod = _model.local_so.data.httpMethod;
        	}
        	if ( _model.local_so.data.rtmpMethod != null )
        	{
        		_model.rtmpMethod = _model.local_so.data.rtmpMethod;
        	}
        	
        	// Setup a single NetConnection for every test suite.
			_model.nc = new NetConnection();
		}
		
	}
}
