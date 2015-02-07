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
	import flash.net.*;
	
	import mx.rpc.IResponder;
	
	import org.red5.samples.publisher.business.*;
	import org.red5.samples.publisher.events.*;
	import org.red5.samples.publisher.model.*;
	
	/**
	 * Setup two NetStreams for publishing and playback.
	 * <p>The NetStreams are stored in the Model.</p>
	 * 
	 * @see org.red5.samples.publisher.model.Media#nsPlay nsPlay
	 * @see org.red5.samples.publisher.model.Media#nsPublish nsPublish
	 * @author Thijs Triemstra
	 */	
	public class SetupStreamsCommand implements ICommand, IResponder 
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
	 	private var streamMessage : String = logger.streamMessage;
	 	
	 	/**
		* 
		*/		
		private var metadataMessage : String = logger.metadataMessage;
		
		/**
		* 
		*/		
		private var cuepointMessage : String = logger.cuepointMessage;

	 	/**
	 	* 
	 	*/	 	
	 	private var playbackFinished : Boolean = false;
	 
	 	/**
	 	 * 
	 	 * @param cgEvent
	 	 */	 	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var event : SetupStreamsEvent = SetupStreamsEvent( cgEvent );
			// Generate unique streamname.
			main.streamName = "stream" + String( Math.floor( new Date().getTime() ) );
			// Setup the permanent Delegate to create NetStreams.
			main.ns_delegate = new NetStreamDelegate( this );
		}
		
		/**
		 * The result method is called when the delegate receives 
		 * a result from the service.
		 * 
		 * @param event
		 */		
		public function result(  event : Object  ) : void 
		{
			var info : Object = event.info;
			var statusCode : String = info.code;
			var ns_type : String = "Playback";
			//
			switch ( statusCode ) {
				case "NetStream.Play.Start" :
					// Start playback.
					playbackStarted();
					break;
					
				case "NetStream.Play.Stop":	
					playbackFinished = true;		
					break;
				
				case "NetStream.Buffer.Empty":	
					//
					if ( playbackFinished ) 
					{
						// Playback stopped.
						playbackStopped();
					}		
					break;
				
				case "NetStream.Play.UnpublishNotify":
					// Playback stopped.
					if ( playbackFinished )
					{
						playbackStopped();
					}
					break;
					
				case "NetStream.Play.StreamNotFound":
					//
					playbackStopped();
					break;
				
				case "NetStream.Pause.Notify":
					break;
					
				case "NetStream.Unpause.Notify":
					break;
					
				case "NetStream.Publish.Start":
					ns_type = "Publish";
					break;
					
				case "NetStream.Publish.Idle":
					ns_type = "Publish";
					break;
					
				case "NetStream.Record.Failed":
					ns_type = "Publish";
					break;
					
				case "NetStream.Record.Stop":
					ns_type = "Publish";
					break;
					
				case "NetStream.Record.Start":
					ns_type = "Publish";
					break;
					
				case "NetStream.Unpublish.Success":
					ns_type = "Publish";
					break;
					
				case "NetStream.Publish.BadName":
					ns_type = "Publish";
					//
					publishStopped();
					break;
			}
			//
			logger.logMessage( ns_type + " - " + statusCode, streamMessage );
		}
		
		/**
		 * 
		 */		
		private function playbackStarted() : void
		{
			//
			playbackFinished = false;
			//
			main.playbackState = main.playState;
		}
					
		/**
		 * 
		 */		
		private function playbackStopped() : void
		{
			//
			playbackFinished = false;
			//
			main.playButtonLabel = main.btnPlay;
			//
			main.playbackState = main.stopState;
		}
		
		/**
		 * 
		 */		
		private function publishStopped() : void 
		{
			//
			main.publishButtonLabel = main.btnPublish;
			//
			main.publishState = false;
		}
		
		/**
		 * The fault method is called when the delegate receives a fault
		 * from the service.
		 * 
		 * @param event
		 */		
		public function fault(  event : Object  ) : void
		{
			//
			logger.logMessage ( event.text, streamMessage );
		}
		
		/**
		 * <p>Not available for FCS 1.5.</p>
		 * 
		 * @param info
		 */		
		public function onPlayStatus( info : Object ) : void 
		{	
			//
			logger.logMessage( "Playback - " + info.code, streamMessage );
		}
		
		/**
		 * 
		 * @param info
		 */		
		public function onMetaData ( info : Object ) : void 
		{
			for ( var d : String in info ) 
			{
				logger.logMessage( "Metadata - " + d + ": " + info[ d ], metadataMessage );
			}
		}
				
		/**
		 * 
		 * @param info
		 */		
		public function onCuePoint( info : Object ) : void 
		{
			for ( var d : String in info ) 
			{
				logger.logMessage( "Cuepoint - " + d + ": " + info[ d ], cuepointMessage );
			}
		}
		
	}
}
