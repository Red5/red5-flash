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
package org.red5.samples.echo.controller
{
	import com.adobe.cairngorm.control.FrontController;
	
	import org.red5.samples.echo.commands.*;
	
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	 */	
	public class EchoController extends FrontController
	{
		public static const EVENT_CONNECT 			: String = "EVENT_CONNECT";
		public static const EVENT_DISCONNECT		: String = "EVENT_DISCONNECT";
		public static const EVENT_SETUP_CONNECTION 	: String = "EVENT_SETUP_CONNECTION";
		public static const EVENT_PRINT_TEXT		: String = "EVENT_PRINT_TEXT";
		public static const EVENT_START_TESTS 		: String = "EVENT_START_TESTS";
		public static const EVENT_RUN_TEST 			: String = "EVENT_RUN_TEST";
		
		public function EchoController()
		{
			addCommand( EchoController.EVENT_CONNECT, 			ConnectCommand);
			addCommand( EchoController.EVENT_DISCONNECT, 		DisconnectCommand);
			addCommand( EchoController.EVENT_SETUP_CONNECTION, 	SetupConnectionCommand);
			addCommand( EchoController.EVENT_PRINT_TEXT, 		PrintTextCommand);
			addCommand( EchoController.EVENT_START_TESTS, 		StartTestsCommand);
			addCommand( EchoController.EVENT_RUN_TEST, 			RunTestCommand);
		}
		
	}
}
