package org.red5.admin.connector.event 
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
	
	import flash.events.Event;

	/**
	 * 
	 * @author Martijn van Beek
	 */
	public class Red5Event extends Event
	{
		private var _code	: String;
		private var _level	: String;
		
		public function Red5Event(type:String, info:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_code = info.code;
			_level = info.level;
			super(type, bubbles, cancelable);
		}
		
		public function get code():String 
		{
			return _code;
		}

		public function get level():String 
		{
			return _level;
		}
		
	}
}
