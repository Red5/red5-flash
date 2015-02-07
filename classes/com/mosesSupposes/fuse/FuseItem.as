import com.mosesSupposes.fuse.FuseKitCommon;
import mx.data.encoders.Num;
/**
*
* Fuse Kit | (c) Moses Gunesch, see Fuse-Kit-License.html | http://www.mosessupposes.com/Fuse/
*
* @ignore
*
* Individual Object used by Fuse and/or ZigoEngine to add "Object Syntax" parsing capability.
* @author	Moses Gunesch
* @version	2.0 (Beta-Y13)
*/
class com.mosesSupposes.fuse.FuseItem
{
	/**
	 * @exclude
	 * Unique identifier used by ZigoEngine.register
	 */ 
	public static var registryKey:String = 'fuseItem';
	
	/**
	 * When true, known tween properties may omit underscores (x will convert to _x, etc.)
	 */ 
	public static var ADD_UNDERSCORES:Boolean = true; 
	
	/**
	 * FuseItem's current index in the engine's array stack. index is 0-based like an Array. Can be set externally at any time by parent Fuse if items are spliced or reordered.
	 */ 
	
	public var _nItemID:Number;
	
	/**
	 * An internal reference to the ZigoEngine class. Fuse + FuseItem may be used without ZigoEngine so an import statement is not used to avoid unecessary filesize when the engine is not needed.
	 */
	private static var _ZigoEngine:Object;
	
	/**
	 * Original action object or array passed by user
	 */
	private var _initObj:Object;
	
	/**
	 * Unique ID of the FuseItem's parent Fuse instance.
	 */
	private var _nFuseID:Number;
	
	/**
	 * Private internal play-state value, usually toggling from -1 to 1; 0 is a special flag used during the addTweens cycle.
	 */ 
	public var _nPlaying:Number = -1;
	
	/**
	 * Internal memory flag indicating start properties have been preset during current play cycle.
	 */ 
	private var _bStartSet:Boolean = false;
	
	/**
	 * Internal flag indicating whether the FuseItem has triggered advance due to a trigger:true value in a profile.
	 */ 
	private var _bTrigger:Boolean = false;
	
	/**
	 * Internal array queue that is progressively deleted upon tween completion to track FuseItem completion. (Public for access by Fuse.getActiveTargets) 
	 */
	private var _aTweens:Array;
	
	/**
	 * Storage tank for FuseItem elements that are not handled by tweens: command, label, aEvents, and delay if no tweens found. (Public for access by Fuse.currentLabel, Fuse.skipTo)
	 */ 
	private var _oElements:Object;
	
	/**
	 * Internal storage array of parsed action objects, meaning any object with tweenable elements or elements where tweening may or may not occur.
	 */ 
	private var _aProfiles:Array;
	
	/**
	 * Verbose string listing the general contents of the FuseItem, viewable by calling traceItems on the parent Fuse instance.
	 */
	private var _sImage:String;
	
	/**
	 * An internal collection tank for variables used across multiple parseProfile calls as the FuseItem is being instantiated. Deleted when constructor is finished.
	 */ 
	private var _oTemps:Object;
	
	/**
	 * An internal collection of FuseItem instances generated when Fuse Object Syntax is used with <code>ZigoEngine.doTween</code>. These otherwise untracked instances are given an ID of -1 and are auto-deleted by the FuseItem class upon completion using <code>removeInstance</code>.
	 */
	private static var _aInstances:Array;
	
	/**
	* This method needn't be called as method call is rerouted here automatically upon <code>ZigoEngine.doTween</code>.
	* @return		comma-delimited string listing properties successfully added to the engine.
	*/
	public static function doTween():String
	{
		for (var i:String in arguments) {
			if (typeof arguments[i]=='object') {
				if (_aInstances==undefined) _aInstances = new Array();
				var o:FuseItem = new FuseItem(_aInstances.length, arguments[i], -1);
				return o.startItem();
			}
		}
	}

	// --------------------------------------------------------------------//
	// THIS CLASS IS FOR USE BY FUSE ONLY AND SHOULD BE CONSIDERED PRIVATE //
	//	1. Fuse-access methods
	//	2. Constructor & parseProfile
	//	3. doTweens, tween event handlers, utils 
	// --------------------------------------------------------------------//
	
	// 1.
	
	/**
	* label property queried by Fuse
	* @return		label string if FuseItem contains a label property
	*/ 
	public function getLabel():String
	{
		return _oElements.label;
	}
	
	/**
	* Fuse needs to retrieve original objects passed for Array methods that return them
	* @return		true if trigger has been fired within currently playing item
	*/ 
	public function hasTriggerFired():Boolean
	{
		return (_bTrigger==true);
	}
	
	
	/**
	* Fuse needs to retrieve original objects passed for Array methods that return them
	* @return		original action object as passed by user
	*/ 
	public function getInitObj():Object
	{
		return (_initObj);
	}
	
	/**
	* Fuse calls this to get additional playing or paused targets to add to defaults when getActiveTargets is called on a Fuse.
	* @return		a list of target objects or empty array
	*/ 
	public function getActiveTargets(defaultTargs:Array):Array
	{
		if (!(defaultTargs instanceof Array)) defaultTargs = [];
		if (!(_aTweens.length>0)) return defaultTargs;
		var found:Boolean = false;
		for (var i:String in _aTweens) {
			// filter duplicates
			for (var j:String in defaultTargs) { 
				if (defaultTargs[j]==(_aTweens[i]).targ) {
					found = true;
					break;
				}
			}
			if (found==false) {
				defaultTargs.unshift((_aTweens[i]).targ);
			}
		}
		return defaultTargs;
	}
	
	public function toString():String { return String((_sID())+':'+_sImage); }
	
	/**
	* Called by parent Fuse to retrieve simple freestanding delays (note that in certain cases FuseItems use ZigoEngine tweens to time complex delays, such as those that appear within an action group). Such non-tweened delays are centralized into the parent Fuse, which runs a setInterval timer and handles pause/resume behavior for that delay.
	* @param scope		current default scope set in parent Fuse instance
	* @return			delay in seconds
	*/
	public function evalDelay(scope:Object):Number 
	{
		var d:Object = _oElements.delay;
		if (d instanceof Function) {
			d = d.apply((_oElements.delayscope!=undefined) ? _oElements.delayscope : scope);
		}
		if (typeof d=='string') d = (parseClock(String(d)));
		if (_global.isNaN(Number(d))==true) return 0;
		return Number(d);
	}
	
