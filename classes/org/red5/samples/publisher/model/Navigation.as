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

	/**
	 * Navigation related data.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class Navigation
	{		
		// Available values for the monitor tabnavigator.
		public const MONITOR_SERVER : int =			0;
		public const MONITOR_VIEW : int =			1;
		public const MONITOR_PUBLISH : int =		2;
		
		// Available values for the settings view.
		public const SETTINGS_SERVER : int =		0;
		public const SETTINGS_VIDEO : int =			1;
		public const SETTINGS_AUDIO : int =			2;
		
		[Bindable]
		/**
		 * 
		 * @default 0
		*/		
		public var selectedPreset : int = 0;

		[Bindable]
		/**
		* 
		*/		
		public var monitorDisplayViewing : Number = MONITOR_VIEW;
		
		[Bindable]
		/**
		* 
		*/		
		public var settingsViewing : Number = SETTINGS_SERVER;
		
		[Bindable]
		/**
		* 
		*/		
		public var monitorBarIndex : Number = SETTINGS_SERVER;
		
		[Bindable]
		/**
		* 
		*/		
		public var settingsArray : Array = 	[	
												{ label: "Server", toolTip: "Server Settings", data: SETTINGS_SERVER }, 
												{ label: "Video", toolTip: "Video Settings", data: SETTINGS_VIDEO },
												{ label: "Audio", toolTip: "Audio Settings", data: SETTINGS_AUDIO }
										   	];
		
		[Bindable]
		/**
		* 
		*/		
		public var monitorMenu : Array = 	[	
												{ label: "View", toolTip: "View Stream", data: MONITOR_VIEW }, 
									  			{ label: "Publish", toolTip: "Publish Stream", data: MONITOR_PUBLISH }
									 		];
	}
}
