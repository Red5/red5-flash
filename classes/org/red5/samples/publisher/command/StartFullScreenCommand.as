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
	
	import flash.display.StageDisplayState;
	
	import org.red5.samples.publisher.events.StartFullScreenEvent;
	import org.red5.samples.publisher.model.*;

	/**
	 * Show fullscreen video.
	 * 
	 * @author Thijs Triemstra
	 */
	public class StartFullScreenCommand implements ICommand
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
	 	
		[Bindable]
	 	/**
	 	* 
	 	*/		
	 	public var navigation : Navigation = model.navigation;
	 	
	 	/**
	 	 * 
	 	 * @param cgEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
	    	var event : StartFullScreenEvent = StartFullScreenEvent( cgEvent );
			// Retain control panels visibility.
        	event.stage.displayState = StageDisplayState.FULL_SCREEN;
        	// Video occupies 75% of the screen (stage).
        	main.media.videoWidth = ( event.stage.stageWidth/100 ) * 75;
        	main.media.videoHeight = ( event.stage.stageHeight/100 ) * 75;
		}
		
	}
}