	/**
	* Called by parent Fuse to play the FuseItem, including triggering commands, firing callbacks not associated with tweens, and starting tweens.
	* @param targs - an array of default targets currently set in parent Fuse instance
	* @param scope - current default scope set in parent Fuse instance
	* @return		returns successfully tweened props for doTween()
	*/
	public function startItem(targs:Array, scope:Object):String
	{
		_ZigoEngine = _global.com.mosesSupposes.fuse.ZigoEngine;
		var fuse:Object = _global.com.mosesSupposes.fuse.Fuse;
		var outputLevel:Number = (fuse!=undefined) ? fuse.OUTPUT_LEVEL : _ZigoEngine.OUTPUT_LEVEL;
		// Fuse command like 'pause' or 'stop'. v2.0: Only delay,scope,args are retained for items containing command.
		if (_oElements.command!=null) { 
			var validCommands:String = '|start|stop|pause|resume|skipTo|setStartProps|';
			var cs:Object = (_oElements.scope || scope); // profile scope used for eval only. command always sent to parent fuse
			var command:String = (_oElements.command instanceof Function) ? String(_oElements.command.apply(cs)) : String(_oElements.command); // user can pass a Delegate to scope this
			// IMPORTANT: args param is not used during eval, args are passed to Fuse, primarily for use with skipTo(index/label)
			var args:Array = (_oElements.args instanceof Function) ? _oElements.args.apply(cs) : _oElements.args;
			if (validCommands.indexOf('|'+command+'|')==-1 || (command=='skipTo' && args==undefined)) {
				if (outputLevel>0) FuseKitCommon.error('111', command);
			}
			else {
				_nPlaying = 1;
				if (!(args instanceof Array)) args = (args==null) ? [] : [args];
				dispatchRequest(String(command), args);
			}
			return null;
		}
		// Changed order to deal with skipLevel. Now we tween first then fire callbacks and events.
		if (_aTweens.length>0) this.stop();
		_ZigoEngine.addListener(this); // For monitoring targets that go missing. Only one corresponding remove, in stop(), which is called by complete().
		_nPlaying = 2; // Special flag meaning doTweens is running, important for avoiding onTweenInterrupt/End conflicts.
		var propsAdded:String = null;
		if (_aProfiles.length>0) {
			if (_ZigoEngine==undefined) {
				FuseKitCommon.error('112');
			}
			else {
				propsAdded = doTweens(targs, scope, false);
			}
		}
		// do not move. Callbacks can contain pause or other play commands, so this is checked afterward
		_nPlaying = 1; 
		
		// Non-tween callbacks & events (skipped if skipLevel is 2 and all tweens failed)
		var fa:Array = _oElements.aEvents;
		for (var i:String in fa) {
			if (propsAdded==null && _aTweens.length>0 && (fa[i]).skipLevel==2) continue;
			fireEvents(fa[i],scope,outputLevel);
		}
		if (propsAdded==null && !(_aTweens.length>0) && _nPlaying==1) {
			if (outputLevel==3) FuseKitCommon.output('-'+(_sID())+' no tweens added - item done. [getTimer()='+getTimer()+']');
			// Use a setInterval for callback-only items to avoid a continuous action list which can lock the player
			var breakChainInt:Number;
			breakChainInt = setInterval(function(fi:FuseItem){
				clearInterval(breakChainInt);
				fi.complete(outputLevel);
			},1,this);
		}
		return propsAdded;
	}
	
	/**
	* Called by parent Fuse to stop the FuseItem's tweens. If currently playing, the internal method onStop is called which clears current tween list and associated listeners.
	*/
	public function stop():Void
	{
		// (for onTweenInterrupt)
		var doOnStop:Boolean = (_nPlaying>-1); 
		_nPlaying = -1;
		// active stop: clear this item's tweens and remove listeners
		if (doOnStop==true) onStop();
		_ZigoEngine.removeListener(this);
	}
	
	// -- private --
	
	private static function removeInstance(id:Number):Void
	{
		FuseItem(_aInstances[id]).destroy();
		delete _aInstances[id];
	}
	
	/**
	* Clears active elements. (Fuse event reverse-subscribed by parent Fuse)
	*/
	private function onStop():Void 
	{
		_bStartSet = false;
		for (var i:String in _aTweens) {
			var to:Object = _aTweens[i];
			to.targ.removeListener(this);
			_ZigoEngine.removeTween(to.targ, to.props);
			delete _aTweens[i];
		}
		delete _aTweens;
		_bTrigger = false;
	}
	
	/**
	* An event dispatched by parent Fuse to all child FuseItems to preset tween start-values.
	* @param o		event object containing a .filter property which can specify exclusion from the call
	*/
	private function evtSetStart(o:Object):Void
	{
		// no starts to set or Fuse is about to play this item.
		if (_sImage.indexOf('StartProps:')==-1 || o.curIndex==_nItemID) {
			return;
		}
		if (o.all!=true) {
			var match:Boolean = false;
			for (var i:String in o.filter) {
				if (Number(o.filter[i])==_nItemID || String(o.filter[i])==_oElements.label) match = true;
			}
			if (match==false) {
				return;
			}
		}
		doTweens(o.targs, o.scope, true);
		// flag removed when parent Fuse stopped.
		_bStartSet = true;
	}

	
	/**
	* Called by parent Fuse to pause or resume the FuseItem's tweens and tweened delays. During resume it is not assumed that targets and pauses are intact, each is checked and the internal tween array is trimmed if items have gone missing.
	* @param resume		 indicates whether it is a pause or resume call
	*/
	public function pause(resume:Boolean):Void
	{
		if (_nPlaying==-1) return;
		_nPlaying = ((resume==true) ? 1 : 0);
		for (var i:String in _aTweens) {
			var o:Object = _aTweens[i];
			var t:Object = o.targ;
			var p:Object = o.props;
			if (resume==true) {
				// Is pause intact? Target/prop could have been manipulated since it was paused here.
				var missing:Array = [];
				var oldTL:Number = _aTweens.length;
				for (var j:String in p) {
					if (_ZigoEngine.isTweenPaused(t,p[j])==false) missing.push(p[j]);
				}
				if (missing.length>0) {
					onTweenEnd({__zigoID__:o.targZID, props:missing, isResume:true});
				}
				if (_aTweens.length==oldTL) { // otherwise onTweenEnd removed the tween
					t.addListener(this);
					_ZigoEngine.unpauseTween(t, o.props);
				}
			}
			else {
				t.removeListener(this);
				_ZigoEngine.pauseTween(t, o.props);
			}
		}
		if (resume==true && !(_aTweens.length>0)) { // no tweens.
			this.stop();
			dispatchRequest('advance');
		}
		else if (resume==true) {
			_ZigoEngine.addListener(this);
		}
		else {
			_ZigoEngine.removeListener(this);
		}
	}
	
	/**
	* Called by parent Fuse to clear FuseItem instance's memory and listeners during Fuse's destroy cycle.
	*/
	public function destroy():Void
	{
		var doRemove:Boolean = (_nPlaying>-1);
		_nPlaying = -1;
		for (var i:String in _aTweens) {
			var o:Object = _aTweens[i];
			o.targ.removeListener(this);
			if (doRemove==true) _ZigoEngine.removeTween(o.targ, o.props);
			delete _aTweens[i];
		}
		for (var j:String in this) {
			delete this[j];
		}
	}
	
