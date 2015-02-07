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
	
	import mx.managers.PopUpManager;
	
	import org.red5.samples.publisher.events.CreatePresetEvent;
	import org.red5.samples.publisher.model.*;
	import org.red5.samples.publisher.view.general.SaveConnection;
	import org.red5.samples.publisher.view.settings.SettingsDisplay;
	import org.red5.samples.publisher.vo.ServerPreset;
	
	/**
	 * Create and store a new server preset.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class CreatePresetCommand implements ICommand 
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
	 	 * @param event CreatePresetEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var presetEvent : CreatePresetEvent = CreatePresetEvent( cgEvent );
			var hostName : String = presetEvent.hostName;
			var serverType : int = presetEvent.serverType;
			var encodingType : int = presetEvent.encodingType;
			var proxyType : int = presetEvent.proxyType;
			//
			main.tempServerPreset = new ServerPreset( null, hostName, serverType, encodingType, proxyType );
			//
			var popup : SaveConnection = SaveConnection( PopUpManager.createPopUp( presetEvent.targetLocation, SaveConnection , true ) );
			//
			PopUpManager.centerPopUp( popup );
		}
	}
}
