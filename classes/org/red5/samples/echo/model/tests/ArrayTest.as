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
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class ArrayTest extends BaseTest
	{
		public function ArrayTest()
		{
			super();
			
			tests.push(new Array());
			
			var tmp1: Array = new Array();
			tmp1.push(1);
			tests.push(tmp1);
			tests.push([1, 2]);
			tests.push([1, 2, 3]);
			tests.push([1, 2, [1, 2]]);
			
			var tmp2: Array = new Array();
			tmp2.push(1);
			tmp2[100] = 100;
			tests.push(tmp2);
			
			var tmp3: Array = new Array();
			tmp3.push(1);
			tmp3["one"] = 1;
			tests.push(tmp3);
		}
		
	}
}