	private function dispatchRequest(type:String, args:Array):Void
	{// avoids import of Fuse class since FuseItem can be used with ZigoEngine as an Object Syntax extension
		var f:Object = _global.com.mosesSupposes.fuse.Fuse.getInstance(_nFuseID); 
		if (!(args instanceof Array) && args!=null) args = (new Array(args));
		Function(f[type]).apply(f, args);
	}
	
	// 2.
	
	// Concise string ID representing the parent Fuse's fixed ID and the FuseItem's current index in the Fuse, such as "Fuse#0>Item#0"
	private function _sID():String // like "Fuse#0>Item#0"
	{
		if (_nFuseID==-1) {
			return ('One-off tween');
		}
		return ('Fuse#'+String(_nFuseID)+'>Item#'+String(_nItemID));
	}
	
	/**
	* Constructor - Attempts to parse action(s) into <code>_oElements</code> and <code>_aProfiles</code>, building the verbose string ID <code>_sImage</code> in the process.
	* @param id			current index of FuseItem in parent Fuse instance
	* @param o			action object or Array of action objects pushed into the Fuse for parsing
	* @param fuseID		permanent unique ID of parent Fuse stored in _nFuseID
	*/
	public function FuseItem (id:Number, o:Object, fuseID:Number)
	{
		_ZigoEngine = _global.com.mosesSupposes.fuse.ZigoEngine;
		this._nItemID = id;
		this._nFuseID = fuseID;
		this._initObj = o;
		
		_aProfiles = [];
		_oElements = { aEvents:[] };
		_oTemps = {};
		if (!(o instanceof Array)) o = [o];
		var fuse:Object = _global.com.mosesSupposes.fuse.Fuse;
		_oTemps.outputLevel = (fuse!=undefined) ? fuse.OUTPUT_LEVEL : _global.com.mosesSupposes.fuse.ZigoEngine.OUTPUT_LEVEL;
		
		// Command Actions can now only contain delay, label, scope, args and may not be nested in groups.
		if (o.length==1) {
			var o0:Object = o[0];
			var obj:Object = (o0.action!=undefined) ? o0.action : o0;
			if (obj.__buildMode!=true && obj.command!=undefined) {
				_oElements.command = obj.command;
				_oElements.scope = obj.scope; // v2.0: changed commandscope & commandargs to scope, args.
				_oElements.args = obj.args;
				_sImage = ' Elements:['+('command'+((typeof obj.command=='string') ? ':"'+obj.command+'", ' : ', '));
				if (obj.label!=undefined && typeof obj.label=='string') {
					_sImage+=('label:"'+obj.label+'", ');
					_oElements.label = obj.label; // one label per Command Action
				}
				if (obj.delay!=undefined) {
					_sImage+='delay, ';
					_oElements.delay = obj.delay; // one delay per Command Action
				}
				if (obj.func!=undefined && _oTemps.outputLevel>0) FuseKitCommon.error('113');
				return;
			}
		}
		
		// persistant vars for looping through actions
		_oTemps.sImgS = '';
		_oTemps.sImgE = '';
		_oTemps.sImgB = '';
		_oTemps.afl = 0;
		_oTemps.ael = 0;
		_oTemps.twDelayFlag = false;
		_oTemps.nActions = o.length;
		_oTemps.fuseProps = FuseKitCommon._fuseprops();
		_oTemps.cbProps = FuseKitCommon._cbprops();
		_oTemps.sUP = FuseKitCommon._underscoreable();
		_oTemps.sCT = FuseKitCommon._cts();
		
		// Parse each profile.
		for (var i:String in o) {
			var item:Object = o[i];
			if (item.label!=undefined && typeof item.label=='string') _oElements.label = item.label; // one string-only label per FuseItem
			var a:Object;
			var aap:Object;
			var bApplied:Boolean = Boolean(typeof item.action=='object' && !(item.action instanceof Array)); // reject arrays in action param!
			if (bApplied==true) {
				a = item.action;
				aap = { // applied-action profile, these props are mixed into the action during parseProfile.
					delay:item.delay,
					target:item.target,
					addTarget:item.addTarget,
					label:item.label,
					trigger:item.trigger
				};
			}
			else {
				a = item;
			}
			var oPr:Object = parseProfile(a, aap);
			if (oPr!=undefined) {
				_aProfiles.unshift(oPr);
			}
		}
		
		// build string image (if a command was passed in, this happens up top.)
		_sImage = '';
		var str:String = '';
		if (_oElements.label!=undefined) str+=('label:"'+_oElements.label+'", ');
		if (_oTemps.afl>0) str+= ((_oTemps.afl>1) ? _oTemps.afl+' callbacks, ' : 'callback, ');
		if (_oElements.delay!=undefined || _oTemps.twDelayFlag==true) str+='delay, ';
		if (_oTemps.ael>0) str+= ((_oTemps.ael>1) ? _oTemps.ael+' events, ' : 'event, ');
		if (str!='') _sImage+=' Elements:['+(str.slice(0,-2))+']';
		if (_oTemps.sImgS!='') _sImage+= ' StartProps:['+(_oTemps.sImgS.slice(0,-2))+']'; // careful: "StartProps:" is checked in evtSetStart
		if (_oTemps.sImgE!='') _sImage+= ' Props:['+(_oTemps.sImgE.slice(0,-2))+']';
		if (_oTemps.sImgB!='') _sImage+= ' Simple Syntax Props:['+(_oTemps.sImgB.slice(0,-1))+']';
		delete _oTemps;
	}
	
