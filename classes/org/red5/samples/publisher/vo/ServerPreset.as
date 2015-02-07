package  org.red5.samples.publisher.vo
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
	 
	[Bindable]
	/**
	 * Server preset for easy access to different RTMP applications and servers.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class ServerPreset 
	{
		/**
		* Name for the preset.
		*/		
		public var label : String;
		
		/**
		 * Server RTMP URL, for example: rtmp://localhost/oflaDemo
		*/		
		public var host : String;
		
		/**
		* RTMP Server type
		*/		
		public var server : int;
		
		/**
		 * The AMF ObjectEncoding type. 
		 * <p>The value is either <code>AMF0</code> or <code>AMF3</code>.</p>
		 * @see org.red5.samples.publisher.model.Main#objectEncodeTypes objectEncodeTypes
		*/		
		public var encode : int;
		
		/**
		 * Proxy type.
		 * @see org.red5.samples.publisher.model.Main#proxyTypes proxyTypes
		*/		
		public var proxy : int;

		/**
		 * 
		 * @param label
		 * @param host
		 * @param server
		 * @param encode
		 * @param proxy
		 * @return 
		 */				
		public function ServerPreset(	label : String = "",
										host : String = "",
										server : int = 0,
										encode : int = 0,
										proxy : int = 0 ) 
		{
			this.label = label;
			this.host = host;
			this.server = server;
			this.encode = encode;
			this.proxy = proxy;
		}
	}
}
