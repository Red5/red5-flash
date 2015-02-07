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
	import org.red5.samples.publisher.view.general.Images;
	
	/**
	 * Setup a new NetConnection with the RTMP server.
	 * <p>The NetConnection is stored in the Model.</p>
	 * 
	 * @see org.red5.samples.publisher.model.Media#nc nc
	 * @author Thijs Triemstra
	 */	
	public class SetupConnectionCommand implements ICommand, IResponder 
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
	 	private var serverMessage : String = logger.serverMessage;
	 	
	 	/**
	 	* 
	 	*/	 	
	 	private var images : Images = main.images;
	 
	 	/**
	 	 * 
	 	 * @param cgEvent
	 	 */	 	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    {
			var event : SetupConnectionEvent = SetupConnectionEvent( cgEvent );
			// Setup the permanent Delegate to manage the NetConnection.
			main.nc_delegate = new NetConnectionDelegate( this );
		}
		
		/**
		 * 
		 * The result method is called when the delegate receives 
		 * a result from the service
		 * 
		 * @param event
		 */		
		public function result(  event : Object  ) : void {
			var info : Object = event.info;
			var statusCode : String = info.code;
			//
			logger.logMessage( statusCode, serverMessage );
			// Change the label of the connect Button so a connection can be created.
			main.connectButtonLabel = main.btnConnect;
			//
			main.netConnected = false;
			//
			switch ( statusCode ) 
			{
				case "NetConnection.Connect.Success" :
					//
					main.netConnected = true;
					// Change the label of the Button so the connection can be closed.
					main.connectButtonLabel = main.btnConnected;
					// find out if it's a secure (HTTPS/TLS) connection
					if ( event.target.connectedProxyType == "HTTPS" || event.target.usingTLS ) {
						logger.monitorMessage( 	"Connected to secure server", 
												images.secureServer_img, 
												serverMessage );
					} else {
						logger.monitorMessage(	"Connected to server", 
												images.linkServer_img,
												serverMessage );
					}
					break;
			
				case "NetConnection.Connect.Failed" :
					//
					serverDisconnect();
					//
					logger.monitorMessage(	"Connection to server failed",
											 images.errorServer_img, serverMessage );
					break;
					
				case "NetConnection.Connect.Closed" :
					//
					serverDisconnect();
					//
					logger.monitorMessage(	"Connection to server closed", 
											images.goServer_img, serverMessage );
					break;
					
				case "NetConnection.Connect.InvalidApp" :
					//
					logger.monitorMessage(	"Application not found on server",
											images.warnServer_img, serverMessage );
					break;
					
				case "NetConnection.Connect.AppShutDown" :
					//
					logger.monitorMessage(	"Application has been shutdown", 
											images.goServer_img, serverMessage );
					break;
					
				case "NetConnection.Connect.Rejected" :
					//
					logger.monitorMessage(	"No permissions to connect to the application",
											images.warnServer_img, serverMessage );
					break;
					
				default :
				   // statements
				   break;
			}
		}
		
		/**
		 * The fault method is called when the delegate receives a fault from the service
		 * 
		 * @param event
		 */		
		public function fault(  event : Object  ) : void {
			//
			logger.logMessage ( event.text, serverMessage );
		}
		
		/**
		 * The Red5 oflaDemo returns bandwidth stats.
		 */		
		public function onBWDone() : void {
			
		}
		
		/**
		 * 
		 * 
		 */		
		private function serverDisconnect() : void 
		{
			// Reset button states
			main.playButtonLabel = main.btnPlay;
			main.playbackState = main.stopState;
			main.publishButtonLabel = main.btnPublish;
			main.publishState = false;
		}

	}
}
