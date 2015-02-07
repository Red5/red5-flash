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
	
	import org.red5.samples.echo.vo.EchoTestResult;

	/**
	 * @author Thijs Triemstra ( info@collab.nl )
	 */
	public class EchoTestEvent extends Event
	{
		public static const TEST_INIT 		: String = "testInit";
		public static const TEST_ACTIVE		: String = "testActive";
		public static const TEST_COMPLETE 	: String = "testComplete";
		public static const TEST_FAILED 	: String = "testFailed";
		public static const TEST_ERROR	 	: String = "testError";
		public static const TEST_TIMEOUT 	: String = "testTimeOut";
		
		private var _result					: EchoTestResult;
		
		/**
		 * @param type
		 * @param res
		 * @param bubbles
		 * @param cancelable
		 */
		public function EchoTestEvent( type:String, res:EchoTestResult, 
									   bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			_result = res;
		}

		/**
		 * @return Test result.
		 */
		public function get result() : EchoTestResult
		{
			return _result;
		}

	}
}
