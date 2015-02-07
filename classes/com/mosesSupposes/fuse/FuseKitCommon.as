/**
*
* Fuse Kit | (c) Moses Gunesch, see Fuse-Kit-License.html | http://www.mosessupposes.com/Fuse/
*
* @ignore
*
* This shared class stores common variables and all error messages for the Kit, as well as providing an easy way to extend the Kit for use with logging programs.
* @author	Moses Gunesch
* @version	2.0 (Beta-Y13)
*/
class com.mosesSupposes.fuse.FuseKitCommon
{
	/**
	 * Enables kit version to be retrieved at runtime or when reviewing a decompiled swf. 
	 */
	public static var VERSION:String = '2.0';
	
	/**
	 * Enables kit author to be retrieved at runtime or when reviewing a decompiled swf. 
	 */
	public static var AUTHOR:String = '(c) 2006 All code in this kit by Moses Gunesch | mosessupposes.com/Fuse | fuse@mosessupposes.com';
	
	/** Set to false for shortform (error-code-only) responses
	 * 		Note that ZigoEngine & Fuse OUTPUT_LEVEL properties can be set to 0 for no output 
	 * 		(or 1 for normal, 2 for additional info, and in Fuse 3 for additional FuseItem output.)
	 *		To lower filesize check "omit trace actions" in Publish Settings on final publish.
	 */
	public static var VERBOSE:Boolean = true;
	
	/**
	 * To extend this class to use a logger, set this property to a custom method of your own.
	 * FuseKitCommon.logOutput = function(s:String):Void { }
	 * If defined trace is not called and newline chars are replaced with '\n' chars.
	 */
	public static var logOutput:Function;
	
	
	
	
	// ----------- The rest is for use by the other classes in this kit. -----------------------------------------------------
	
	
	/**
	 * Constant used by ZigoEngine in methods like removeTween, rewTween, etc.
	 */ 
	public static var ALL:String = 'ALL';
	
	/**
	 * Constant used by ZigoEngine in methods like removeTween, rewTween, etc.
	 */ 
	public static var ALLCOLOR:String = 'ALLCOLOR';
	
	// Property collections used in various classes
	/**
	* Internal use only. A shared variable that lists color keywords in a pipe-delimited string.
	* @return string
	*/
	public static function _cts():String { return '|_tint|_tintPercent|_brightness|_brightOffset|_contrast|_invertColor|_colorReset|_colorTransform|'; }
	/**
	* Internal use only. A shared variable that lists auto-underscoreable action-object property keywords in a pipe-delimited string.
	* @return string
	*/
	public static function _underscoreable():String { return ((_cts())+'_x|_y|_xscale|_yscale|_scale|_width|_height|_size|_rotation|_alpha|_visible|'); }
	/**
	* Internal use only. A shared variable that lists parseable ZigoEngine callback keywords in a pipe-delimited string.
	* @return string
	*/
	public static function _cbprops():String { return '|skipLevel|cycles|easyfunc|func|scope|args|startfunc|startscope|startargs|updfunc|updscope|updargs|extra1|extra2|'; }
	/**
	* Internal use only. A shared variable that lists Fuse-specific action-object property keywords in a pipe-delimited string.
	* @return string
	*/
	public static function _fuseprops():String { return '|command|label|delay|event|eventparams|target|addTarget|trigger|startAt|ease|easing|seconds|duration|time|'; }
	
