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

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	
	import org.red5.samples.echo.events.EchoTestEvent;
	import org.red5.samples.echo.vo.EchoTestResult;
	import org.red5.samples.echo.vo.ExternalizableClass;

	[Event(name="testInit", type="org.red5.samples.echo.events.EchoTestEvent")]
	[Event(name="testActive", type="org.red5.samples.echo.events.EchoTestEvent")]
	[Event(name="testComplete", type="org.red5.samples.echo.events.EchoTestEvent")]
	[Event(name="testFailed", type="org.red5.samples.echo.events.EchoTestEvent")]
	[Event(name="testError", type="org.red5.samples.echo.events.EchoTestEvent")]
	[Event(name="testTimeOut", type="org.red5.samples.echo.events.EchoTestEvent")]

	/**
	 * @author Joachim Bauch (jojo@struktur.de)
	 * @author Thijs Triemstra (info@collab.nl)
	*/
	public class EchoTest extends EventDispatcher
	{
		private var _id				: int;
		private var _input			: *;
		private var _result			: EchoTestResult;
		private var _responder		: Responder; 
		private var _testTimer		: int;
		private var _stopwatch		: Timer;
		private var _timeOut		: Number = 15; // sec
		private var _interval		: int = 2;
		
		public function EchoTest()
		{
			_result = new EchoTestResult();
			_responder = new Responder( onRemotingResult, onRemotingError );
			_stopwatch = new Timer( _interval );
            _stopwatch.addEventListener( TimerEvent.TIMER, progressHandler );
		}
		
		public function get input() : *
		{
			return _input;
		}
		
		public function get responder() : Responder
		{
			return _responder;
		}
		
		public function get result() : EchoTestResult
		{
			return _result;
		}
		
		public function setupTest( id:int, input:* ) : void
		{
			_id = id;
			_input = input;
			_testTimer = getTimer();
			
			_result.type = flash.utils.getQualifiedClassName( input );
			_result.id = _id + 1;
			_result.status = EchoTestEvent.TEST_INIT;
			_result.request = getObjectDescription( _input );
			
			dispatchEvent( new EchoTestEvent( EchoTestEvent.TEST_INIT, _result ));
			
            _stopwatch.start();
		}
		
		private function onRemotingResult( result : Object ) : void 
		{
			var status		: String = EchoTestEvent.TEST_COMPLETE;
			var testTime 	: Number = getTestTime( _testTimer );
			var validResult	: Boolean = extendedEqual( _input, result );
			
			if ( !validResult ) 
			{
				status = EchoTestEvent.TEST_FAILED;
			}
			
			_result.status = status;
			_result.response = getObjectDescription( result );
			_result.speed = testTime;
			
			_stopwatch.stop();
			
			dispatchEvent( new EchoTestEvent( status, _result ));
		}
		
		private function onRemotingError( result : * ) : void 
		{
			var msg : String;
			var testTime : Number = getTestTime( _testTimer );
			
			if ( result is FaultEvent ) 
			{
				// AMF error
				msg = "AMF error received";
				var fault:Fault = result.fault;
				msg += "<br>   <b>description</b>: " + fault.faultString;
				msg += "<br>   <b>code</b>: " + fault.faultCode;
				if ( fault.faultDetail.length > 0 ) 
				{
					msg += "<br>   <b>details</b>: " + fault.faultDetail;
					for ( var s:int=0;s<fault.faultDetail.length;s++ ) {
						try {
							var stackTrace:Object = fault.faultDetail[ s ];
							msg += "<br>             at " 
												 + stackTrace.className 
												 + "(" + stackTrace.fileName 
												 + ":" + stackTrace.lineNumber + ")";
						} catch ( e:ReferenceError ) {
							referenceError(e);
							break;
						}
					}
					msg += "<br>";
				}
			} 
			else 
			{
				// RTMP error
				msg = "RTMP error received";
				msg += "<br>   <b>level</b>: " + result.level;
				msg += "<br>   <b>code</b>: " + result.code;
				msg += "<br>   <b>description</b>: " + result.description;
				msg += "<br>   <b>application</b>: " + result.application;
			}
			
			_result.status = EchoTestEvent.TEST_ERROR;
			_result.response = msg;
			_result.speed = testTime;
			
			_stopwatch.stop();
			
			dispatchEvent( new EchoTestEvent( EchoTestEvent.TEST_ERROR, _result ));
		}
		
		private function referenceError( e:ReferenceError ) : void
		{
			trace( "Error: " + e.getStackTrace() + "<br/>" );
		}
		
		private function progressHandler( event:TimerEvent ) : void
		{
			var testTime : Number = getTestTime( _testTimer );
			var status	 : String = EchoTestEvent.TEST_ACTIVE;
			
			// server timeout
			if ( testTime >= _timeOut ) 
			{
				_stopwatch.stop();
				status = EchoTestEvent.TEST_TIMEOUT;
			}
			
			_result.status = status;
			_result.speed = testTime;
			
			dispatchEvent( new EchoTestEvent( status, _result ));
		}
		
		/**
		 * @param obj
		 * @return 
		 */		
		private function getObjectDescription( obj:* ) : String
		{
			var msg:String = getQualifiedClassName( obj );
			
			if ( obj is Array ) 
			{
				if ( obj.length > 0 ) 
				{
					var firstItem:* = obj[ 0 ];
					msg = obj.length + " " + getQualifiedClassName( firstItem ) + " item";
					if ( obj.length > 1 ) {
						msg += "s";
					}
				}
			}
			else if ( obj is String )
			{
				if ( obj.length < 25 && obj.length > 0 ) {
					msg += " (" + obj + ")";
				} else {
					msg += " with " + obj.length + " characters";
				}
			}
			else if ( obj is XML )
			{
				msg += " with " + obj.toXMLString().length + " characters";
			}
			else if ( obj is Boolean || obj is int || obj is Number || obj is Date )
			{
				msg += " (" + obj + ")";
			}
			
			return msg;
		}
		
		/**
		 * Compare request and result.
		 * 
		 * @param request
		 * @param response
		 * @return True or false.
		 */		
		private function extendedEqual( request: *, response: * ) : Boolean 
		{
			var key: String;

			if (request == null && response != null) {
				return false;
			} else if (request != null && response == null) {
				return false;
			} else if (request is Array && response is Array) {
				if (request.length != (response as Array).length) {
					return false;
				}
				var i: Number;
				for (i=0; i<(request as Array).length; i++) {
					try {
						if (!extendedEqual((request as Array)[i], (response as Array)[i])) {
							return false;
						}
					} catch ( e:ReferenceError ) {
					    referenceError(e);
					    return false;
					}
				}
				return true;
			} else if (request is ByteArray && response is ByteArray) {
				return (request as ByteArray).toString() == (response as ByteArray).toString();
			} else if (request is ExternalizableClass && response is ExternalizableClass) {
				return (request.failed == response.failed && request.failed == 0);
			} else if (request is XML && response is XML) {
				return ((request as XML).toXMLString() == (response as XML).toXMLString());
			} else if (request is Object && !(response is Object)) {
				for (key in request) {
					try {
						if (!extendedEqual(request[key], (response as Array)[key])) {
							return false;
						}
					} catch (e:ReferenceError) {
					    referenceError(e);
					    return false;
					}
				}
				return true;
			} else if (!(request is Object) && response is Object) {
				for (key in response) {
					try {
						if (!extendedEqual((request as Array)[key], response[key])) {
							return false;
						}
					} catch (e:ReferenceError) {
					    referenceError(e);
					    return false;
					}
				}
				return true;
			} else if (request is Object && response is Object) {
				for (key in request) {
					try {
					    if (!extendedEqual(request[key], response[key])) {
							return false;
						}
					} catch (e:ReferenceError) {
					    referenceError(e);
					    return false;
					}
				}
				return true;
			} else {
				return (request == response);
			}
		}
		
		private function getTestTime( timer:Number ) : Number
		{
			return (getTimer() - timer) / 1000;
		}
		
	}
}
