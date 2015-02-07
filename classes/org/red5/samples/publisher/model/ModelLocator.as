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
	 
	import com.adobe.cairngorm.*;
	import com.adobe.cairngorm.model.IModelLocator;
	
 	[Bindable]
	/**
	 * 
	 * @author Thijs Triemstra
	 */ 	
	public class ModelLocator implements IModelLocator
	{
		/**
		* 
		*/		
		private static var instance : ModelLocator;
		
		/**
		* 
		*/		
		public var main : Main;
		
		/**
		* 
		*/		
		public var logger : Logger;
		
		/**
		* 
		*/		
		public var navigation : Navigation;
		
		/**
	   	 * @throws CairngormError Only one ModelLocator instance should be instantiated.
	   	 */	   	
	   	public function ModelLocator() 
	   	{
	   		if ( instance != null )
					throw new CairngormError(
					   CairngormMessageCodes.SINGLETON_EXCEPTION, "ModelLocator" );
					
				initialize();
	   	}
	   	
		/**
		 * 
		 * @return ModelLocator
		 */		
		public static function getInstance() : ModelLocator
		{
			if ( instance == null )
				instance = new ModelLocator();
				
			return instance;
	   	}
	   	
	   	/**
	   	 * 
	   	 */	   	
	   	private function initialize() : void
	   	{
   			navigation = new Navigation();	
			main = new Main( navigation );	
			logger = new Logger( main );	
	   	}
	   	
	}
}