	/**
	* Used by constructor to parse each action object passed (multiple objects can be passed in an Array for simultaneous action groups). The parsing process is a fairly complex procudure that blocks tween start & end properties, tags 'auto-fill' end properties in which only a start value was passed, extracts freestanding items that do not require tweens, and generates proxy tweens used to handle delays within groups.
	* @param obj			the action object to be parsed into a profile and pushed into _aProfiles
	* @param aap			Stands for 'applied action profile' object. When an 'applied action' is encountered, this override profile mixes properties into the resulting profile.
	* @return				parsed profile object
	*/
	private function parseProfile(obj:Object, aap:Object):Object 
	{
		var i:String, j:String, k:String;
		// Build Mode objects
		if (obj.__buildMode==true) {
			if (obj.command=='delay') { // New feature: addCommand('delay',Number)
				_oElements.delay = obj.commandargs;
			}
			if (obj.func!=undefined) {
				_oTemps.afl++;
				_oElements.aEvents.unshift({f:obj.func,s:obj.scope,a:obj.args});
			}
			if (obj.tweenargs!=undefined) {
				_oTemps.sImgB += (obj.tweenargs[1].toString()+','); // (allowing duplicates in simple syntax props image to save code, since it could be comma-delim str)
				return obj;
			}
			return null;
		}
		var oPr:Object = {
			trigger:(aap.trigger!=undefined || obj.trigger!=undefined),
			delay:(aap.delay!=undefined) ? aap.delay : obj.delay,
			ease:obj.ease,
			seconds:obj.seconds,
			event:obj.event,
			eventparams:obj.eventparams,
			skipLevel:(typeof obj.skipLevel=='number' && obj.skipLevel>=0 && obj.skipLevel<=2) ? obj.skipLevel : (_ZigoEngine.SKIP_LEVEL || 0), // correct early for use in FuseItem.doTweens
			oSP:{},
			oEP:{},
			oAFV:{}
		};
		// synonyms (cannot use || with string for some reason)
		if (oPr.delay==undefined) oPr.delay = obj.startAt; 
		if (oPr.ease==undefined) oPr.ease = obj.easing; // synonym (cannot use OR eval with string for some reason)
		if (oPr.seconds==undefined) oPr.seconds = ((obj.duration!=undefined) ? obj.duration : obj.time); // synonym (cannot use OR eval with string for some reason)

		// applied action target param overrides action target param
		if (aap.target!=undefined) oPr.target = ((aap.target instanceof Array) ? aap.target : [aap.target]);
		else if (obj.target!=undefined) oPr.target = ((obj.target instanceof Array) ? obj.target : [obj.target]);
		// applied action addTarget param adds to action addTarget param (don't change order)
		if (obj.addTarget!=undefined) oPr.addTarget = ((obj.addTarget instanceof Array) ? obj.addTarget : [obj.addTarget]);
		if (aap.addTarget!=undefined) {
			if (oPr.addTarget==undefined) oPr.addTarget = ((aap.addTarget instanceof Array) ? aap.addTarget : [aap.addTarget]);
			else oPr.addTarget = ((oPr.addTarget instanceof Array) ? (oPr.addTarget.concat(aap.addTarget)) : ((new Array(oPr.addTarget)).concat(aap.addTarget)));
		}
		var bTwFlag:Boolean = false;
		for (j in obj) {
			var v:Object = obj[j];
			if ((_oTemps.cbProps).indexOf('|'+j+'|')>-1) {//'|cycles|easyfunc|func|scope|args|startfunc|startscope|startargs|updfunc|updscope|updargs|extra1|extra2|'
				if (j!='skipLevel') oPr[j] = v;
				continue;
			}
			if ((_oTemps.fuseProps).indexOf('|'+j+'|')>-1) {//'|command|label|delay|event|eventparams|target|addTarget|trigger|startAt|ease|easing|seconds|duration|time|'
				if (j=='command' && _oTemps.nActions>1 && _oTemps.outputLevel>0) FuseKitCommon.error('114',String(v));
				continue;
			}
			if (typeof v=='object') {
				var copy:Object = (v instanceof Array) ? ([]) : {};
				for (k in v) copy[k] = v[k];
				v = copy;
			}
			var se:Object;
			var seCP:Object;
			if (j.indexOf('start')==0) {
				j = j.slice(6);
				se = oPr.oSP;
			}
			else {
				se = oPr.oEP;
			}
			if (ADD_UNDERSCORES==true && _oTemps.sUP.indexOf('|_'+j+'|')>-1) j='_'+j;
			if (_oTemps.sCT.indexOf('|'+j+'|')>-1) {
				var addPct:Boolean = (j=='_tintPercent' && se.colorProp.p=='_tint');
				var addTint:Boolean = (j=='_tint' && se.colorProp.p=='_tintPercent');
				if (se.colorProp==undefined || addPct==true || addTint==true) { // write only 1 color prop per profile, saves cleanup work during tween.
					if (addPct==true) se.colorProp = {p:'_tint', v:{ tint:se.colorProp.v, percent:v }};
					else if (addTint==true) se.colorProp = {p:'_tint', v:{ tint:v, percent:se.colorProp.v }};
					else se.colorProp = {p:j, v:v};
					bTwFlag = true;
				}
				else if (_oTemps.outputLevel>0) {
					FuseKitCommon.error('115',(_sID()),j);
				}
			}
			else if (v!=null) { // (null values are only accepted for color props)
				if (se==oPr.oEP && (obj.controlX!=undefined || obj.controlY!=undefined) && (j.indexOf('control')==0 || j=='_x' || j=='_y')) { // group bezier end props
					if (se._bezier_==undefined) se._bezier_ = {};
					if (j.indexOf('control')==0) se._bezier_[j] = v; //controlX, controlY
					else (se._bezier_[(j.charAt(1))] = v); // x, y
				}
				else {
					se[j] = v;
				}
				bTwFlag = true;
			}
		} // end parse props(j), still looping through actions(i)
		
		// special case: nontween delay within a multi-item group or delay with start/update callbacks: play the delay as a tween
		// (normally a nontween delay, which may also include an end callback, is handled by parent Fuse using more setInterval which is more accurate.)
		var nonTweenDelay:Boolean = (bTwFlag==false && ((oPr.startfunc!=undefined || oPr.updfunc!=undefined)
									 				 || (oPr.delay!=undefined && _oTemps.nActions>1)));
		if (_ZigoEngine==undefined && nonTweenDelay==true) { // ignore output level for crucial error message
			FuseKitCommon.error('116');
			nonTweenDelay = false;
		}
		if (nonTweenDelay==true) {
			if (oPr.func!=undefined) _oTemps.afl++;
			if (oPr.event!=undefined) _oTemps.ael++;
			oPr.target = ['temp']; // A target it necessary in order to avoid missing-target errors and so doTweens loop will execute
			_oTemps.twDelayFlag = true;
			return oPr;
		}
		if (bTwFlag==true) { // do a final round of cleanup on tween profile and build string image
			var bEC:Boolean = (oPr.oEP.colorProp!=undefined);
			for (var l:Number=0; l<2; l++) {
				var se:Object = (l==0) ? oPr.oSP : oPr.oEP;
				var str:String = (l==0) ? _oTemps.sImgS : _oTemps.sImgE;
				var sCP:String = se.colorProp.p;
				if (sCP!=undefined) { // combine color back in (colorProp was used to enforce single start/end color)
					se[sCP] = se.colorProp.v;
					delete se.colorProp;
				}
				if ((se._xscale!=undefined || se._scale!=undefined) && (se._width!=undefined || se._size!=undefined)) {
					var discard:String = (se._xscale!=undefined) ? '_xscale' : '_scale';
					delete se[discard];
					if (_oTemps.outputLevel>0) FuseKitCommon.error('115',(_sID()),discard);
				}
				if ((se._yscale!=undefined || se._scale!=undefined) && (se._height!=undefined || se._size!=undefined)) {
					var discard:String = (se._yscale!=undefined) ? '_yscale' : '_scale';
					delete se[discard];
					if (_oTemps.outputLevel>0) FuseKitCommon.error('115',(_sID()),discard);
				}
				for (j in se) {
					if (str.indexOf(j+', ')==-1) str+=(j+', ');
					if (se==oPr.oSP) {
						if (oPr.oEP[j]==undefined && !(j==sCP && bEC==true)) { // add 'autofill' lookup
							oPr.oAFV[j] = true;
							oPr.oEP[j] = [];
						}
					}
				}
				((l==0) ? _oTemps.sImgS = str : _oTemps.sImgE = str);
			}
			return oPr;
		}
		// If no tweens were added or start/end profiles ended up empty, move usable props to _oElements
		if (oPr.delay!=undefined && _oTemps.nActions==1) { // single-item actions only, see first if() in this block for multi-item actions
			_oElements.delay = oPr.delay;
			_oElements.delayscope = oPr.scope; // (internal, not a valid user prop!)
		}
		if (oPr.event!=undefined) {
			_oTemps.ael++;
			_oElements.aEvents.unshift({e:oPr.event, s:oPr.scope, ep:oPr.eventparams, skipLevel:oPr.skipLevel});
		}
		// actions containing startfunc/updfunc are handled w/nonTweenDelay.
		var oldL:Number = _oElements.aEvents.length;
		if (oPr.easyfunc!=undefined) _oElements.aEvents.push({cb:oPr.easyfunc, s:oPr.scope, skipLevel:oPr.skipLevel});
		if (oPr.func!=undefined) _oElements.aEvents.push({f:oPr.func, s:oPr.scope, a:oPr.args, skipLevel:oPr.skipLevel});
		_oTemps.afl+=(_oElements.aEvents.length-oldL);
		delete oPr;
		return undefined;
	}
	
