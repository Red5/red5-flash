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
package org.red5.samples.echo.events
{
	import flash.events.Event;
	
	import org.red5.samples.echo.vo.TestSelection;
	
	/**
	 * @author Thijs Triemstra ( info@collab.nl )
	 */
	public class TestSelectEvent extends Event
	{
		public static const TEST_SELECT		: String = "onSelect";
		public static const TEST_SETUP		: String = "onInit";
		
		private var _result					: TestSelection;
		
		/**
		 * @param type
		 * @param res
		 * @param bubbles
		 * @param cancelable
		 */
		public function TestSelectEvent( type:String, res:TestSelection, bubbles:Boolean=false,
										 cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			_result = res;
		}

		/**
		 * @return Select result.
		 */
		public function get result() : TestSelection
		{
			return _result;
		}

	}
}
