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
	
	import org.red5.samples.publisher.events.ChangePresetEvent;
	import org.red5.samples.publisher.model.*;
	import org.red5.samples.publisher.vo.settings.*;
	
	/**
	 * Change the settings based on saved presets data.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class ChangePresetCommand implements ICommand 
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
	 	private var navigation : Navigation = model.navigation;
	 	
	 	/**
	 	 * Method recieves the index of the <code>ServerPreset</code> object in the Array
	 	 * and updates the general application settings.
	 	 * 
	 	 * @param event ChangePresetEvent contains the Array index of the <code>ServerPreset</code> object.
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var presetEvent : ChangePresetEvent = ChangePresetEvent( cgEvent );
			var index : Number = presetEvent.index;
			var preset : Object = main.serverPresets[ index ];
			var serverType : int = preset.server;
			var img : Class = main.serverTypes[ serverType ].img;
			var hostName : String = preset.host;
			var encodingType : int = preset.encode;
			var proxyType : int = preset.proxy;
			//
			navigation.selectedPreset = index;
			// Update servertype image.
			main.images.serverLogo = img;			
			// Copy the server preset info and use it for the general settings.
			main.generalSettings = new GeneralSettings( hostName,
														serverType,
														encodingType,
														proxyType );
		}
		
	}
}
