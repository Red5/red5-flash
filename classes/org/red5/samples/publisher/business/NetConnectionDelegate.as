package org.red5.samples.publisher.business
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

	import com.adobe.cairngorm.business.ServiceLocator;
	
	import flash.events.*;
	import flash.net.*;
	
	import mx.rpc.IResponder;
	
	import org.red5.samples.publisher.model.*;
	import org.red5.samples.publisher.view.general.Images;			
	
	/**
	 * 
	 * @author Thijs Triemstra
	 * 
	 */	
	public class NetConnectionDelegate
	{	
		/**
		* 
		*/
		private var model : ModelLocator = ModelLocator.getInstance();
		
		/**
		* 
		*/		
		private var responder : IResponder;
		
		/**
		* 
		*/		
		private var service : Object;
		
		/**
	 	* 
	 	*/	 	
	 	private var logger : Logger = model.logger;
	 	
		/**
		* 
		*/		
		private var main : Main = model.main;
		
		/**
		*  
		*/		
		private var netConnection : NetConnection = main.media.nc;
		
		/**
		* 
		*/		
		private var images : Images = main.images;
		
		/**
		* 
		*/		
		private var serverMessage : String = logger.serverMessage;
		
		/**
		 * 
		 * @param res
		 */		
		public function NetConnectionDelegate( res : IResponder )
		{
			//
			main.media.nc = new NetConnection();
			// Listen and capture the NetConnection info and error events.
			responder = res;
		}
		
		/**
		 * 
		 * @param uri
		 * @param proxy
		 * @param encoding
		 */		
		public function connect( uri : String, proxy : String, encoding : uint ) : void
		{
			// Initialize the NetConnection in the model.
			netConnection = main.media.nc;
			//
			netConnection.client = responder;
			// 
			netConnection.objectEncoding = encoding;
			netConnection.proxyType = proxy;
			// Setup the NetConnection and listen for NetStatusEvent and SecurityErrorEvent events.
			netConnection.addEventListener( NetStatusEvent.NET_STATUS, netStatus );
			netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, netASyncError );
			netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, netSecurityError );
			netConnection.addEventListener( IOErrorEvent.IO_ERROR, netIOError );
			// connect to server
			try {
				//
				logger.logMessage( "Connecting to <b>" + uri + "</b>", serverMessage );
				//
				logger.monitorMessage(	"Connecting to server", 
										images.connectServer_img, 
										serverMessage );
				// Create connection with the server.
				netConnection.connect( uri );
			}
			catch( e : ArgumentError ) 
			{
				// Invalid parameters.
				switch ( e.errorID ) 
				{
					case 2004 :
						//
						logger.logMessage( "Invalid server location: <b>" + uri + "</b>", serverMessage );
						//					   
						logger.monitorMessage( 	"Invalid server location!", 
												images.warnServer_img, 
												serverMessage );
						break;
						
					default :
					   //
					   break;
				}
			}	
		}
		
		/**
		 * 
		 * 
		 */		
		public function close() : void
		{
			// Close the NetConnection.
			netConnection.close();
		}
			
		/**
		 * 
		 * @param event
		 */		
		protected function netStatus( event : NetStatusEvent ) : void 
		{
			// Pass NetStatusEvent to SetupConnectionCommand.
			this.responder.result( event );
		}
		
		/**
		 * 
		 * @param event
		 */		
		protected function netSecurityError( event : SecurityErrorEvent ) : void 
		{
			// Pass SecurityErrorEvent to SetupConnectionCommand.
		    responder.fault( new SecurityErrorEvent ( SecurityErrorEvent.SECURITY_ERROR, false, true,
		    										  "Security error - " + event.text ) );
		}
		
		/**
		 * 
		 * @param event
		 */		
		protected function netIOError( event : IOErrorEvent ) : void 
		{
			// Pass IOErrorEvent to SetupConnectionCommand.
			responder.fault( new IOErrorEvent ( IOErrorEvent.IO_ERROR, false, true, 
							 "Input/output error - " + event.text ) );
		}
		
		/**
		 * 
		 * @param event
		 */		
		protected function netASyncError( event : AsyncErrorEvent ) : void 
		{
			// Pass AsyncErrorEvent to SetupConnectionCommand.
			responder.fault( new AsyncErrorEvent ( AsyncErrorEvent.ASYNC_ERROR, false, true,
							 "Asynchronous code error - <i>" + event.error + "</i>" ) );
		}

    }
}
