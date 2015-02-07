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
	
	import org.red5.samples.publisher.events.StartCameraEvent;
	import org.red5.samples.publisher.model.*;
	
	/**
	 * Start and monitor the <code>camera</code> video device.
	 * 
	 * @see org.red5.samples.publisher.model.Media#camera camera
	 * @author Thijs Triemstra
	 */	
	public class StartCameraCommand implements ICommand 
	{
		/**
		* 
		*/			
		private var model : ModelLocator = ModelLocator.getInstance();
	 	
	 	[Bindable]
	 	/**
	 	* 
	 	*/	 	
	 	public var main : Main = model.main;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var logger : Logger = model.logger;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var camera : Camera = main.media.camera;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var nsPublish : NetStream = main.media.nsPublish;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var videoLocal : Video = main.media.videoLocal;
	 	
	 	/**
	 	 * 
	 	 * @param cgEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var event : StartCameraEvent = StartCameraEvent( cgEvent );
			//
			var selectedCamIndex : int = 	event.selectedCamIndex;
			var keyFrameInterval : int = 	event.keyFrameInterval;
			var cameraWidth : int = 		event.cameraWidth;
			var cameraHeight : int = 		event.cameraHeight;
			var cameraFPS : int = 			event.cameraFPS;
			var cameraBandwidth : int = 	event.cameraBW;
			var cameraQuality : int = 		event.cameraQuality;
			var cameraIndex : String =		String( selectedCamIndex - 1 );
			//
			main.media.camera = Camera.getCamera( cameraIndex );
			camera = main.media.camera;
			//
			camera.setKeyFrameInterval( keyFrameInterval );
			camera.setMode( cameraWidth, cameraHeight, cameraFPS );
			camera.setQuality( cameraBandwidth, cameraQuality );
			//
			camera.addEventListener( ActivityEvent.ACTIVITY, activityEventHandler );
			camera.addEventListener( StatusEvent.STATUS, statusEventHandler );
			// update video stream when publishing
			if ( nsPublish != null ) 
			{
				nsPublish.attachCamera( camera );
			}
			//
			logger.logMessage( "Started video device <b>" + camera.name + "</b>",
							   logger.videoMessage );
			logger.monitorMessage(  "Started video device", 
									main.images.webcam_img, 
									logger.videoMessage );
			//
			main.media.videoLocal = new Video( 320, 240 );
			main.media.videoLocal.attachCamera( camera );
			// show video container for preview.
			main.previewState = true;
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
