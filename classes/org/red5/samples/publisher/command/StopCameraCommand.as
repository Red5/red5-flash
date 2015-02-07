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
	import flash.media.Camera;
	
	import org.red5.samples.publisher.model.*;
	
	/**
	 * Stop and disconnect the <code>camera</code> video device.
	 * 
	 * @see org.red5.samples.publisher.model.Media#camera camera
	 * @author Thijs Triemstra
	 */	
	public class StopCameraCommand implements ICommand 
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
	 	 * @param cgEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 			
			// Hide video container.
			main.previewState = false;
			//
			logger.logMessage( "Disabled video device", logger.videoMessage );
			logger.monitorMessage( "Choose your video device", 
								   main.images.goWebcam_img, 
								   logger.videoMessage );
			// Disconnect video device.
			main.media.videoLocal.attachCamera( null );
			// Update video stream when publishing.
			if ( main.media.nsPublish != null ) 
			{
				//
				main.media.nsPublish.attachCamera( null );
			}
		}
		
	}
}
