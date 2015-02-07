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
	
	import org.red5.samples.publisher.events.ChangeMonitorViewEvent;
	import org.red5.samples.publisher.model.*;

	/**
	 * Change the input of the video display to a local or live video stream.
	 * 
	 * @author Thijs Triemstra
	 */
	public class ChangeMonitorViewCommand implements ICommand
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
			var monitorViewEvent : ChangeMonitorViewEvent = ChangeMonitorViewEvent( cgEvent );
			var tabIndex : Number = monitorViewEvent.tabIndex;
			// switch MonitorDisplay and MonitorControlBar
			navigation.monitorDisplayViewing = tabIndex;
			//  switch SettingsDisplay, SettingsStatusBar, SettingsAppBar
			if ( tabIndex == navigation.MONITOR_PUBLISH ) 
			{
				// switch Settings components to show video settings
				navigation.settingsViewing = navigation.SETTINGS_VIDEO;
				navigation.monitorBarIndex = 1;	
			} 
			else
			{
				// switch Settings components to show server settings
				navigation.settingsViewing = navigation.SETTINGS_SERVER;
				navigation.monitorBarIndex = 0;
			}
			//
			main.images.settingsIcon = navigation.settingsArray[ navigation.settingsViewing ].img;
		}
		
	}
}
