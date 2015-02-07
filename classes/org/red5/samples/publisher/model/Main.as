package org.red5.samples.publisher.model
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
	 
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	
	import mx.events.*;
	
	import org.red5.samples.publisher.business.*;
	import org.red5.samples.publisher.view.general.Images;
	import org.red5.samples.publisher.vo.*;
	import org.red5.samples.publisher.vo.settings.*;
	
	/**
	 * 
	 * @author Thijs Triemstra
	 */	
	public class Main
	{
		[Bindable]
		/**
		* Fullscreen mode.
		*/		
		public var fullScreen : Boolean;
		
		[Bindable]
		/**
		* 
		*/		
		public var streamName : String;
		
		[Bindable]
		/**
		 * The publish mode can be either 'record', 'live' or 'append'.
		 * 
		 * @see #publishTypes
		*/		
		public var publishMode : int;
		
		[Bindable]	
		/**
		* Flag to check if there's a connection with the RTMP server.
		*/		
		public var netConnected : Boolean;
		
		[Bindable]
		/**
		*
		*/		
		public var previewState : Boolean = false;
		
		/**
		* Playback is paused.
		*/		
		public const pauseState : int = 0;
		
		/**
		* Playback is ongoing.
		*/		
		public const playState : int = 1;
		
		/**
		* Playback has stopped.
		*/		
		public const stopState : int = 2;
		
		[Bindable]
		/**
		 * The playback state can either be 0 (<code>pauseState</code>), 1 (<code>playState</code>),
		 * or 2 (<code>stopState</code>).
		 * 
		 * @see #pauseState
		 * @see #playState
		 * @see #stopState
		*/		
		public var playbackState : int = stopState;
		
		[Bindable]
		/**
		* 
		*/		
		public var publishState : Boolean = false;
	
		[Bindable]
		/**
		 * Default server status message.
		 * 
		 * @default Choose your server and press Connect
		*/		
		public var serverStatusMessage : String = "Choose your server and press Connect";
		
		[Bindable]
		/**
		 * Default audio status message.
		 * 
		 * @default Choose your audio device
		*/		
		public var audioStatusMessage : String = "Choose your audio device";
		
		[Bindable]
		/**
		 * Default video status message.
		 * 
		 * @default Choose your video device
		*/		
		public var videoStatusMessage : String = "Choose your video device";

		/**
		 * URL for the Adobe LiveDocs page.
		 * 
		 * @default http://livedocs.macromedia.com/flex/201/langref/flash/ 
		*/		
		public const docsURL : String = "http://livedocs.macromedia.com/flex/201/langref/flash/";

		/**
		* 
		*/		
		public const btnConnect : String = "Connect";
		
		/**
		* 
		*/		
		public const btnConnected : String = "Close";
		
		[Bindable]
		/**
		* 
		*/		
		public var connectButtonLabel : String =  btnConnect;
		
		/**
		* 
		*/		
		public const btnPlay : String = "Play";
		
		/**
		* 
		*/		
		public const btnStop : String = "Stop";
		
		/**
		* 
		*/		
		public const btnPause : String = "Pause";
		
		[Bindable]
		/**
		* 
		*/		
		public var playButtonLabel : String =  btnPlay;
		
		[Bindable]
		/**
		* 
		*/		
		public var stopButtonLabel : String =  btnStop;

		/**
		* 
		*/		
		public const btnPublish : String = "Publish";
		
		/**
		* 
		*/		
		public const btnUnpublish : String = "Stop";
		
		[Bindable]
		/**
		* 
		*/		
		public var publishButtonLabel : String =  btnPublish;
		
		/**
		* SharedObject to store server presets.
		*/		
		public var mySo : SharedObject = SharedObject.getLocal( "publisher" );
				
		[Bindable] 
		/**
		* 
		*/		
		public var tempServerPreset : ServerPreset;
				
		[Bindable]
		/**
		* All bitmap and artwork is referenced here.
		*/		
		public var images : Images;
		
		[Bindable]
		/**
		* 
		*/		
		public var navigation : Navigation;
		
		[Bindable]
		/**
		* 
		*/		
		public var media : Media;
		
		/**
		* 
		*/		
		public var nc_delegate : NetConnectionDelegate;
		
		/**
		* 
		*/		
		public var ns_delegate : NetStreamDelegate;
				
		[Bindable]
		/**
		* 
		*/		
		public var generalSettings : GeneralSettings;
		
		[Bindable]
		/**
		* 
		*/		
		public var audioSettings : AudioSettings;
		
		[Bindable] 
		/**
		* 
		*/		
		public var videoSettings : VideoSettings;

		/**
		* 
		*/		
		public var orgServerPresets : Array;

		[Bindable]
		/**
		* 
		*/		
		public var serverTypes : Array = new Array();
			
		[Bindable]
		/**
		* 
		*/		
		public var publishTypes : Array =  	 [
										 		{ label: "Live", data: "live" },
										 		{ label: "Record", data: "record" },
										 		{ label: "Append", data: "append" }
										 	 ];
							 	 
		[Bindable]
		/**
		* 
		*/		
		public var objectEncodeTypes : Array =  [	
													{ label: "AMF0", data: ObjectEncoding.AMF0 },
													{ label: "AMF3", data: ObjectEncoding.AMF3 }
											 	];
											 
		[Bindable]
		/**
		* 
		*/		
		public var serverPresets : Array = 	 [	
												new ServerPreset( "localhost oflaDemo",
																  "rtmp://localhost/oflaDemo", 
																  0, 0, 0 ), 
								  				{ label:"------------------------------------" },
								  				{ label:"Save server preset..." },
								  				{ label:"Remove presets..." }
								  			 ];	
								  			 
		[Bindable]
		/**
		* 
		*/		
		public var proxyTypes : Array = 	[
												{ label:"None", data:"none" },
												{ label:"HTTP", data:"HTTP" },
												{ label:"Connect", data:"CONNECT" },
												{ label:"Best", data:"best" }
											];			 
		[Bindable]
		/**
		* 
		*/		
		public var cameraNames : Array = 	[ "No video" ];
		
		[Bindable]
		/**
		* 
		*/		
		public var microphoneNames : Array = [ "No audio" ];		
				 
		/**
		 *
		 */		
		public function Main( nav: Navigation )
		{
			// Create blank general settings VO.
			generalSettings = new GeneralSettings();
			// Create new video settings VO and use default parameters.
			videoSettings = new VideoSettings();
			// Create new video settings VO and use default parameters.
			audioSettings = new AudioSettings();
			// Create references to the bitmap images used in this application.
			images = new Images();
			//
			navigation = nav;
			//
			media = new Media();
			//
			media.videoWidth = videoSettings.width;
        	media.videoHeight = videoSettings.height;
			//
			serverTypes = 	[	
								{ label: "Red5", img: images.red5_img },
								{ label: "Flash Media", img: images.fms_img }
							];
			//
			navigation.settingsArray[ 0 ].img = images.server_img;
			navigation.settingsArray[ 1 ].img = images.webcam_img;
			navigation.settingsArray[ 2 ].img = images.sound_img;
			//
			images.serverLogo = images.red5_img;
			images.settingsIcon = images.server_img;
			//
			images.serverStatusImage = images.goServer_img;
			//		
		    images.audioStatusImage = images.goSound_img;
			//
			images.videoStatusImage = images.goWebcam_img;
			// keep a copy of original presets.
			orgServerPresets = serverPresets.slice();
			// load serverpresets from SharedObjects when available.
			if ( mySo.data.serverPresets != null ) 
			{
				serverPresets = mySo.data.serverPresets;
			}
		}
		
	}
}
