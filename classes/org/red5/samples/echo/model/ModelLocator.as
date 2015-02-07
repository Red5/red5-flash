package org.red5.samples.echo.model
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
	 
	import com.adobe.cairngorm.*;
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.remoting.RemoteObject;
	
	import org.red5.samples.echo.vo.User;
	
 	[Bindable]
	/**
	 * @author Thijs Triemstra (info@collab.nl)
	 */ 	
	public class ModelLocator implements IModelLocator
	{
		public const appVersion		: String = "0.4.1";
	   	public const fpVersion 		: String = "Flash Player " + Capabilities.version + " - " +
	   											Capabilities.playerType;

		public var httpServer		: String;
		public var rtmpServer		: String = "rtmp://localhost/echo";
		public var httpMethod		: String = "echo";
		public var rtmpMethod		: String = "echo";
		
		public const success 		: String = "<font color='#149D25'>";
		public const failure 		: String = "<font color='#FF1300'>";
		
	   	public var amf0_tests		: Array = [ "null", "undefined", "Boolean", "String", "Number", 
	   											"Array", "Object", "Date", "XML", "Remote Class", 
	   											"Custom Class" ];
	   											
		public var amf3_tests		: Array = [ "XML", "Externalizable", "ArrayCollection", "ObjectProxy", 
			               						"ByteArray", "Unsupported" ];
		
		public var tests_selection 	: Array = [];
		public var connecting		: Boolean = false;
		public var user				: User 	= new User();
		public var local_so			: SharedObject = SharedObject.getLocal("EchoTest");
		public var echoService 		: RemoteObject;
		public var nc				: NetConnection;
		public var testResults		: ArrayCollection;
		public var testParams		: EchoTestData;
		public var testIndex		: Number;
		public var AMF0Count		: Number;
		public var testsFailed		: Number;
		public var globalTimer		: int;
		public var statusText 		: String;
		
		private static var instance : ModelLocator;

		/**
	   	 * @throws CairngormError Only one ModelLocator instance should be instantiated.
	   	 */	   	
	   	public function ModelLocator() 
	   	{
	   		if (instance != null)
					throw new CairngormError(
					   CairngormMessageCodes.SINGLETON_EXCEPTION, "ModelLocator");
	   	}
	   	
		/**
		 * @return ModelLocator
		 */		
		public static function getInstance() : ModelLocator
		{
			if (instance == null)
				instance = new ModelLocator();
				
			return instance;
	   	}
		
	}
}
