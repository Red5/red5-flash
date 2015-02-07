package  org.red5.samples.publisher.vo.settings
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
	 * 
	 * @author Thijs Triemstra
	 */	
	public class AudioSettings 
	{
		/**
		* 
		*/		
		public var micIndex : int;
		
		/**
		* 
		*/		
		public var rate : int;
		
		/**
		* 
		*/		
		public var gain : int;
		
		/**
		* 
		*/		
		public var level : int;
		
		/**
		* 
		*/		
		public var timeout : int;

		/**
		 * 
		 * @param micIndex
		 * @param rate
		 * @param gain
		 * @param level
		 * @param timeout
		 * @return
		 */		
		public function AudioSettings(	micIndex : int = -1,
										rate : int = 22,
										gain : int = 50,
										level : int = 10,
										timeout : int = 2000 ) 
		{
			this.micIndex = micIndex;
			this.rate = rate;
			this.gain = gain;
			this.level = level;
			this.timeout = timeout;
		}
	}
}
