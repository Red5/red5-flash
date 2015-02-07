package org.red5.samples.publisher.control
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
	 
	import com.adobe.cairngorm.control.FrontController;
	
	import org.red5.samples.publisher.command.*;
	
	/**
	 * 
	 * @author Thijs Triemstra
	 */	
	public class DashboardController extends FrontController
	{
		/**
		 *
		 */		
		public function DashboardController()
		{
			addCommand( DashboardController.EVENT_OPEN_DOCS, OpenDocsCommand );
			
			addCommand( DashboardController.EVENT_SETUP_DEVICES, SetupDevicesCommand );
			
			addCommand( DashboardController.EVENT_SWITCH_MONITOR_VIEW, ChangeMonitorViewCommand );
			addCommand( DashboardController.EVENT_SWITCH_SETTINGS_VIEW, ChangeSettingsViewCommand );
			
			addCommand( DashboardController.EVENT_CLOSE_FULLSCREEN, CloseFullScreenCommand );
			addCommand( DashboardController.EVENT_START_FULLSCREEN, StartFullScreenCommand );
			
			addCommand( DashboardController.EVENT_ENABLE_AUDIO, EnableAudioCommand );
			addCommand( DashboardController.EVENT_ENABLE_VIDEO, EnableVideoCommand );
			
			addCommand( DashboardController.EVENT_START_CAMERA, StartCameraCommand );
			addCommand( DashboardController.EVENT_STOP_CAMERA, StopCameraCommand );
			
			addCommand( DashboardController.EVENT_START_MICROPHONE, StartMicrophoneCommand );
			addCommand( DashboardController.EVENT_STOP_MICROPHONE, StopMicrophoneCommand );
			
			addCommand( DashboardController.EVENT_CHANGE_PRESET, ChangePresetCommand );
			addCommand( DashboardController.EVENT_REMOVE_PRESETS, RemovePresetsCommand );
			addCommand( DashboardController.EVENT_CREATE_PRESET, CreatePresetCommand );
			addCommand( DashboardController.EVENT_SAVE_PRESET, SavePresetCommand );
			
			addCommand( DashboardController.EVENT_SETUP_CONNECTION, SetupConnectionCommand );
			addCommand( DashboardController.EVENT_START_CONNECTION, StartConnectionCommand );
			addCommand( DashboardController.EVENT_CLOSE_CONNECTION, CloseConnectionCommand );
			
			addCommand( DashboardController.EVENT_SETUP_STREAMS, SetupStreamsCommand );
			addCommand( DashboardController.EVENT_STOP_STREAM, StopStreamCommand );
			addCommand( DashboardController.EVENT_PLAY_STREAM, PlayStreamCommand );
			addCommand( DashboardController.EVENT_PAUSE_STREAM, PauseStreamCommand );
			addCommand( DashboardController.EVENT_RESUME_STREAM, ResumeStreamCommand );
			addCommand( DashboardController.EVENT_PUBLISH_STREAM, PublishStreamCommand );
			addCommand( DashboardController.EVENT_UNPUBLISH_STREAM, UnpublishStreamCommand );
		}

		public static const EVENT_OPEN_DOCS : String = 				"EVENT_OPEN_DOCS";
		
		public static const EVENT_SETUP_DEVICES : String = 			"EVENT_SETUP_DEVICES";
		
		public static const EVENT_SWITCH_MONITOR_VIEW : String = 	"EVENT_SWITCH_MONITOR_VIEW";
		public static const EVENT_SWITCH_SETTINGS_VIEW : String = 	"EVENT_SWITCH_SETTINGS_VIEW";
		
		public static const EVENT_CLOSE_FULLSCREEN : String = 		"EVENT_CLOSE_FULLSCREEN";
		public static const EVENT_START_FULLSCREEN : String = 		"EVENT_START_FULLSCREEN";
		
		public static const EVENT_ENABLE_AUDIO : String = 			"EVENT_ENABLE_AUDIO";
		public static const EVENT_ENABLE_VIDEO : String = 			"EVENT_ENABLE_VIDEO";
		
		public static const EVENT_START_CAMERA : String = 			"EVENT_START_CAMERA";
		public static const EVENT_STOP_CAMERA : String = 			"EVENT_STOP_CAMERA";
		
		public static const EVENT_START_MICROPHONE : String = 		"EVENT_START_MICROPHONE";
		public static const EVENT_STOP_MICROPHONE : String = 		"EVENT_STOP_MICROPHONE";
		
		public static const EVENT_CHANGE_PRESET : String = 			"EVENT_CHANGE_PRESET";
		public static const EVENT_REMOVE_PRESETS : String = 		"EVENT_REMOVE_PRESETS";
		public static const EVENT_CREATE_PRESET : String = 			"EVENT_CREATE_PRESET";
		public static const EVENT_SAVE_PRESET : String = 			"EVENT_SAVE_PRESET";
		
		public static const EVENT_START_CONNECTION : String = 		"EVENT_START_CONNECTION";
		public static const EVENT_CLOSE_CONNECTION : String = 		"EVENT_CLOSE_CONNECTION";
		public static const EVENT_SETUP_CONNECTION : String = 		"EVENT_SETUP_CONNECTION";
		
		public static const EVENT_SETUP_STREAMS : String = 			"EVENT_SETUP_STREAMS";
		public static const EVENT_STOP_STREAM : String = 			"EVENT_STOP_STREAM";
		public static const EVENT_PLAY_STREAM : String = 			"EVENT_PLAY_STREAM";
		public static const EVENT_PAUSE_STREAM : String = 			"EVENT_PAUSE_STREAM";
		public static const EVENT_RESUME_STREAM : String = 			"EVENT_RESUME_STREAM";
		public static const EVENT_PUBLISH_STREAM : String = 		"EVENT_PUBLISH_STREAM";
		public static const EVENT_UNPUBLISH_STREAM : String = 		"EVENT_UNPUBLISH_STREAM";
	}
}
