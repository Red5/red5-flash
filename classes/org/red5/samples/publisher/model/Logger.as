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
	 
	import flash.system.Capabilities;
	
	/**
	 * Recieve and display log info.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class Logger
	{
		[Bindable]
		/**
		* 
		*/		
		private var main : Main;
		
		[Bindable]
		/**
		 * Flash Player version number inc. debugger flag.
		*/		
		public var flashVersion : String;
		
		[Bindable]
		/**
		 * Log text displayed in the TextArea.
		*/		
		public var statusText : String = "";
		
		[Bindable]
		/**
		 * Show/hide stream metadata.
		 * 
		 * @default true
		*/		
		public var meta_check : Boolean = true;
		
		[Bindable]
		/**
		 * Show/hide stream cuepoint info.
		 * 
		 * @default true
		*/		
		public var cue_check : Boolean = true;
		
		[Bindable]
		/**
		 * Show/hide stream status and error notifications.
		 * 
		 * @default true
		*/		
		public var stream_check : Boolean = true;
		
		[Bindable]
		/**
		 * Show/hide NetConnection status and error notifications.
		 * 
		 * @default true
		*/		
		public var server_check : Boolean = true;
		
		[Bindable]
		/**
		 * Show/hide audio device status and error info.
		 * 
		 * @default true
		*/		
		public var audio_check : Boolean = true;
		
		[Bindable]
		/**
		 * Show/hide video device status and error info.
		 * 
		 * @default true
		*/		
		public var video_check : Boolean = true;
		
		/**
		* 
		*/		
		public const infoMessage : String = "Info";

		/**
		* 
		*/		
		public const serverMessage : String = "NetConnection";
		
		/**
		* 
		*/		
		public const audioMessage : String = "Audio";
		
		/**
		* 
		*/		
		public const videoMessage : String = "Video";
		
		/**
		* 
		*/		
		public const debugMessage : String = "Debug";
		
		/**
		* 
		*/		
		public const streamMessage : String = "NetStream";
		
		/**
		* 
		*/		
		public const metadataMessage : String = "MetaData";
		
		/**
		* 
		*/		
		public const cuepointMessage : String = "CuePoints";
		
		/**
		 * 
		 * @param env
		 * @return 
		 */			
		public function Logger( env : Main )
		{
			var platformVersion : String = Capabilities.version.substr( String( Capabilities.version ).lastIndexOf(" ") + 1 );
			var manufacturer : String = Capabilities.manufacturer;
			// Get Flash Player version info.
			flashVersion = "Using " + manufacturer + " Flash Player " + platformVersion;
			//
			if ( Capabilities.isDebugger ) 
			{
				// Add debugger info.
				flashVersion += " (Debugger)";
			}
			//
			main = env;
			// Display Flash Player version.
			logMessage( flashVersion, infoMessage );
		}
		
		/**
		 * 
		 * @param msg Status message to display.
		 * @param msgType Status message type.
		 */		
		public function logMessage( msg : String, 
									msgType : String ) : void 
		{
			if (( msgType == serverMessage && server_check ) || 
				( msgType == streamMessage && stream_check ) ||
				( msgType == audioMessage && audio_check ) ||
				( msgType == videoMessage && video_check ) ||
				( msgType == metadataMessage && meta_check ) ||
				( msgType == cuepointMessage && cue_check ) ||
				  msgType == infoMessage ||
				  msgType == debugMessage ) 
			{
				var statusMessage : String = iso( new Date() ) + " - " + msg;
				//
				statusText += statusMessage + "<br>";
			}
		}
	
		/**
		 * 
		 * @param msg
		 * @param img
		 * @param msgType
		 */		
		public function monitorMessage ( msg : String, 
										 img : Class, 
										 msgType : String ) : void 
		{
			if ( msgType == serverMessage ) 
			{
				main.serverStatusMessage = msg;
				main.images.serverStatusImage = img;
			} 
			else if ( msgType == audioMessage ) 
			{
				main.audioStatusMessage = msg;
				main.images.audioStatusImage = img;
			} 
			else if ( msgType == videoMessage ) 
			{
				main.videoStatusMessage = msg;
				main.images.videoStatusImage = img;
			}
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 */		
		private function doubleDigits( value : Number ) : String 
		{
			if ( value > 9 ) 
			{
				return String( value );
			} 
			else 
			{ 
				return "0" + value;
			}
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 */		
		private function tripleDigits( value : Number ) : String 
		{
			var newStr : String = "";
			if ( value > 9 && value < 100 ) 
			{
				newStr = String( value ) + "0";
			} 
			else 
			{ 
				newStr = String( value ) + "00";
			}
			return newStr.substr( 0, 3 );
		}
		
		/**
		 * 
		 * @param date
		 * @return 
		 */		
		private function iso( date : Date ) : String 
		{
			return  doubleDigits( date.getHours() )
					+ ":"
					+ doubleDigits( date.getMinutes() )
					+ ":"
					+ doubleDigits( date.getSeconds() )
					+ ":"
					+ tripleDigits( date.getMilliseconds() );
		}
		
	}
}
