package org.red5.samples.pausetester
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
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	import mx.controls.NumericStepper;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.Application;
	
	/**
	 * 
	 * 
	 * @author Thijs Triemstra ( info@collab.nl )
	*/	
	public class Main extends Application
	{
		[Bindable]
		public var flashVersion 	: String;
		
		[Bindable]
		public var controlsEnabled	: Boolean = false;
		
		[Bindable]
		public var video			: Video;
		
		[Bindable]
		public var videoWidth		: int	= 320;
		
		[Bindable]
		public var videoHeight		: int	= 240;
		
		public var hostname 		: String;
		public var application 		: String;
		public var streamname		: String;
		public var host_txt 		: TextInput;
		public var app_txt 			: TextInput;
		public var stream_txt 		: TextInput;
		public var status_txt		: TextArea;
		public var nc				: NetConnection;
		public var ns				: NetStream;
		public var bufferTime		: NumericStepper;
		
		/**
		* Base RTMP URI.
		*/		
		private var _baseURI 		: String;
		
		/**
		 * 
		 */				
		public function Main() : void
		{
			var platformVersion : String = Capabilities.version.substr( String( Capabilities.version ).lastIndexOf(" ") + 1 );
			var manufacturer : String = Capabilities.manufacturer;
			// Get Flash Player version info.
			flashVersion = "FP " + platformVersion;
			//
			if ( Capabilities.isDebugger ) 
			{
				// Add debugger info.
				flashVersion += " (debug)";
			}
		}
		
		/**
		 * Start the pause test.
		 */		
		public function startTest() : void
		{
			hostname = host_txt.text;
			application = app_txt.text;
			//
			connect();
		}
		
		public function playStream(): void
		{
			streamname = stream_txt.text;
			ns.play( streamname );
		}
		
		public function pauseStream(): void
		{
			ns.pause();
		}
		
		public function resumeStream(): void
		{
			ns.resume();
		}
		
		public function stopStream(): void
		{
			ns.play(false);
		}
		
		public function clearText(): void 
		{
			status_txt.text = "";
		}
		
		/**
		 * Start connection.
		 */		
		private function connect() : void
		{
			if ( nc != null ) {
				ns.close();
			}
			nc = new NetConnection();
			nc.client = this;
			nc.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			// Construct URI.
			_baseURI = "rtmp://" + hostname + "/" + application;
			// connect to server
			try 
			{
				// Create connection with the server.
				nc.connect( _baseURI );
				status_txt.text += "Connecting... \n";
			}
			catch( e : ArgumentError ) 
			{
				// Invalid parameters.
				status_txt.text += "ERROR: " + e.message + "\n";
			}	
		}
		
		/**
		 * Close connection.
		 */		
		private function close() : void
		{	
			// Remove listener.
			nc.removeEventListener( NetStatusEvent.NET_STATUS, netStatus );
			// Close the NetConnection.
			nc.close();
		}
			
		/**
		 * Catch NetStatusEvents.
		 * 
		 * @param event
		 */		
		private function netStatus( event : NetStatusEvent ) : void 
		{
			var info : Object = event.info;
			var statusCode : String = info.code;
			//
			if ( statusCode == "NetConnection.Connect.Success" )
			{
				controlsEnabled = true;
				//
				ns = new NetStream( nc );
				ns.client = this;
				ns.bufferTime = bufferTime.value;
				ns.addEventListener( NetStatusEvent.NET_STATUS, streamStatus );
				video = new Video( videoWidth, videoHeight);
				video.attachNetStream( ns );
			}
			else if ( statusCode == "NetConnection.Connect.Rejected" ||
				 	  statusCode == "NetConnection.Connect.Failed" || 
				 	  statusCode == "NetConnection.Connect.Closed" ) 
			{
				
			}
			status_txt.text += statusCode + "\n";
			// Close NetConnection.
			close();
		}
		
		private function streamStatus( event : NetStatusEvent ): void
		{
			var statusCode : String = event.info.code;
			switch ( statusCode )
			{
				case "NetStream.Play.Start":
					//
			}
			status_txt.text += statusCode + "\n";
		}
		
		/**
		 * The Red5 oflaDemo returns bandwidth stats.
		 */		
		public function onBWDone() : void {}
		
		public function onMetaData( data:Object ) : void 
		{
			// status_txt.text += ObjectUtil.toString( data ) + "\n";
		}
		
		public function onPlayStatus( obj:Object ): void 
		{
			status_txt.text += obj.code + "\n";
		}
	}
}
