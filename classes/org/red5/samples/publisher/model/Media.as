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

	import flash.media.*;
	import flash.net.*;
	
	/**
	 * Devices and remote connections.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class Media
	{
		/**
		* <code>NetStream</code> for outgoing audio/video.
		*/		
		public var nsPublish : NetStream;                      
		
		/**
		* <code>NetStream</code> for incoming audio/video.
		*/
		public var nsPlay : NetStream;
	
		/**
		* One <code>NetConnection</code> used in the application.
		*/		
		public var nc : NetConnection;
		
		/**
		* Audio device.
		*/		
		public var microphone : Microphone;
		
		/**
		* Video device.
		*/		
		public var camera : Camera;
		
		[Bindable]
		/**
		* Display output of video device.
		*/		
		public var videoLocal : Video;
		
		[Bindable]
		/**
		* Display <code>NetStream</code> video output.
		*/		
		public var videoRemote : Video;	
		
		[Bindable]
		/**
		* Current video width.
		*/		
		public var videoWidth : int;
		
		[Bindable]
		/**
		* Current video height.
		*/		
		public var videoHeight : int;
	}
}