	// 3.
	
	/**
	* Internal method to preset start values and generate tween calls to be sent to the engine. This is a complex procedure mainly due to the 'runtime-evaluation' feature of the Kit - scope, target(s), and all start and end values delegated to a function are retrieved by executing such functions just as the item is encountered in the sequence. doTweens handles all of this, builds and sends the tween calls while storing a reference in the internal _aTweens array. It then does emergency cleanup in situations where no tweens successfully fired and boolean end-values, callbacks, or delays are orphaned. Presetting start values is handled with 0-second tween calls which is important for interrupting any current tweens, which are monitored by any running Fuses; Start values with missing end-values are 'auto-filled' during doTweens.
	* @param targs			parent Fuse instance's current default targets
	* @param defaultScope	parent Fuse instance's current default scope
	* @param setStart		flag indicating that the doTweens call should only preset start values.		
	* @return 				returns successfully tweened props for doTween()
	*/
	private function doTweens(targs:Array, defaultScope:Object, setStart:Boolean):String
	{
		if (_aTweens==null) {
			this._aTweens = [];
		}
		var fuse:Object = _global.com.mosesSupposes.fuse.Fuse;
		var outputLevel:Number = (fuse!=undefined) ? fuse.OUTPUT_LEVEL : _ZigoEngine.OUTPUT_LEVEL;
		var propsAdded:String = '';
		var eventCache:Object = {};
		var h:String, i:String, j:String, k:String;
		// Build-Mode FuseItem (startprops option doesn't exist here)----------
		if ((_aProfiles[0]).__buildMode==true) { 
			for (h in _aProfiles) {
				var twArgs:Array = (_aProfiles[h]).tweenargs;
				if ((twArgs[6]).cycles===0 || ((twArgs[6]).cycles.toUpperCase())=='LOOP') {
					delete (twArgs[6]).cycles;
					if (outputLevel>0) FuseKitCommon.error('117',(_sID()));
				}
				var sProps:String = (_ZigoEngine.doTween.apply(_ZigoEngine, twArgs));
				var aProps:Array = ((sProps==null) ? [] : (sProps).split(','));
				if (aProps.length>0) {
					_aTweens.push({targ:(twArgs[0]), props:aProps, targZID:(twArgs[0]).__zigoID__});
					(twArgs[0]).addListener(this);
					for (j in aProps) if (propsAdded.indexOf(aProps[j]+',')==-1) propsAdded+=(aProps[j]+',');
				}
				if (outputLevel==3) FuseKitCommon.output(newline+'-'+(_sID())+' TWEEN (simple syntax)\n\ttargets:['+twArgs[0]+']\n\tprops sent:['+twArgs[1]+']');
			}
			return ((propsAdded=='') ? null : propsAdded.slice(0,-1));
		}
		// Normal setStart, tweens ---------------------------------------------
		var doSetStarts:Boolean = (_bStartSet!=true && (setStart==true || _sImage.indexOf('StartProps:')>-1));
		// cycling through each action profile
		for (h in _aProfiles) 
		{
			var pr:Object = _aProfiles[h];
			var bTrigger:Boolean = (pr.trigger==true);
			
			// Set scope for callbacks + runtime-eval funcs.
			// Each action may define a "scope" param which overrides Fuse default scope
			var scope:Object = defaultScope; // this local is used many times within this loop for runtime-eval
			if (pr.scope!=undefined) {
				// scope param can be a runtime func (or delegate) that uses Fuse default scope to eval. 
				// (The evaled scope will cascade to updscope & startscope if they are funcs.)
				scope = (pr.scope instanceof Function) ? pr.scope.apply(scope) : pr.scope;
			}
			var cb:Object = { skipLevel:((pr.skipLevel instanceof Function) ? pr.skipLevel.apply(scope) : pr.skipLevel) };
			var cb2:Object = { skipLevel:cb.skipLevel };
			if (pr.extra1!=undefined) cb2.extra1 = cb.extra1 = (pr.extra1 instanceof Function) ? pr.extra1.apply(scope) : pr.extra1;
			if (pr.extra2!=undefined) cb2.extra2 = cb.extra2 = (pr.extra2 instanceof Function) ? pr.extra2.apply(scope) : pr.extra2;
			if (pr.cycles!=undefined) {
				var cycles:Object = ((pr.cycles instanceof Function) ? pr.cycles.apply(scope) : pr.cycles);
				if ((cycles===0 || (String(cycles).toUpperCase())=='LOOP') && fuse!=undefined) {
					delete pr.cycles;
					if (outputLevel>0) FuseKitCommon.error('117',(_sID()));
				}
				else cb2.cycles = cb.cycles = cycles;
				delete cycles;
			}
			if (pr.easyfunc!=undefined || pr.func!=undefined || pr.startfunc!=undefined || pr.updfunc!=undefined) {
				for (i in pr) {
					if (i.indexOf('func')>-1) {
						cb[i] = pr[i];
					}
					else if (i=='startscope' || i=='updscope' || i.indexOf('args')>-1) {
						cb[i] = (pr[i] instanceof Function) ? Function(pr[i]).apply(scope) : pr[i];
					}
				}
				if (cb.func!=undefined && cb.scope==undefined) cb.scope = scope; // auto-fill callback scopes where possible
				if (cb.updfunc!=undefined && cb.updscope==undefined) cb.updscope = scope;
				if (cb.startfunc!=undefined && cb.startscope==undefined) cb.startscope = scope;
			}
			
			// profile's custom event gets handled separately from callbacks in onTweenEnd.
			var oEvent:Object = (pr.event==undefined) ? undefined : {e:pr.event, ep:pr.eventparams, s:scope};
			
			// Targets
			// evaluated targets + addTargets
			var tg:Array = []; 
			var aBase:Array = (pr.target==undefined) ? targs : pr.target; 
			var aTemp:Array = [];
			var nTgErrors:Number = 0;
			// (any runtime func (or delegate) may return one targ or an array of targs)
			for (i in aBase) { 
				var v:Object = aBase[i];
				aTemp = aTemp.concat((v instanceof Function) ? v.apply(scope) : v);
			}
			for (i in pr.addTarget) {
				var v:Object = pr.addTarget[i];
				aTemp = aTemp.concat((v instanceof Function) ? v.apply(scope) : v);
			}
			for (i in aTemp) {
				var v:Object = aTemp[i];
				if (v!=null) {
					var exists:Boolean = false;
					for (j in tg) {
						if (tg[j]==v) {
							exists = true;
							break;
						}
					}
					if (exists==false) tg.unshift(v);
				}
				else {
					nTgErrors++;
				}
			}
			if (tg.length==0) {
				if (outputLevel>0) FuseKitCommon.error('118',(_sID()),doSetStarts);
				if (doSetStarts==true) {
					stop();
					dispatchRequest('advance');
				}
				return null;
			}
			if (nTgErrors>0 && outputLevel>0) {
				FuseKitCommon.error('119',doSetStarts,nTgErrors,(_sID()));
			}
			
			// -- 1. start props --
			if (doSetStarts==true)
			{
				// generate one ZigoEngine.doTween() call per target. Props parsed for runtime-eval, bools, validation
				for (i in tg) { 
					var targ:Object = tg[i];
					var aSP:Array = [];
					var aSV:Array = [];
					if (setStart==true) {
						for (var q:String in pr.oEP) {
							// Use 3rd param createNew to pre-create any missing filters on setStartProps, so the filter doesn't suddenly appear just before that action starts.
							_global.com.mosesSupposes.fuse.FuseFMP.getFilterProp(targ,q,true); 
						}
					}
					for (var p:String in pr.oSP) {
						var v:Object = pr.oSP[p];
						if (v instanceof Function) v = v.apply(scope);
						if (v===true || v===false) { // set start booleans immediately. 
							targ[p] = v;
							if (pr.oAFV[p]==true) { // prohibit autofill with booleans.
								for (k in pr.oEP[p]) if (pr.oEP[p][k].targ==targ) pr.oEP[p].splice(Number(k),1);
								pr.oEP[p].push({targ:targ,val:'IGNORE'});
							}
							continue;
						}
						// autofill missing end values. Assume resets for known properties, otherwise take a snapshot of the current value to return to.
						if (pr.oAFV[p]==true && !(p=='_colorReset' && v==100) && !(p=='_tintPercent' && v==0)) {// if no endprop was passed for startprop, store current value (does not apply to color prop which resets, preset during constructor parse)
							var afv:Object;
							if (p=='_tint' || p=='_colorTransform') {
								afv = _ZigoEngine.getColorTransObj();
							}
							else if (('|_alpha|_contrast|_invertColor|_tintPercent|_xscale|_yscale|_scale|').indexOf('|'+p+'|')>-1) {
								afv = 100;
							}
							else if (('|_brightness|_brightOffset|_colorReset|_rotation|').indexOf('|'+p+'|')>-1) {
								afv = 0;
							}
							else { // snapshot current val, retaining target (which is important in the case of relative endvals)
								var fmpVal:Number = _global.com.mosesSupposes.fuse.FuseFMP.getFilterProp(targ,p,true);
								if (fmpVal!=null) afv = fmpVal;
								else afv = (_global.isNaN(targ[p])==false) ? targ[p] : 0;
							}
							for (k in pr.oEP[p]) if (pr.oEP[p][k].targ==targ) pr.oEP[p].splice(Number(k),1);
							pr.oEP[p].push({targ:targ,val:afv});
						}
						if (typeof v=='object') {
							var copy:Object = (v instanceof Array) ? ([]) : {};
							for (k in v) copy[k] = ((v[k]) instanceof Function) ? Function(v[k]).apply(scope) : v[k];
							v = copy;
						}
						aSP.push(p);
						aSV.push(v);
					}// end startprops loop(n)
					
					// set starts using egine, which monitors/broadcasts interrupts + parses complex properties.
					if (aSV.length>0) {
						if (outputLevel==3) FuseKitCommon.output('-'+(_sID())+' '+targ+' SET STARTS: '+['['+aSP+']', '['+aSV+']']);
						_ZigoEngine.doTween(targ, aSP, aSV, 0);
					}
				} // end set starts
			}// end if startprops
			
			if (setStart==true) continue;
			
			
			// -- 2. end props --
			// Generate one ZigoEngine.doTween() call per target. 
			// Props parsed for runtime-eval, bools, validation, and autofills (startvals without endval)
			for (i in tg) { 
				// Eval other per-profile params (putting this in the loop is less efficient but it allows r-eval-funcs to be run per target.)
				// Q: when a user builds an action and there are multiple targets, do they want getters to be fired per target, or per action?
					var ease:Object = pr.ease;
					if (ease instanceof Function) { // could be a runtime eval function!
						var ef:Function = (Function(ease));
						if (typeof ef(1,1,1,1)!='number') ease = ef.apply(scope); // it's not a valid easing equation the engine can use.
					}
					var seconds:Object = (pr.seconds instanceof Function) ? pr.seconds.apply(scope) : pr.seconds;
					if (typeof seconds=='string') seconds = (parseClock(String(seconds)));
					var delay:Object = (pr.delay instanceof Function) ? pr.delay.apply(scope) : pr.delay;
					if (typeof delay=='string') delay = (parseClock(String(delay)));
				// ---------------------------------------------------------------
				//parse
				var targ:Object = tg[i];
				var aEP:Array = [];
				var aEV:Array = [];
				var oBools:Object = {};// Group end-booleans per target to be set in onTweenEnd
				for (var p:String in pr.oEP) {
					var v:Object = pr.oEP[p];
					if (v instanceof Function) {
						v = v.apply(scope);
					}
					if (v===true || v===false) { // end booleans will be attached to a tween & set in onTweenEnd.
						oBools[p] = v;
						continue;
					}
					if (typeof v=='object') {
						if ((v[0]).targ!=undefined) { // this is an autofilled property - match targets.
							for (k in v) {
								if ((v[k]).targ==targ) {
									v = (v[k]).val;
									break;
								}
							}
						}
						else {
							var copy:Object = (v instanceof Array) ? ([]) : {};
							for (k in v) copy[k] = ((v[k]) instanceof Function) ? Function(v[k]).apply(scope) : v[k];
							v = copy;
						}
					}
					if (v!='IGNORE') {
						aEP.push(p);
						aEV.push(v);
					}
				}// end endprops loop(n)
				
				var aProps:Array = [];
				if (aEV.length>0) {
					// normal tweens. monitor only the props that are added to the engine's tweenlist.
					var sProps:String = _ZigoEngine.doTween(targ, aEP, aEV, seconds, ease, delay, cb);
					if (sProps!=null) aProps = (sProps.split(','));
					if (aProps.length>0) {
						_aTweens.push({targ:targ, props:aProps, trigger:bTrigger, bools:oBools, event:oEvent, targZID:targ.__zigoID__});
						targ.addListener(this);
					}
					for (j in aProps) if (propsAdded.indexOf(aProps[j]+',')==-1) propsAdded+=(aProps[j]+',');
					// TRACE TWEENS (lets you know if one or more props didn't get added)
					if (outputLevel==3) {
						var cbstr:String='';
						for (j in cb) cbstr+=(j+':'+cb[j]+'|');
						var epstr:String = aEP.toString();
						if (aProps.length>aEP.length) epstr += (newline+'\t[NO-CHANGE PROPS DISCARDED. KEPT:'+sProps+']');
						var evstr:String = '';
						for (j in aEV) evstr=(((typeof aEV[j]=='string')?'"'+aEV[j]+'"':aEV[j]) + ', '+evstr);
						FuseKitCommon.output(newline+'-'+(_sID())+' TWEEN:'+newline+(['\t[getTimer():'+getTimer()+'] ','targ: '+targ, 'props: '+epstr, 'endVals: '+evstr, 'time: '+((seconds==undefined) ? _ZigoEngine.DURATION : seconds), 'easing: '+((ease==undefined) ? _ZigoEngine.EASING : ease), 'delay: '+((delay==undefined) ? 0 : delay), 'callbacks: '+((cbstr=='') ? '(none)':cbstr)]).join(newline+'\t')); 
					}
					if (!(cb.skipLevel==2)) {// Group per profile (careful, delete does not work.) The callback will have been used unless skipLevel is 2. 
						cb = cb2;	// Group callbacks per profile
						oEvent = undefined;
						if (eventCache[h]!=undefined) eventCache[h] = undefined; // if same event was cached, nix it
					}
				}
				if (aProps.length==0) {// Cases where no tweens were added (can happen if when all props are booleans, no-tween delay in a group...)
					if (seconds==undefined) seconds = 0;
					if (delay==undefined) delay = 0;
					if (pr.skipLevel==0 && seconds+delay>0) { // run a tweened delay before doing callbacks, booleans & events
						if (outputLevel==3) { FuseKitCommon.output('-'+(_sID())+' no props tweened - graft a delay ('+delay+' sec).'); }
						var proxy:Object = { __TweenedDelay:0 };
						_ZigoEngine.initializeTargets(proxy);
						_aTweens.push({targ:proxy, props:['__TweenedDelay'], trigger:bTrigger, bools:oBools, event:oEvent, actualTarg:targ, targZID:proxy.__zigoID__ });
						_ZigoEngine.doTween(proxy, '__TweenedDelay', 1, seconds+delay, null, 0, cb);
						cb = cb2;	// Group callbacks per profile
						proxy.addListener(this);
					}
					else { // immediate wrap-up
						if (outputLevel==3) { FuseKitCommon.output('-'+(_sID())+' no props tweened, executing nontween items. '); }
						for (j in oBools) targ[j] = oBools[j]; // set endbools immediately
						if (pr.skipLevel<2) {
							if (cb!=undefined) {
								if (cb.startfunc!=undefined) fireEvents({f:cb.startfunc,s:cb.startscope,a:cb.startargs},scope,outputLevel);
								if (cb.updfunc!=undefined) fireEvents({f:cb.updfunc,s:cb.updscope,a:cb.updargs},scope,outputLevel);
								if (cb.startfunc!=undefined || cb.easyfunc!=undefined) fireEvents({f:cb.func,s:cb.scope,a:cb.args,cb:cb.easyfunc},scope,outputLevel);
								cb = cb2;	// Group callbacks per profile
							} // This is only place where cb is allowed to persist into next cycle. If skipLevel is 2 in all actions and no tweens succeed it will go unfired.
							if (oEvent!=undefined) {
								eventCache[h] = oEvent; // store orphaned events, this is wiped if a tween is added in the profile since onTweenEnd will do the event.
							}
						}
					}
				}
				bTrigger = false; // Group trigger per profile
			} // end targets loop(i)
		} // end profiles loop(h)
		
		for (i in eventCache) {
			fireEvents(eventCache[h], (eventCache[h]).s, outputLevel);
		}
		
		return ((propsAdded=='') ? null : propsAdded.slice(0,-1));
	}
	
