package org.red5.samples.publisher.view.monitor
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
	 
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	
	import flash.events.*;
	
	import mx.containers.Box;
	import mx.controls.*;
	import mx.events.*;
	
	import org.red5.samples.publisher.events.*;
	import org.red5.samples.publisher.model.*;
	
	/**
	 * 
	 * @author Thijs Triemstra
	 */	
	public class MonitorControlBarClass extends Box
	{		
		[Bindable]
		/**
		*
		*/			
		public var main : Main;
		
		[Bindable]
		/**
		*
		*/			
		public var navigation : Navigation;
		
		[Bindable]
		public var monitorPodHeight : int;
		
		/**
		* Server preset ComboBox.
		*/		
		public var publish_cb : ComboBox;
		
		[Bindable]
		/**
		* New playback stream name.
		*/		
		public var playback_txt : TextInput;
		
		[Bindable]
		/**
		* New publisher stream name.
		*/		
		public var publish_txt : TextInput;
		
		[Bindable]
		/**
		* Enable audio CheckBox.
		*/		
		public var enableAudio : CheckBox;
		
		[Bindable]
		/**
		* Enable video CheckBox.
		*/		
		public var enableVideo : CheckBox;
		
		[Bindable]
		/**
		* Stream name is too short.
		*/		
		public var tooShortError : String = "This name is shorter than the minimum allowed length.";
		
		/**
		 * View, pause or resume the NetStream.
		 */		
		public function viewStream() : void
		{
			var bufferTime : int = main.generalSettings.bufferTime;
			var streamName : String = playback_txt.text;
			//
			if ( main.netConnected ) 
			{
				//
				if ( main.playbackState == main.playState ) 
				{
					// Pause playback.
					var pauseStreamEvent : PauseStreamEvent = new PauseStreamEvent();
					pauseStreamEvent.dispatch();
					
				} 
				else if ( main.playbackState == main.stopState )
				{
					// Start playback from beginning.
					var playStreamEvent : PlayStreamEvent = new PlayStreamEvent( bufferTime, 
																				 streamName,
																				 enableVideo.selected,
																				 enableAudio.selected );
					playStreamEvent.dispatch();
				} 
				else if ( main.playbackState == main.pauseState )
				{
					// Resume playback.
					var resumeStreamEvent : ResumeStreamEvent = new ResumeStreamEvent();
					resumeStreamEvent.dispatch(); 
				}
			}
		}
		
		/**
		 * Stop NetStream playback.
		 */		
		public function stopStream() : void
		{
			if ( main.netConnected )
			{
				// Stop playback and close stream.
				var stopStreamEvent : StopStreamEvent = new StopStreamEvent();
				stopStreamEvent.dispatch();
			}
		}
		
		/**
		 * Create new NetStream.
		 */		
		public function recordStream() : void
		{
			var publishMode : String = publish_cb.selectedItem.data;
			var streamName : String = publish_txt.text;
			//
			main.publishState = ( main.publishButtonLabel == main.btnPublish );
			//
			if ( main.netConnected ) 
			{
				//
				if ( main.publishState ) 
				{
					// Start publishing.
					var publishStreamEvent : PublishStreamEvent = new PublishStreamEvent( publishMode, streamName );
					publishStreamEvent.dispatch();
				} 
				else
				{
					// Stop publishing.
					var unpublishStreamEvent : UnpublishStreamEvent = new UnpublishStreamEvent();
					unpublishStreamEvent.dispatch();
				}
			}
		}
		
		/**
         * Enable/disable audio for the playback NetStream.
         */        
        public function toggleAudio() : void
        {
        	// Enable and disable audio.
			var toggleAudioEvent : EnableAudioEvent = new EnableAudioEvent( enableAudio.selected );
			toggleAudioEvent.dispatch();
        }
        
        /**
         * Enable/disable video for the playback NetStream.
         */        
        public function toggleVideo() : void
        {
        	// Enable and disable audio.
			var toggleVideoEvent : EnableVideoEvent = new EnableVideoEvent( enableVideo.selected );
			toggleVideoEvent.dispatch();
        }
        
		/**
         * Toggle fullscreen mode with CheckBox.
        */		
        public function toggleFullScreen( event : MouseEvent ) : void
        {
        	//
        	if ( event == null )
        	{
        		main.fullScreen = false;
        	}
        	else
        	{
        		main.fullScreen = event.target.selected;
        	}
        	//
            if ( main.fullScreen )
            {
                //
	        	stage.addEventListener( FullScreenEvent.FULL_SCREEN, keyToggleFullScreen );
	        	// Start fullscreen mode.
				var startFullScreenEvent : StartFullScreenEvent = new StartFullScreenEvent( stage );
				startFullScreenEvent.dispatch();
            }
            else 
            {
            	// Close fullscreen mode.
				var closeFullScreenEvent : CloseFullScreenEvent = new CloseFullScreenEvent( stage );
				closeFullScreenEvent.dispatch();
            }
        }

        /**
         * Toggle fullscreen mode with ESC key.
         */		
        private function keyToggleFullScreen( event : FullScreenEvent ) : void 
        {
        	// Toggle checkbox when ESC key was used to exit fullscreen mode.
        	main.fullScreen = event.fullScreen;
        	// Returned to normal mode, triggered by ESC key.
        	if ( !event.fullScreen )
        	{
	        	// Close fullscreen mode.
				toggleFullScreen( null );
	        }
        }
        
	}
}
