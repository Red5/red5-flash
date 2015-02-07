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
	
	import org.red5.samples.publisher.business.NetStreamDelegate;
	import org.red5.samples.publisher.events.PlayStreamEvent;
	import org.red5.samples.publisher.model.*;
	
	/**
	 * Setup the <code>nsPlay</code> NetStream for playback.
	 * <p>The NetStream is stored in the Model.</p>
	 * 
	 * @see org.red5.samples.publisher.model.Media#nsPlay nsPlay
	 * @author Thijs Triemstra
	 */	
	public class PlayStreamCommand implements ICommand 
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
	 	private var netStreamDelegate : NetStreamDelegate = main.ns_delegate;
	 	
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
	    	var event : PlayStreamEvent = PlayStreamEvent( cgEvent );
	    	var bufferTime : int = event.bufferTime;
	    	var streamName : String = event.streamName;
	    	var enableVideo : Boolean = event.enableVideo;
	    	var enableAudio : Boolean = event.enableAudio;
			// Use Delegate to playback the NetStream.
	      	netStreamDelegate.startPlayback( bufferTime, streamName, enableVideo, enableAudio );
		}
				
	}
}