	/**
	* An event dispatched by each animation target via the engine. This method dissects the target and properties sent in the event object, looking for a match in the internal tween array <code>_aTweens</code>, which is progressively deleted. Also handles tweens tagged with a trigger property and sets boolean end values on associated tween completion.
	* @param o			event object containing target and completed-property information
	*/
	private function onTweenEnd(o:Object):Void
	{
		if (_nPlaying<1) return;
		var fuse:Object = _global.com.mosesSupposes.fuse.Fuse;
		var outputLevel:Number = (fuse!=undefined) ? fuse.OUTPUT_LEVEL : _ZigoEngine.OUTPUT_LEVEL;
		if (outputLevel==3) FuseKitCommon.output('-'+(_sID())+' onTweenEnd: '+((typeof o.target=='movieclip')?o.target._name:typeof o.target)+'['+o.props+'] [getTimer()='+getTimer()+']');
		var id:Number = ((o.__zigoID__!==undefined) ? o.__zigoID__ : o.target.__zigoID__);
		for (var i:String in _aTweens) {
			var to:Object = _aTweens[i];
			// safer to match ids since pause(resume) might be trying to clear out a missing target
			if (to.targZID==id) { 
				for (var j:String in o.props) {
					var pa:Array = to.props;
					for (var k:String in pa) {
						var p:String = pa[k];
						if (p==o.props[j]) {
							// interruption during doTweens looping
							if (_nPlaying==2) { 
								if (outputLevel>0) FuseKitCommon.error('120',(_sID()),p);
							}
							pa.splice(Number(k), 1);
							if (pa.length==0) {
								if (to.event!=undefined) {
									fireEvents(to.event, to.event.s, outputLevel);
								}
								if (to.trigger==true) {
									if (_bTrigger==false && o.isResume!=true && _aTweens.length>1) {
										_bTrigger = true;
										if (outputLevel==3) FuseKitCommon.output('-'+(_sID())+' trigger fired!');
										dispatchRequest('advance');
									}
								}
								var t:Object;
								if (p=='__TweenedDelay') {
									_ZigoEngine.deinitializeTargets(to.targ);
									delete to.targ; // try and dispose of the temp object
									t = to.actualTarg;
								}
								else {
									t = to.targ;
								}
								for (var m:String in to.bools) { // set boolean end vals
									t[m] = to.bools[m];
								}
								var found:Boolean = false;
								for (var l:String in _aTweens) {
									if (l!=i && (_aTweens[l]).targ==t) found = true;
								}
								if (found==false) { // target done
									t.removeListener(this);
								}
								_aTweens.splice(Number(i),1);
							}
						}
					}
				}
			}
		}
		if (_aTweens.length==0 && _nPlaying==1 && o.isResume!=true) { // tweens can be removed during pause(0) but don't advance.
			complete(outputLevel);
		}
	}
	
