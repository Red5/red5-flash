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
	
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.controls.TextInput;
	import mx.core.Application;
	
	/**
	 * Runs 8 RTMP port tests.
	 * 
	 * @author Thijs Triemstra ( info@collab.nl )
	*/	
	public class Main extends Application
	{
		private static const  rtmp 	: String = "rtmp";
		private static const rtmpt 	: String = "rtmpt";
		
		[Bindable]
		public var flashVersion 	: String;
		
		[Bindable]
		public var testResults 		: ArrayCollection;
		
		public var hostname 		: String;
		public var application 		: String;
		public var host_txt 		: TextInput;
		public var app_txt 			: TextInput;
		
		/**
		 * 
		 */				
		public function Main(): void
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
		 * Start the RTMP port tests.
		 */		
		public function runTests(): void
		{
			hostname = host_txt.text;
			application = app_txt.text;
			// Create 8 tests that automatically connect and disconnect with the RTMP server.
			testResults = new ArrayCollection( [ new PortTest( rtmp, 	hostname, 	"", 		application ),
												 new PortTest( rtmp, 	hostname, 	"80", 		application ),
												 new PortTest( rtmp, 	hostname, 	"443", 		application ),
												 new PortTest( rtmp, 	hostname, 	"1935", 	application ),
												 new PortTest( rtmpt, 	hostname, 	"",			application ),
												 new PortTest( rtmpt, 	hostname, 	"80", 		application ),
												 new PortTest( rtmpt, 	hostname, 	"443", 		application ),
												 new PortTest( rtmpt, 	hostname, 	"1935", 	application ) ] );
		}
	}
}
