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
package org.red5.samples.echo.model.tests
{
	import org.red5.samples.echo.vo.RemoteClass;

	/**
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class RemoteClassTest extends BaseTest
	{
		public function RemoteClassTest()
		{
			super();
			
			var remote: RemoteClass = new RemoteClass();
			remote.attribute1 = "one";
			remote.attribute2 = 2;
			tests.push(remote);
			
			var tmp1: Array = new Array();
			var remote1: RemoteClass = new RemoteClass();
			remote1.attribute1 = "one";
			remote1.attribute2 = 1;
			tmp1.push(remote1);
			
			var remote2: RemoteClass = new RemoteClass();
			remote2.attribute1 = "two";
			remote2.attribute2 = 2;
			tmp1.push(remote2);
			tests.push(tmp1);
			
			var remote3: RemoteClass = new RemoteClass();
			remote3.attribute1 = "three";
			remote3.attribute2 = 1234567890;
			tests.push(remote3);
			
			var remote4: RemoteClass = new RemoteClass();
			remote4.attribute1 = "four";
			remote4.attribute2 = 1185292800000;
			tests.push(remote4);
		}
		
	}
}
