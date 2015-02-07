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
	
	import flash.events.*;
	import flash.media.*;
	import flash.net.NetStream;
	
	import org.red5.samples.publisher.events.StartMicrophoneEvent;
	import org.red5.samples.publisher.model.*;

	/**
	 * Start and monitor the <code>microphone</code> audio device.
	 * 
	 * @see org.red5.samples.publisher.model.Media#microphone microphone
	 * @author Thijs Triemstra
	 */
	public class StartMicrophoneCommand implements ICommand 
	{	
		/**
		* 
		*/			
		private var model : ModelLocator = ModelLocator.getInstance();
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var main : Main = model.main;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var logger : Logger = model.logger;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var microphone : Microphone = main.media.microphone;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var nsPublish : NetStream = main.media.nsPublish;
	 	
	 	/**
	 	 * 
	 	 * @param cgEvent
	 	 */	 		
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var event : StartMicrophoneEvent = StartMicrophoneEvent( cgEvent );
			var selectedMicIndex : int = 	event.selectedMicIndex;
			var gain : int = 				event.gain;
			var rate : int = 				event.rate;
			var level : int = 				event.level;
			var timeout : int = 			event.timeout;
			var micIndex : int = 			selectedMicIndex - 1;
			//
			main.media.microphone = Microphone.getMicrophone( micIndex );
			microphone = main.media.microphone;
			//
			microphone.setLoopBack( true );
			//
			var transform : SoundTransform = microphone.soundTransform;
			transform.volume = 0;
			//
			microphone.setUseEchoSuppression( true );
			microphone.soundTransform = transform;
			microphone.gain = gain;
			microphone.rate = rate;
			microphone.setSilenceLevel( level, timeout );
			//
			microphone.addEventListener( ActivityEvent.ACTIVITY, activityEventHandler );
			microphone.addEventListener( StatusEvent.STATUS, statusEventHandler );
			// update audio stream when we're already publishing.
			if ( nsPublish != null ) 
			{
				//
				nsPublish.attachAudio( microphone );
			}
			// 
			logger.logMessage( "Started audio device <b>" + microphone.name + "</b>",
							   logger.audioMessage );
			logger.monitorMessage( 	"Started audio device", 
									main.images.sound_img,
									logger.audioMessage );
		}
		
		/**
		 * 
		 * @param event
		 */		
		private function activityEventHandler( event : ActivityEvent ) : void 
		{
			//trace( "activityEventHandler: " + event );
		}
		
		/**
		 * 
		 * @param event
		 */		
		private function statusEventHandler( event : StatusEvent ) : void 
		{
			//trace( "statusEventHandler: " + event );
		}
		
	}
}
