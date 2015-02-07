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
	 import com.adobe.cairngorm.control.*;
	 
	 import flash.events.NetStatusEvent;
	 import flash.net.*;
	 
	 import mx.controls.Alert;
	 
	 import org.red5.samples.publisher.events.*;
	 import org.red5.samples.publisher.model.*;
	 import org.red5.samples.publisher.vo.ServerPreset;
	 import org.red5.samples.publisher.vo.settings.GeneralSettings;
	
	/**
	 * Save the server preset.
	 * 
	 * @author Thijs Triemstra
	 */	
	public class SavePresetCommand implements ICommand 
	{
		/**
		* 
		*/			
		private var model : ModelLocator = ModelLocator.getInstance();
		
		[Bindable]
	 	/**
	 	* 
	 	*/		
	 	private var main : Main = model.main;
	 	
	 	/**
		* 
		*/		
		public var so : SharedObject = main.mySo;
		
		/**
        * A reference to the serverPresets Array to merge the result.
        */        
        public var serverPresets : Array = main.serverPresets;
		
	 	/**
	 	 * 
	 	 * @param event SavePresetEvent
	 	 */	 	
	 	public function execute( cgEvent : CairngormEvent ) : void
	    { 
			var event : SavePresetEvent = SavePresetEvent( cgEvent );
			var dup : Boolean = false;
			var newName : String = event.newName;
			var hostName : String = main.tempServerPreset.host;
			var serverType : int = main.tempServerPreset.server;
			var encoding : int = main.tempServerPreset.encode;
			var proxytype : int = main.tempServerPreset.proxy;
			//
			var newPreset : ServerPreset = new ServerPreset( newName, hostName, serverType, encoding, proxytype );
			//
			for ( var presetIndex : Number = 0; presetIndex < serverPresets.length; presetIndex++ ) 
			{
				if ( serverPresets[ presetIndex ].label == newName ) 
				{
					dup = true;
					// overwrite
					serverPresets[ presetIndex ] = newPreset;
					break;
				}
			}
			//
			if ( !dup ) 
			{
				// Add new preset at the start of the presets list (ComboBox dataprovider).
				serverPresets.unshift( newPreset ); 
				//
				presetIndex = 0;
				//
				savePresetsToDisk();
			}
			// Change to most recent preset in the ComboBox.
			var changePresetEvent : ChangePresetEvent = new ChangePresetEvent( presetIndex );
			changePresetEvent.dispatch();			
		}
		
		/**
		 * 
		 * 
		 */		
		private function savePresetsToDisk() : void 
		{
			//
			so.data.serverPresets = serverPresets;
			//
			var flushStatus:String = null;
			try 
			{
				flushStatus = so.flush( 10000 );
			} 
			catch ( error : Error ) 
			{
				Alert.show( "Error... Could not write SharedObject to disk", "Permissions error" );
			}
			//
			if ( flushStatus != null ) 
			{
				switch ( flushStatus ) 
				{
					case SharedObjectFlushStatus.PENDING:
						// Requesting permission to save object.
						so.addEventListener( NetStatusEvent.NET_STATUS, onFlushStatus );
						break;
					case SharedObjectFlushStatus.FLUSHED:
						// Value flushed to disk.
						break;
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 */		
		private function onFlushStatus( event : NetStatusEvent ) : void 
		{
			/// User closed permission dialog.
			switch ( event.info.code ) 
			{
				case "SharedObject.Flush.Success":
					// User granted permission -- value saved.
					break;
				case "SharedObject.Flush.Failed":
					Alert.show( "User denied permission -- value not saved.", "SharedObject error" );
					break;
			}
			//
			so.removeEventListener( NetStatusEvent.NET_STATUS, onFlushStatus );
		}
		
	}
}