	/**
	* An event dispatched by the ZigoEngine class when a target is removed or a tween is overwritten.
	* @param o	event object containing target and interrupted-property information
	*/
	private function onTweenInterrupt(o:Object):Void
	{
		if (_nPlaying==-1) return;
		var id:Number = o.__zigoID__;
		var fuse:Object = _global.com.mosesSupposes.fuse.Fuse;
		var outputLevel:Number = (fuse!=undefined) ? fuse.OUTPUT_LEVEL : _ZigoEngine.OUTPUT_LEVEL;
		if (outputLevel==3) FuseKitCommon.output((_sID())+' property interrupt caught! '+o.target+',__zigoID__:'+id+'['+o.props+'].');
		if (id==undefined || typeof o.target!='string') { 
			onTweenEnd(o);
			return;
		}
		for (var i:String in _aTweens) { // target went missing, quickly strip out all _aTween objs with that target
			if ((_aTweens[i]).targZID==id) {
				_aTweens.splice(Number(i),1);
			}
		}
		if (_aTweens.length==0 && _nPlaying==1) {
			complete(outputLevel);
		}
	}
	
	/**
	* Internal method fired when the Fuse should advance.
	* @param outputLevel
	*/
	private function complete(outputLevel:Number):Void
	{
		var trigger:Boolean = _bTrigger;
		this.stop(); // will reset _nPlaying which is read by Fuse on last item.
		if (trigger==true) {
			dispatchRequest('advance',[true]);
		}
		else {
			if (outputLevel==3) FuseKitCommon.output('-'+(_sID())+' complete.');
			dispatchRequest('advance',[false]);
		}
	}
	
