package org.red5.samples.publisher.command 
{	
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
	 
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.net.*;
	
	import org.red5.samples.publisher.events.OpenDocsEvent;
	
	/**
	 * Open the documentation page on Adobe LiveDocs.
	 * 
	 * @see org.red5.samples.publisher.model.Main#docsURL docsURL
	 * @author Thijs Triemstra
	 */	
	public class OpenDocsCommand implements ICommand 
	{		 	
	 	/**
	 	* 
	 	*/	 	
	 	private var path : String;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var documentationUrl : String;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var request : URLRequest;
	 	
	 	/**
	 	 * 
	 	 * @param cgEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var event : OpenDocsEvent = OpenDocsEvent( cgEvent );
			//
			path = event.path;
			//
			documentationUrl = event.url;
			//
			request = new URLRequest( documentationUrl + path );
			//
			try 
			{            
				navigateToURL( request );
			}
			catch ( e : Error ) 
			{
				// handle error here
			}
		}
	}
}
