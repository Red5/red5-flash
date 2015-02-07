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
package org.red5.samples.echo.vo
{
	[Bindable]
	/**
	 * This class represents the result of a test.
	 * 
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class EchoTestResult
	{
		public var id		: Number;
		public var name		: String;
		public var type		: String;
		public var status	: String;
		public var request	: String;
		public var response	: String;
		public var speed	: Number;
		
		/**
		 * @param id		Test index
		 * @param name		Name of the test
		 * @param type		Request type
		 * @param status	Status description
		 * @param request	Description of request data
		 * @param response	Description of response data
		 * @param speed		Speed in seconds
		 */		
		public function EchoTestResult( id:Number=0,
									    name:String ="",
									    type:String ="",
									  	status:String ="",
									  	request:String ="",
									  	response:String ="",
									  	speed:Number = 0 )
		{
			this.id =		id;
			this.name = 	name;
			this.type =		type;
			this.status = 	status;
			this.request = 	request;
			this.response = response;
			this.speed = 	speed;
		}
		
	}
}
