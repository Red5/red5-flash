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
package org.red5.samples.echo.commands
{		 
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	
	import org.red5.samples.echo.events.RunTestEvent;
	import org.red5.samples.echo.events.StartTestsEvent;
	import org.red5.samples.echo.model.EchoTestData;
	import org.red5.samples.echo.model.ModelLocator;
	
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	 */	
	public class StartTestsCommand implements ICommand 
	{		 	
	 	private var _model:ModelLocator = ModelLocator.getInstance();
	 	
	 	/**
	 	 * @param cgEvent
	 	 */	 	
	 	public function execute(cgEvent:CairngormEvent):void
	    { 
			var event:StartTestsEvent = StartTestsEvent(cgEvent);
			
			_model.testParams = new EchoTestData( _model.tests_selection );
			_model.testResults = new ArrayCollection();
			_model.testIndex = 0;
			_model.testsFailed = 0;
			_model.globalTimer = getTimer();
			
			if (_model.testParams.items.length > 0)
			{
				var runTestEvent : RunTestEvent = new RunTestEvent();
				runTestEvent.dispatch();
			}
		}
		
	}
}
