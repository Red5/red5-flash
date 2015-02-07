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
	
	import org.red5.samples.publisher.events.ChangeSettingsViewEvent;
	import org.red5.samples.publisher.model.*;

	/**
	 * Change the view of the server and device settings panel.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class ChangeSettingsViewCommand implements ICommand 
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
			var settingsViewEvent : ChangeSettingsViewEvent = ChangeSettingsViewEvent( cgEvent );
			var tabIndex : Number = 	settingsViewEvent.tabIndex;
			var icon : Class = 			settingsViewEvent.img;
			//
			navigation.settingsViewing = tabIndex;
			//
			main.images.settingsIcon = icon;
			//
			if ( tabIndex == navigation.SETTINGS_VIDEO || tabIndex == navigation.SETTINGS_AUDIO ) 
			{
				//
				navigation.monitorDisplayViewing = navigation.MONITOR_PUBLISH;
				navigation.monitorBarIndex = 1;
			} 
			else 
			{
				//
				navigation.monitorDisplayViewing = navigation.MONITOR_VIEW;
				navigation.monitorBarIndex = 0;
			}
		}
	}
}
