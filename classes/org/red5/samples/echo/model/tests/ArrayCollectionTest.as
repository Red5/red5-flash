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
	import mx.collections.ArrayCollection;
	
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class ArrayCollectionTest extends BaseTest
	{
		public function ArrayCollectionTest()
		{
			var tmp1: ArrayCollection = new ArrayCollection();
			tmp1.addItem("one");
			tmp1.addItem(123);
			tmp1.addItem(null);
			tests.push(tmp1);
			
			var tmp_2: Array = new Array();
			tmp_2.push(tmp1);
			tmp_2.push(tmp1);
			tests.push(tmp_2);
		}
		
	}
}