	/**
	* Internal method that parses 'timecode' style strings that user may pass for duration or delay. Strings must be in "00:00" format meaning seconds:hundreths.
	* @param str		the string value to be parsed into a numerical duration representing seconds
	* @return			time in seconds
	*/
	private function parseClock(str:String):Number 
	{ 
		if (str.indexOf(':')!=2) {
			FuseKitCommon.error('121');
			return (_ZigoEngine.DURATION || 0);
		}
		var time:Number = 0;
		var spl:Array = str.split(':');
		spl.reverse();
		var t:Number;
		if (String(spl[0]).length==2 && _global.isNaN(t = Math.abs(Number(spl[0])))==false) time += (t/100);// hundredths
		if (String(spl[1]).length==2 && _global.isNaN(t = Math.abs(Number(spl[1])))==false && t<60) time += t;// seconds
		if (String(spl[2]).length==2 && _global.isNaN(t = Math.abs(Number(spl[2])))==false && t<60) time += (t*60);// minutes
		if (String(spl[3]).length==2 && _global.isNaN(t = Math.abs(Number(spl[3])))==false && t<24) time += (t*3600);// hours - hah!
		return time;
	}
	
	/**
	* Internal method used to both trigger custom Fuse events and fire freestanding callbacks not handled by the engine.
	* @param o				condensed object with relevant information like scope, functions, arguments, event names, etc.
	* @param outputLevel	current outputLevel as determined by what classes are currently being used and what their <code>OUTPUT_LEVEL</code> settings are
	*/
	private function fireEvents(o:Object,scope:Object,outputLevel:Number):Void // logic should mirror core of ZigoEngine.parseCallback()
	{
		var s:Object = (o.s!=null) ? o.s : scope;
		if (o.e==undefined) { // callback
			if (typeof o.cb=='string' && o.cb.length>0) {
				var parsed:Object = _global.com.mosesSupposes.fuse.Shortcuts.parseStringTypeCallback(o.cb);
				if (parsed.func!=undefined) {
					fireEvents({s:parsed.scope,f:parsed.func,a:parsed.args});
				}
				else if (outputLevel>0) {
					FuseKitCommon.error('122');
				}
			}
			if (o.f==undefined) return;
			var f:Function = o.f;
			if (typeof o.f=='string' && s[o.f]==undefined) { 
				if (_global[o.f]!=undefined) f = _global[o.f];
				if (_level0[o.f]!=undefined) f = _level0[o.f];
			}
			if (typeof f!='function') {
				if (typeof s[o.f]=='function') f = s[o.f];
				else f = eval(o.f); // last grasp
			}
			if (f==undefined) {
				if (outputLevel>0) FuseKitCommon.error('123');
			}
			else {
				var args:Array = (o.a instanceof Function) ? o.a.apply(s) : o.a;
				if (args!=undefined && !(args instanceof Array)) args = [args];
				f.apply(s, args);
			}
		}
		else { // event (scope used only for runtime-eval)
			var type:String = (o.e instanceof Function) ? String(o.e.apply(s)) : String(o.e);
			if (type!='undefined' && type.length>0) {
				if (('|onStart|onStop|onPause|onResume|onAdvance|onComplete|').indexOf('|'+type+'|')>-1) {
					if (outputLevel>0) FuseKitCommon.error('124',type);
				}
				else {
					var fuse:Object = _global.com.mosesSupposes.fuse.Fuse.getInstance(_nFuseID);
					var evObj:Object = (o.ep instanceof Function) ? o.ep.apply(s) : o.ep;
					if (evObj==null || typeof evObj!='object') evObj = {};
					evObj.target = fuse;
					evObj.type = type;
					fuse.dispatchEvent.call(fuse,evObj); // make the Fuse dispatch the event
				}
			}
			else if (outputLevel>0) {
				FuseKitCommon.error('125',(_sID()));
			}	
		}
	}
}