	/**
	* Internal; left public to enable overwriting with a more custom method if needed for custom logging. Currently it simply either calls <code>trace</code> or <code>logOutput</code> with the message string based on whether <code>logOutput</code> has been user-defined.
	* @return string
	*/
	public static function output(s:String):Void
	{
		if (typeof logOutput=='function')	{
			s = (s.split(newline)).join('\n');
			logOutput(s);
		}	
		else {
			trace(s);
		}
	}
	/**
	* Internal use only. All errors/warnings used in kit organized by error-codes. Set <code>FuseKitCommon.VERBOSE</code> to false for shortform (error-code-only) messages.
	* @param a1			generic argument sent for use in various error messages
	* @param a2			generic argument sent for use in various error messages
	* @param a3 		generic argument sent for use in various error messages
	*/
	public static function error (errorCode:String, a1:Object, a2:Object, a3:Object):Void
	{
		if (VERBOSE!=true) {
			output('[FuseKitCommon#'+errorCode+']');
			return;	
		}
		var es:String = '';
		switch (errorCode)
		{
			// 000 ZigoEngine
			case '001':	
				es+=	 '** ERROR: When using simpleSetup to extend prototypes, you must pass the Shortcuts class. **';
				es+=	 newline+' import com.mosesSupposes.fuse.*;';
				es+=	 newline+' ZigoEngine.simpleSetup(Shortcuts);'+newline;
				break;
			case '002':
				es+= '** ZigoEngine.doShortcut: shortcuts missing. Use the setup commands: import com.mosesSupposes.fuse.*; ZigoEngine.register(Shortcuts); **';
				break;
			case '003':
				es+= newline+'*** Error: DO NOT use #include "lmc_tween.as" with this version of ZigoEngine! ***'+newline;
				break;
			case '004':
				es+= '** ZigoEngine.doTween - too few arguments ['+a1+']. If you are trying to use Object Syntax without Fuse, pass FuseItem in your register() or simpleSetup() call. **';
				break;
			case '005':
				es+= '** ZigoEngine.doTween - missing targets['+a1+'] and/or props['+a2+'] **';
				break;
			case '006':
				es+= '** Error: easing shortcut string not recognized ("'+a1+'"). You may need to pass the in PennerEasing class during register or simpleSetup. **';
				break;
			case '007':
				es+= '- ZigoEngine: Target locked ['+a1+'], ignoring tween call ['+a2+']';
				break;
			case '008':
				es+= '** ZigoEngine: You must register the Shortcuts class in order to use easy string-type callback parsing. **';
				break;
			case '009':
				es+= '-ZigoEngine: A callback parameter "'+a1+'" was not recognized.';
				break;
			case '010':
				es+= '-Engine unable to parse '+((a1==1)?'callback[':String(a1)+' callbacks[')+a2+']. Try using the syntax {scope:this, func:"myFunction"}';
				break;
			case '011':
				es+= '-ZigoEngine: Callbacks discarded via skipLevel 2 option ['+a1+'|'+a2+'].';
				break;
			case '012':
				es+= '-Engine set props or ignored no-change tween on: '+a1+', props passed:['+a2+'], endvals passed:['+a3+']';
				break;
			case '013':
				es+= '-Engine added tween on:\n\ttargets:['+a1+']\n\tprops:['+a2+']\n\tendvals:['+a3+']';
				break;
			case '014':
				es+= '** Error: easing function passed is not usable with this engine. Functions need to follow the Robert Penner model. **';
				break;
			
			// 100 Fuse
			case '101':
				es+= '** ERROR: Fuse simpleSetup was removed in version 2.0! **';
				es+= newline+' You must now use the following commands:';
				es+= newline+newline+'	import com.mosesSupposes.fuse.*;';
				es+= newline+'	ZigoEngine.simpleSetup(Shortcuts, PennerEasing, Fuse);';
				es+= newline+'Note that PennerEasing is optional, and FuseFMP is also accepted. (FuseFMP.simpleSetup is run automatically if included.)'+newline;
				break;
			case '102':
				es+= '** Fuse skipTo label not found: "'+a1+'" **';
				break;
			case '103':
				es+= '** Fuse skipTo failed ('+a1+') **';
				break;
			case '104':
				es+= '** Fuse command skipTo ('+a1+')  ignored - targets the current index ('+a2+'). **';
				break;
			case '105':
				es+= '** An unsupported Array method was called on Fuse. **';
				break;
			case '106': // Simple Syntax
				es+= '** ERROR: You have not set up Fuse correctly. **';
				es+= newline+'You must now use the following commands (PennerEasing is optional).';
				es+= newline+'	import com.mosesSupposes.fuse.*;';
				es+= newline+'	ZigoEngine.simpleSetup(Shortcuts, PennerEasing, Fuse);'+newline;
				break;
			case '107': // Simple Syntax
				es+= '** Fuse :: id not found - Aborting open(). **';
				break;
			case '108': // Simple Syntax
				es+= '** Fuse.startRecent: No recent Fuse found to start! **';
				break;
			case '109': // Simple Syntax
				es+= '** Commands other than "delay" are not allowed within groups. Command discarded ("'+a1+'")';
				break;
			case '110': // Simple Syntax
				es+= '** A Fuse.addCommand parameter ("'+a1+'") is not valid and was discarded. If you are trying to add a function-call try the syntax Fuse.addCommand(this,"myCallback",param1,param2); **';
				break;
			case '111':
				es+= '** A Fuse command parameter failed. ("'+a1+'") **';
				break;
			case '112':
				es+= '** Fuse: missing com.mosesSupposes.fuse.ZigoEngine! Cannot tween. **';
				break;
			case '113': // Simple Syntax
				es+= '** FuseItem: A callback has been discarded. Actions with a command may only contain: label, delay, scope, args. **';
				break;
			case '114':
				es+= '** FuseItem: command ("'+a1+'") discarded. Commands may not appear within action groups (arrays). **';
				break;
			case '115':
				es+= a1+' overlapping prop discarded: '+a2;
				break;
			case '116':
				es+= '** FuseItem Error: Delays within groups (arrays) and start/update callbacks are not supported when using Fuse without ZigoEngine. Although you need to restructure your Fuse, it should be possible to achieve the same results. **'+newline;
				break;
			case '117':
				es+= '** '+a1+': infinite cycles are not allowed within Fuses - discarded. **';
				break;
			case '118':
				es+= '** Fuse Error: No targets in '+a1+((a2==true)?'  [Unable to set start props] **':'  [Skipping this action] **');
				break;
			case '119':
				es+= ((a1==true)?'** Fuse Error setting start props: ':'** Fuse Error: ')+a2+((a2==1)?' target missing in ':' targets missing in ')+a3+' **';
				break;
			case '120':
				es+= '** '+a1+': conflict with "'+a2+'". Property might be doubled within a grouped-action array. **';
				break;
			case '121':
				es+= '** Timecode formatting requires "00:" formatting (example:"01:01:33" yields 61.33 seconds.) **';
				break;
			case '122':
				es+= '** FuseItem: You must register the Shortcuts class in order to use easy string-type callback parsing. **';
				break;
			case '123':
				es+= '** FuseItem unable to target callback. Try using the syntax {scope:this, func:"myFunction"} **';
				break;
			case '124':
				es+= '** Event "'+a1+'" reserved by Fuse. **';
				break;
			case '125':
				es+= '** A Fuse event parameter failed in '+a1+' **';
				break;
			
			// 200 FuseFMP
			case '201':
				es+= '**** FuseFMP cannot initialize argument '+a1+' (BitmapFilters cannot be applied to this object type) ****';
				break;
				
			// 300 Shortcuts
			case '301':
				es+= '** The shortcuts fadeIn or fadeOut only accept 3 arguments: seconds, ease, and delay. **';

		}
		output(es);
	}
}


