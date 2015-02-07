package org.red5.samples.publisher.view.general
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
	
	[Bindable]
	/**
	 * Collection of all bitmaps and icons used in this application.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class Images
	{
		/**
		* 
		*/		
		public var serverLogo : Class;

		/**
		* 
		*/		
		public var settingsIcon : Class;
		
		/**
		* 
		*/		
		public var serverStatusImage : Class;
		
		/**
		* 
		*/		
		public var audioStatusImage : Class;
		
		/**
		* 
		*/		
		public var videoStatusImage : Class;
		
		[Embed(source="../images/server_go.png")]
		/**
		* Create connection with server.
		*/		
		public var goServer_img:Class;
		
		[Embed(source="../images/webcam_add.png")]
		/**
		* Setup video device.
		*/		
		public var goWebcam_img:Class;
		
		[Embed(source="../images/sound_add.png")]
		/**
		* Setup audio device.
		*/		
		public var goSound_img:Class;
		
		[Embed(source="../images/server.png")]
		/**
		* Server settings.
		*/			
		public var server_img:Class;
		
		[Embed(source="../images/webcam.png")]
		/**
		* Video device settings.
		*/			
		public var webcam_img:Class;
		
		[Embed(source="../images/sound.png")]
		/**
		* Audio device settings.
		*/			
		public var sound_img:Class;
			
		[Embed(source="../images/monitor.png")]
		/**
		* Monitor display.
		*/		
		public var monitor_img:Class;
		
		[Embed(source="../images/report.png")]
		/**
		* Log display.
		*/		
		public var log_img:Class;
		
		[Embed(source="../images/red5.png")]
		/**
		* Red5 logo.
		*/		
		public var red5_img:Class;
		
		[Embed(source="../images/fms.gif")]
		/**
		* FMS logo.
		*/		
		public var fms_img:Class;
		
		[Embed(source="../images/server_lightning.png")]
		/**
		* Server connection error.
		*/		
		public var warnServer_img:Class;

		[Embed(source="../images/webcam_delete.png")]
		/**
		* Video device permissions error.
		*/		
		public var deniedWebcam_img:Class;

		[Embed(source="../images/sound_delete.png")]
		/**
		* Audio device permissions error.
		*/		
		public var deniedSound_img:Class;

		[Embed(source="../images/server_connect.png")]
		/**
		* Starting connection with server.
		*/		
		public var connectServer_img:Class;
		
		[Embed(source="../images/server_error.png")]
		/**
		* Can't connect to server.
		*/		
		public var errorServer_img:Class;
		
		[Embed(source="../images/server_link.png")]
		/**
		* Connected to server.
		*/		
		public var linkServer_img:Class;
		
		[Embed(source="../images/server_key.png")]
		/**
		* Connected to secure server with SSL.
		*/		
		public var secureServer_img:Class;
	}
}
