package org.red5.samples.echo.model.tests
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
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class BaseTest
	{
		private var _items : Array = new Array();
		private var _name : String;
		
		public function BaseTest(name:String=null, items:Array=null):void
		{
			if (items != null)
			{
				this._items = items;
			}
			
			if (name != null)
			{
				this._name = name;
			}
		}
		
		public function get name():String
		{
			return this.name;
		}
		
		public function set name(val:String):void
		{
			_name = val;
		}
		
		public function get tests():Array
		{
			return this._items;
		}
		
		public function set tests(arr:Array):void
		{
			this._items = arr;
		}
		
	}
}
