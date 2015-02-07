package org.red5.samples.porttester
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
	 
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	[Bindable]
	/**
	 * Test RTMP port.
	 * 
	 * @author Thijs Triemstra ( info@collab.nl )
	 */	
	public class PortTest 
	{
		/**
		* Protocol name.
		*/		
		private var protocol 		: String;
		
		/**
		* Protocol name (uppercase).
		*/		
		public var protocolName 	: String;
		
		/**
		* RTMP hostname.
		*/		
		private var hostname 		: String;
		
		/**
		* RTMP port.
		*/		
		public var port 			: String;
		
		/**
		* RTMP port.
		*/		
		public var portName 		: String = "Default";
		
		/**
		* RTMP application.
		*/		
		private var application 	: String;

		/**
		* Base RTMP URI.
		*/		
		private var baseURI 		: String;
		
		/**
		* RTMP connection.
		*/		
		public var nc 				: NetConnection;
		
		/**
		* Connection status.
		*/		
		public var status 			: String;
		
		/**
		* Set default encoding to AMF0 so FMS also understands.
		*/		
		NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
		
		/**
		 * Create new port test and connect to the RTMP server.
		 * 
		 * @param protocol
		 * @param hostname
		 * @param port
		 * @param application
		 */			
		public function PortTest( protocol : String = "",
								  hostname : String = "",
								  port : String = "",
								  application : String = "" ) 
		{
			this.protocol = protocol;
			this.protocolName = protocol.toUpperCase();
			this.hostname = hostname;
			this.application = application;
			if ( port.length > 0 )
			{
				this.portName = port;
				this.port = ":" + port;
			}
			else 
			{
				this.port = port;
			}
			// Construct URI.
			this.baseURI = this.protocol + "://" + this.hostname + this.port + "/" + this.application;
			//
			connect();
		}
		
		/**
		 * Start connection.
		 */		
		private function connect() : void
		{
			this.nc = new NetConnection();
			this.nc.client = this;
			this.nc.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			// connect to server
			try 
			{
				// Create connection with the server.
				this.nc.connect( this.baseURI );
				status = "Connecting...";
			}
			catch( e : ArgumentError ) 
			{
				// Invalid parameters.
				status = "ERROR: " + e.message;
			}	
		}
		
		/**
		 * Close connection.
		 */		
		public function close() : void
		{	
			// Remove listener.
			this.nc.removeEventListener( NetStatusEvent.NET_STATUS, netStatus );
			// Close the NetConnection.
			this.nc.close();
		}
			
		/**
		 * Catch NetStatusEvents.
		 * 
		 * @param event
		 */		
		protected function netStatus( event : NetStatusEvent ) : void 
		{
			var info : Object = event.info;
			var statusCode : String = info.code;
			//
			if ( statusCode == "NetConnection.Connect.Success" )
			{
				status = "SUCCESS";
			}
			else if ( statusCode == "NetConnection.Connect.Rejected" ||
				 	  statusCode == "NetConnection.Connect.Failed" || 
				 	  statusCode == "NetConnection.Connect.Closed" ) 
			{
				status = "FAILED";
			}
			// Close NetConnection.
			close();
		}
		
		/**
		 * The Red5 oflaDemo returns bandwidth stats.
		 */		
		public function onBWDone() : void {	}
		
	}
}
