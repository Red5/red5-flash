import com.mosesSupposes.fuse.FuseItem; 
import com.mosesSupposes.fuse.FuseKitCommon;
import mx.utils.Delegate;
import mx.events.EventDispatcher;
/**
*
* Fuse Kit | (c) Moses Gunesch, see Fuse-Kit-License.html | http://www.mosessupposes.com/Fuse/
*
* @ignore
*
* Event sequencer that extends Array and may be paired with the ZigoEngine to sequence animation.
* @author	Moses Gunesch
* @version	2.0 (Beta-Y13)
*/
class com.mosesSupposes.fuse.Fuse extends Array
{
	/**
	 * @exclude
	 * Unique identifier used by ZigoEngine.register
	 */ 
	public static var registryKey:String = 'fuse';
	
	/**
	 * Enables kit version to be retrieved at runtime or when reviewing a decompiled swf. 
	 */
	public static var VERSION:String = FuseKitCommon.VERSION;
	
	/**
	 * Enables kit author to be retrieved at runtime or when reviewing a decompiled swf. 
	 */
	public static var AUTHOR:String = FuseKitCommon.AUTHOR;
	
	/**
	* @usage
	* Sets level of trace output for Fuse instance. Four settings available:
	* <ul>
	* 	<li>0 = no traces,</li> 
	*	<li>1 = normal errors,</li>
	*	<li>2 = additional fuse traces,</li>
	*	<li>3 = additional FuseItem traces</li>
	* </ul>
	* Set false if you need to use properties like "scale" or "rotation" as is. 
	*/
	public static var OUTPUT_LEVEL:Number = 1;
	
	/**
	 * A helpful memory management tools for beginners using a lot of Simple Syntax
	 * 
	 * @usage
	 * sets whether Fuse instance removes itself after finished playing once. If Fuse is set as a variable reference, those Fuses will need to be manually deleted to clear memory.
	 * set true to automatically remove Fuses after they finish playing once.
	 */ 
	public static var AUTOCLEAR:Boolean = false; 
	
	/**
	 * convenience, allows you to name any Fuse. You may later use this label to reference a Fuse instance in Simple Syntax methods like open().
	 */
	public var label:String; 
	
	/**
	 * Instance-level autoClear.
	 * @usage
	 * <pre>var f:Fuse = new Fuse();
	 * f.autoClear = true;</pre>
	 * In this example, the fuse instance f will delete itself after it plays through once.
	 * 
	 * @see #AUTOCLEAR
	 */ 
	public var autoClear:Boolean = false; 
	
	/**
	 * Default scope for all scoped actions in a Fuse (such as method-calls) if left unspecified within the action.
	 * @usage
	 * <pre>var f:Fuse = new Fuse();
	 * f.scope = this;
	 * f.push({ target:menu, 
	 * 			start_alpha:0, 
	 * 			startfunc:"setupMenu", 
	 * 			updfunc:"onMenuFadeUpdate", 
	 * 			func:"onMenuShown" });
	 * f.push({ scope:contentArea, func:"drawContent" });
	 * </pre>
	 * In this example, all the functions in the first action will be auto-scoped to the Fuse's default scope (this) whereas drawContent is specifically scoped to the contentArea object which will override the default scope.
	 * It's most useful to set a default scope when there will be many function calls within the sequence, to save you from specifically scoping each action.
	 */ 
	public var scope:Object;
	
	/**
	 * @exclude
	 * Written in during EventDispatcher.initialize(). 
	 */
	public var addEventListener:Function;
	/**
	 * @exclude
	 * Written in during EventDispatcher.initialize(). 
	 */
	public var removeEventListener:Function;
	
	/**
	 * Internal id based on instance count. 
	 */
	private var _nID:Number;
	
	/**
	 * Internal sequence play-index. 
	 */
	private var _nIndex:Number;
	
	/**
	 * Internal, can be "stopped", "playing", or "paused".
	 */
	private var _sState:String = 'stopped';
	
	/**
	 * Internal list of instance's default animation targets, set using public setter target or addTarget method.
	 */ 
	private var _aDefaultTargs:Array;
	
	/** 
	 * Internal setInterval id for delays run by Fuse. (Delays in groups or with tweens are handled by FuseItem.)
	 */
	private var _nDelay:Number = -1;
	
	/**
	 * Internal storage used for tracking a delay's current time during pause().
	 */ 
	private var _nTimeCache:Number = -1;
	
	/**
	 * Stores a Delegate function used to trap nested Fuse's onComplete event (stored for later removal during destroy()).
	 */ 
	private var _oDel1:Object;
	
	/**
	 * Static list of all Fuse instances created, publicly accessible via getInstance() and getInstances() and used by remote methods like open().
	 */ 
	private static var _aInstances:Array = null;
	
	/**
	 * Internal storage of Build Mode (Simple Syntax) params curID:Number (often queried to find out if Build Mode is active), prevID:Number, curGroup:Array.
	 */ 
	private static var _oBuildMode:Object = null;
	
	/**
	 * Written in during EventDispatcher.initialize().
	 */ 
	private var dispatchEvent:Function;
	
	/**
	* Constructor. 
	* @param action		Accepts any number of action objects or arrays to push into the instance.
	* @usage
	* <pre>
		var f:Fuse = new Fuse(
			{start_x:'-50', start_xscale:150, start_alpha:0, seconds:.5 },
			[ 
			 { width:500, ease:'easeInExpo', seconds:1 },
			 { height:300, ease:'easeInOutExpo', delay:.5 }
			]);
		f.target = box1_mc;
		f.start();
		
		f.traceItems();</pre>
	* 
	* Output:
	*	-Fuse#0 traceItems:
	*	----------
	*	Fuse#0>Item#0: StartProps:[_alpha, _xscale, _x] Props:[_x, _xscale, _alpha]
	*	Fuse#0>Item#1: Props:[_height, _width]
	*	----------
	*/
	function Fuse (action:Object)
	{		
		EventDispatcher.initialize(this);
		this._nID = registerInstance(this); // Fuse identifier retrievable using the ID property
		this._sState = 'stopped';
		this._aDefaultTargs = new Array();
		if (arguments.length>0) {
			this.splice.apply(this, ((new Array(0, 0)).concat(arguments)));
		}
		// retroactively disable some Array methods - this technique conserves filesize.
		var unsupport:Array = ['concat','join','sort','sortOn'];
		for (var i:String in unsupport) Fuse.prototype[unsupport[i]] = function() { if (Fuse.OUTPUT_LEVEL>0) FuseKitCommon.error('105'); };
	}
	
	/**
	* Deletes all variables and properties in the Fuse instance. 
	* @usage
	* You should remove all listeners before calling destroy(), then after the call delete any variable references to the instance cleared.
	* <pre>
	* myFuse.removeEventListener('onComplete',this);
	* myFuse.destroy();
	* delete myFuse;
	* </pre>
	*/
	public function destroy():Void
	{
		if (Fuse.OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+' destroy.');
		this.stop(true);
		splice(0,length);
		_aDefaultTargs = null;
		scope = null;
		// required for stripping listeners. 0,7 is not a mistake - do not change
		_global.ASSetPropFlags(this,null,0,7); 
		var id:Number = _nID;
		for (var i:String in this) delete this[i];
		removeInstanceAt(id, true);
		delete id;
		delete this;
	}
	
	/**
	* Returns error from FuseKitCommon.
	* @deprecated		remnant from fuse1.0, please review current setup options.
	*/
	public static function simpleSetup():Void
	{
		FuseKitCommon.error('101');
	}
	
	/**
	* Gets a Fuse instance by id or label
	* @param idOrLabel 		Fuse's numerical id (instance.id) or label (instance.label) identifying a unique Fuse instance.
	* @return				instance of Fuse object
	*/
	public static function getInstance(idOrLabel:Object):Fuse
	{
		if (typeof idOrLabel=='number') return _aInstances[idOrLabel];
		if (typeof idOrLabel=='string') {
			for (var i:String in _aInstances) if (Fuse(_aInstances[i]).label==idOrLabel) return _aInstances[i];
		}
		return null;
	}
	
	/**
	* Allows user to get all Fuse instances, or filter by state and/or targets. Searches by active targets (see getActiveTargets).
	* @param stateFilter		nothing or "ALL" for all Fuse instances, or get "playing", "stopped" or "paused" instances only
	* @param targets			nothing for all, a single target, an Array of targets, or a list of targets starting with the second param.
	* @see						#getActiveTargets
	*/
	public static function getInstances(stateFilter:String, targets:Object):Array
	{
		var all:Boolean = (stateFilter==null || (stateFilter.toUpperCase())=='ALL');
		if (!(targets instanceof Array)) targets = arguments.slice(1);
		var a:Array = [];
		for (var i:String in _aInstances) {
			var instance:Fuse = _aInstances[i];
			if (_aInstances[i]==null) continue;
			// if specified state does not match
			if (all==false && instance.state!=stateFilter) continue; 
			// yes: state matches and no targets to filter by
			var found:Boolean = (targets.length==0); 
			if (found==false) {
				// AS2 bug, break does not work twice!
				if (found==true) continue;
				var instTargs:Array = instance.getActiveTargets();
				for (var j:String in targets) {
					for (var k:String in instTargs) {
						// yes: a target passed in was found in the instance
						if (instTargs[k]==targets[j]) { 
							found = true;
							break;
						}
					}
				}
			}
			if (found==true) a.unshift(instance);
		}
		return a;
	}
	
	/**
	* Public id property - read only. A Fuse instance's numerical id (instance.id) which is auto-generated based on instance count.
	* @return Internal id based on instance count.
	*/
	public function get id():Number { return _nID; }	
	
	/**
	* State property - read only. A Fuse instance's current play state. 
	* @return "stopped", "playing", or "paused"
	*/
	public function get state():String { return _sState; }
	
	/**
	* Returns a 0-based play index.
	* @return public currentIndex property - read only. A Fuse instance's current play index.&nbps;(Starting with 0 for first item).
	*/ 
	public function get currentIndex():Number { return this._nIndex; } 
	
	/**
	* Returns the currently playing item's label if it has been defined.
	* @return Public currentLabel property - read only.&nbsp
	*/
	public function get currentLabel():String { return (FuseItem(this[_nIndex]).getLabel()); }
	
	/**
	* target property. 
	* @return a single animation target if one is set or an Array of targets if more than one is set.
	*/
	public function get target():Object { return (_aDefaultTargs.length==1) ? _aDefaultTargs[0] : _aDefaultTargs; }
	
	/**
	* Sets the instance's default animation targets. Accepts a single target or an Array of targets. Overwrites prior existing targets.
	* @param  Target property.
	*/
	public function set target(v:Object):Void {
		delete _aDefaultTargs;
		if (v!=null) {
			addTarget(v);
		}
	}
	
	/**
	* Adds to currently set default target. Use on a Fuse instance to freely manipulate the default target list.
	*/
	public function addTarget():Void
	{
		if (_aDefaultTargs==null) this._aDefaultTargs = [];
		if (arguments[0] instanceof Array) arguments = arguments[0];
		for (var i:String in arguments) {
			var found:Boolean = false;
			for (var j:String in _aDefaultTargs) {
				if (arguments[i]==_aDefaultTargs[j]) {
					found = true;
					break;
				}
			}
			if (found==false) _aDefaultTargs.push(arguments[i]);
		}
	}
	
	/**
	* One or more animation targets to remove from current targets
	*/
	public function removeTarget():Void
	{
		if (_aDefaultTargs==null || _aDefaultTargs.length==0) return;
		if (arguments[0] instanceof Array) arguments = arguments[0];
		for (var i:String in arguments) {
			for (var j:String in _aDefaultTargs) {
				if (arguments[i]==_aDefaultTargs[j]) _aDefaultTargs.splice(Number(j),1);
			}
		}
	}
	
	/**
	* Gets fuse instance's targets including in the action being played.
	* @return Array all default targets plus any additional targets currently being handled by the playing or paused action.
	*/
	public function getActiveTargets():Array
	{
		if (_sState!='playing' && _sState!='paused') return ([]);
		return ( FuseItem(this[_nIndex]).getActiveTargets(_aDefaultTargs.slice()) );
	}
	
	// ----------------------------------------------------------------------------------------------------
	//       Array-style Methods
	// ----------------------------------------------------------------------------------------------------
	
	/**
	* Returns a copy of Fuse as a new Fuse instance.
	* @return 	new Fuse instance with default settings and actions.
	*/
	public function clone():Fuse
	{
		var initObjs:Array = [];
		for (var i:Number=0; i<length; i++) {
			initObjs.push(FuseItem(this[i]).getInitObj());
		}
		var f:Fuse = new Fuse();
		f.push.apply(f,initObjs);
		f.scope = scope;
		f.target = target;
		return f;
	}
	
	/**
	* Pushes arguments into Fuse instance.
	* @return 	new length of Fuse instance
	*/
	public function push():Number
	{
		this.splice.apply(this, (new Array(length, 0)).concat(arguments));
		return length;
	}
	
	/**
	* Lets you add an item to the Fuse in ZigoEngine.doTween() syntax. Pushes tween arguments into Fuse instance and accepts the same arguments as ZigoEngine.doTween().
	* @param targets		tween target object or array of target objects
	* @param props			tween property or Array of properties
	* @param pEnd			tween end-value or Array of corresponding end-values
	* @param seconds		tween duration
	* @param ease			function, shortcut-string, or custom-easing-panel object
	* @param delay			seconds to wait before performing the tween
	* @param callback		function, string, or object
	* @return				new length of Fuse instance
	* @see #ZigoEngine.doTween
	*/
	public function pushTween(targets:Object, props:Object, pEnd:Object, seconds:Number, ease:Object, delay:Number, callback:Object):Number
	{
		this.push({__buildMode:true, tweenargs:arguments});
		return length;
	}
	
	/**
	* Removes last object placed into the Fuse instance.
	* @return	 	original object passed by user
	*/
	public function pop():Object 
	{
		var o:Object = FuseItem(this[length-1]).getInitObj();
		this.splice(length-1, 1);
		return o;
	}
	
	/**
	* Removes argument objects from Fuse instance.
	* @return 		new length of Fuse instance
	*/
	public function unshift():Number
	{
		this.splice.apply(this, ((new Array(0, 0)).concat(arguments)));
		return length;
	}
	
	/**
	* Shifts position of object in Fuse order.
	* @return 		original object passed by user
	*/
	public function shift():Object
	{
		var o:Object = FuseItem(this[0]).getInitObj();
		this.splice(0, 1);
		return o;
	}
	
	/**
	* Used to insert or remove items. Works almost exactly like Array.splice. Removed actions are destroyed permanently, with the exception of nested Fuses.
	* @param startIndex			index in Fuse to begin removing objects
	* @param deleteCount		number of objects to delete from startIndex
	*/
	public function splice(startIndex:Number, deleteCount:Number):Void
	{
		this.stop(true);
		var si:Number = Number(arguments.shift());
		if (si<0) si = length+si;
		deleteCount = Number(arguments.shift());
		var newItems:Array = new Array();
		for (var i:Number=0; i<arguments.length; i++) { 
			// convert new objs to FuseItems before splicing
			var item:Object = (arguments[i] instanceof Fuse) ? arguments[i] : new FuseItem((si+i), arguments[i], _nID);
			this.addEventListener('onStop', item);
			this.addEventListener('evtSetStart', item);
			newItems.push(item);
		}
		//deleteItems
		var deadItems:Array = (super.splice.apply(this, ((new Array(si,deleteCount)).concat(newItems))));
		for (var j:String in deadItems) {
			this.removeEventListener('onStop', deadItems[j]);
			this.removeEventListener('evtSetStart', deadItems[j]);
			if (deadItems[j] instanceof Fuse) {
				Fuse(deadItems[j]).removeEventListener('onComplete', _oDel1); // safety
				// does not destroy nested Fuse during removal
			}
			else { 
				// destroy item
				FuseItem(deadItems[j]).destroy();
				delete this[FuseItem(deadItems[j])._nItemID]; 
			}
		}
		// renumber items
		for (var i:Number=0; i<length; i++) {
			FuseItem(this[i])._nItemID = i;
		}
	}
	
	/**
	* Returns a new array instance consisting of a range of elements from the original array without modifying the original array. The array returned by this method includes the indexA element and all elements up to, but not including indexB element. If no parameters are passed, a duplicate of the original array is generated. For more information, see the Flash help explanation of Array.slice.
	* @param indexA:Number (optional)	A number specifying the index of the starting point for the slice. If start is negative, the starting point begins at the end of the array, where -1 is the last element.
	* @param indexB:Number (optional)	A number specifying the index of the ending point for the slice. If you omit this parameter, the slice includes all elements from the starting point to the last element of the array. If end is negative, the ending point is specified from the end of the array, where -1 is the last element.
	* @return		 					an array consisting of a range of elements from the original array.
	*/
	public function slice(indexA:Number, indexB:Number):Array
	{
		var a:Array = super.slice(indexA,indexB);
		var initObjs:Array = new Array();
		for (var i:Number=0; i<arguments.length; i++) {
			initObjs.push(FuseItem(this[i]).getInitObj());
		}
		return initObjs;
	}
	
	/**
	* Reverse the sequence of the Fuse
	*/
	public function reverse():Void
	{
		this.stop(true);
		super.reverse();
		// renumber
		for (var i:Number=0; i<length; i++) FuseItem(this[i])._nItemID = i;
	}
	
	/**
	* Traces specific or all objects contained within the fuse
	* @param indexA:Number (optional) A number specifying the index of the starting point for the slice. If start is negative, the starting point begins at the end of the array, where -1 is the last element.
	* @param indexB:Number (optional) - A number specifying the index of the ending point for the slice. If you omit this parameter, the slice includes all elements from the starting point to the last element of the array. If end is negative, the ending point is specified from the end of the array, where -1 is the last element.
	*/
	public function traceItems(indexA:Number, indexB:Number):Void
	{
		var s:String = '';
		var a:Array = super.slice(indexA,indexB);
		s+= ('-Fuse#'+String(_nID)+' traceItems:'+newline+'----------'+newline);
		for (var i:Number=0; i<a.length; i++) {
			if (a[i] instanceof Fuse){
				s+= ('-Fuse#'+String(_nID)+' #'+_nID+'>Item#'+i+': [Nested Fuse] '+a[i]);
			}else{
				s+= (a[i]);
			}
			s+=newline;
		}
		s+= ('----------');
		FuseKitCommon.output(s);
	}
	
	/**
	* @return a string representation of the fuse including its id, and label if defined.
	*/
	public function toString():String { return 'Fuse#'+String(_nID)+((label!=undefined)?(' "'+label+'"'):'')+' (contains '+length+' items)'; }
	
	
	// ----------------------------------------------------------------------------------------------------
	//       Play-Control Methods
	// ----------------------------------------------------------------------------------------------------
	
	/**
	* Presets start-properties like start_x in all or specific items. 
	* @param For all pass nothing or true. To specify items pass an array of item indices/labels or a series of indices/labels as separate parameters.
	*/
	public function setStartProps(trueOrItemIDs:Object):Void
	{
		var all:Boolean = (arguments.length==0 || trueOrItemIDs===true);
		dispatchEvent({target:this, 
					   type:'evtSetStart',
					   all:all,
					   filter:(trueOrItemIDs instanceof Array) ? trueOrItemIDs : arguments,
					   curIndex:((state=='playing') ? _nIndex : -1),
					   targs:_aDefaultTargs,
					   scope:scope});
	}
	
	/**
	* Begins sequence play at index 0, with option to set start props prior to play.
	* @param 	setStart	Any arguments passed to start() are passed to an automated setStartProps() call before Fuse begins playing.
	*/
	public function start(setStart:Object):Void
	{
		close();
		this.stop(true);
		this._sState = 'playing';
		if (length==0) {
			advance(false,true); // fires onComplete, state must be playing
		}
		if (setStart!=null && setStart!=false){
			setStartProps.apply(this,arguments);
		}
		dispatchEvent({target:this, type:'onStart'});
		if (OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+'  start.');
		playCurrentItem();
	}
	
	/**
	* Stops a playing or paused Fuse instance and resets the play-index to 0.
	*/
	public function stop():Void
	{
		if(_sState!='stopped') { 
			for (var i:Number=0; i<length; i++) {
				// stop all triggered items to kill trailing tweens.
				if (i==_nIndex || (FuseItem(this[i]).hasTriggerFired())==true) FuseItem(this[i]).stop();
			}
		}
		else {
			// prevents dispatch if stop called while stopped.
			arguments[0] = true; 
		}
		if ((this[_nIndex]) instanceof Fuse) {
			Fuse(this[_nIndex]).removeEventListener('onComplete', _oDel1);
		}
		this._sState = 'stopped';
		// arg true internal only, don't broadcast stop if stopped.
		if (!(arguments[0]===true && this._sState=='stopped')) { 
			dispatchEvent({target:this, type:'onStop'});
			if (OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+'  stop.');
		}
		_nIndex = 0;
		clearInterval(_nDelay);
		_nTimeCache = _nDelay = -1;
	}
	
	/**
	* Starts Fuse at a particular index (and stops current item if playing).
	* @param indexOrLabel		numerical item index or label string. Pass a negative index to count back from end, like -1 for last item.
	*/
	public function skipTo(indexOrLabel:Object):Void
	{
		close();
		var index:Number;
		// label 
		if (typeof indexOrLabel=='string') { 
			index = -1;
			for (var i:Number=0; i<length; i++) {
				if ((FuseItem(this[i]).getLabel())==String(indexOrLabel)) {
					index = i;
					break;
				}
			}
			if (index==-1) {
				if (OUTPUT_LEVEL>0) FuseKitCommon.error('102',String(indexOrLabel));
			}
		}
		else {
			index = Number(indexOrLabel);
		}
		if (_global.isNaN(index)==true || Math.abs(index)>=length) {
			// changed this from triggering onComplete to just failing, it's a mistake and should not work.
			if (OUTPUT_LEVEL>0) FuseKitCommon.error('103',String(indexOrLabel));
		}
		if (index<0) index = Math.max(0, length + index);
		// hidden second arg passed by FuseItem
		if (index==_nIndex && arguments[1]===true) { 
			if (OUTPUT_LEVEL>0) FuseKitCommon.error('104',String(indexOrLabel),_nIndex);
		}
		if ((this[_nIndex]) instanceof Fuse) {
			Fuse(this[_nIndex]).removeEventListener('onComplete', _oDel1);
		}
		// (Item will be replayed if skipTo called on current item)
		FuseItem(this[_nIndex]).stop(); 
		_nIndex = index;
		var s:String = _sState;
		this._sState = 'playing';
		// skipTo is being used to start the Fuse
		if (s=='stopped') dispatchEvent({target:this, type:'onStart'}); 
		playCurrentItem();
		if (OUTPUT_LEVEL>1) FuseKitCommon.output('skipTo:'+index);
	}
	
	/**
	* Pauses a playing Fuse instance including pausing tweens in the current item, waits for resume method call to proceed.
	*/
	public function pause():Void
	{
		if(_sState=='playing'){
			FuseItem(this[_nIndex]).pause();
			if (_nTimeCache!=-1) {
				// remaining time in delay
				_nTimeCache -= getTimer(); 
				clearInterval(_nDelay);
			}
			this._sState = 'paused';
			if (OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+'  pause.');
			dispatchEvent({target:this, type:'onPause'});
		}
	}
	
	/**
	* Resumes a paused Fuse instance and its animations. Attempts to correct for animations that have been disrupted during pause.
	*/
	public function resume():Void
	{
		if (_sState!='paused') return; // Behavior change from 1.0: only accept resume calls if paused!
		close();
		this._sState = 'playing';
		if (OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+'  resume.');
		dispatchEvent({target:this, type:'onResume'});
		if (_nTimeCache!=-1) {
			clearInterval(_nDelay);
			this._nTimeCache = getTimer()+_nTimeCache;
			this._nDelay = setInterval(Delegate.create(this, playCurrentItem), _nTimeCache, true);
		}
		// resume
		FuseItem(this[_nIndex]).pause(true); 
	}
	
	// ----------------------------------------------------------------------------------------------------
	//       Private Methods
	// ----------------------------------------------------------------------------------------------------
	
	/**
	* Internal handler called by items on completion.
	* @param wasTriggered 	is sent true when an item advanced prematurely using the trigger property completes and is used to track the final completion of a Fuse in which animations trail beyond the sequence end.
	* @param silentStop 	used in <code>Fuse.start</code> when start is called on a 0-item Fuse so that only the <code>onComplete</code> event gets fired.
	*/
	private function advance(wasTriggered:Boolean,silentStop:Boolean):Void
	{
		var isLastFinal:Boolean = false;
		if (_nIndex==length-1) {
			for (var i:Number=length-1; i>-1; i--) {
				if (FuseItem(this[i])._nPlaying>-1) {
					return; // an overlapping item (one containing a trigger) is not finished playing.
				}
			}
			isLastFinal = true;
		}
		if (wasTriggered==true && isLastFinal==false) { // wasTriggered calls are sent only for the above check. 
			return;
		}

		if ((this[_nIndex]) instanceof Fuse) {
			Fuse(this[_nIndex]).removeEventListener('onComplete', _oDel1);
		}
		if (++_nIndex>=length) {
			this.stop(silentStop);
			if (Fuse.OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+' complete.');
			dispatchEvent({target:this, type:'onComplete'});
			if (autoClear==true || (autoClear!==false && AUTOCLEAR==true)) destroy();
			return;
		}
		if (Fuse.OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID) + ' advance: '+_nIndex);
		dispatchEvent({target:this, type:'onAdvance'});
		playCurrentItem();
	}
	
	/**
	* Internal helper that triggers <code>startItem()</code> in currently active item.
	* @param postDelay		true is sent when a delay has completed.
	*/
	private function playCurrentItem(postDelay:Boolean):Void
	{
		clearInterval(_nDelay);
		if (postDelay!==true) {
			var d:Number = (FuseItem(this[_nIndex]).evalDelay(scope) || 0);
			//if (_nIndex==0 && d==0) d = .01;// super-tiny delay at Fuse start fixes a number of glitches.
			if (d>0) {
				this._nTimeCache = getTimer()+(d*1000);//used during pause.
				this._nDelay = setInterval(Delegate.create(this, playCurrentItem), d*1000, true);
				return;
			}
		}
		_nTimeCache = _nDelay = -1;
		if ((this[_nIndex]) instanceof Fuse) {
			if (_oDel1==null) _oDel1 = Delegate.create(this,advance);
			Fuse(this[_nIndex]).addEventListener('onComplete', _oDel1);
		}
		var propsTweened:String = (FuseItem(this[_nIndex]).startItem(_aDefaultTargs, scope));
		if (Fuse.OUTPUT_LEVEL>1) FuseKitCommon.output('-Fuse#'+String(_nID)+' props tweened: '+propsTweened);
	}
	
	/**
	* Internal event used when the fuse is nested in a parent fuse. (Polymorphism - this is a FuseItem method that only appears in Fuse for the nested instance case).
	*/
	private function evtSetStart(o:Object):Void
	{
		setStartProps.apply(this, o.filter);
	}
	
	/**
	* FuseItem method used by a Fuse only when the it is nested in a parent Fuse.
	* @param targs
	* @param scope
	*/
	public function startItem(targs:Array, scope:Object):Void
	{
		// adopt scope and targs from parent if none set. This is really rough, 
		// ultimately it ought to be written to cache the original values then restore.
		if (target==null) target = targs; 
		if (scope==null) scope = scope;
		this.start();
	}
	
	// ----------------------------------------------------------------------------------------------------
	//  +++ BUILD MODE +++ (simple syntax)
	// ----------------------------------------------------------------------------------------------------
	
	/**
	* Simple Syntax method that triggers the class to begin intercepting tween calls until Fuse.close is called.
	* If you mostly use simple syntax it's recommended that you set Fuse.AUTOCLEAR = true; so fuses delete themselves after playing once.
	* @param fuseOrID	(Optional) Pass an existing Fuse, or its id or label to reopen it.
	* @return 			The opened Fuse instance that tween calls will be routed to until close() is called.
	*/
	public static function open(fuseOrID:Object):Fuse // returns Fuse instance added to until Fuse.close() is called.
	{
		var _ZigoEngine:Function = _global.com.mosesSupposes.fuse.ZigoEngine;
		if (_ZigoEngine==undefined) {
			FuseKitCommon.error('106');
			return null;
		}
		else {
			(_ZigoEngine).register(Fuse, FuseItem);
		}
		if (_oBuildMode==null) {
			_oBuildMode = {
				curID:-1,
				prevID:-1,
				curGroup:null
			};
		}
		else if (_oBuildMode!=null && _oBuildMode.curID>-1) {
			close();
		}
		if (fuseOrID!=null) {
			if (fuseOrID instanceof Fuse) {
				_oBuildMode.curID = fuseOrID.id;
			}
			else if (getInstance(fuseOrID)!=null) {
				_oBuildMode.curID = getInstance(fuseOrID).id;
			}
			else {
				FuseKitCommon.error('107');
				return null;
			}
		}
		else {
			_oBuildMode.curID = (new Fuse()).id;
		}
		_oBuildMode.prevID = _oBuildMode.curID;
		return getInstance(_oBuildMode.curID);
	}
	
	/**
	* Simple Syntax method that begins a new animation group (array of simultaneous actions).<br>If <code>Fuse.openGroup()</code> is called before Fuse.open(), a new Fuse is automatically opened. If <code>Fuse.openGroup()</code> is called while a previous group was open, the preceding group is closed automatically.
	* @param fuseOrID:Fuse		(Optional) an existing Fuse or Fuse's id or label in which to open the new group.
	* @return					The currently open fuse instance or a new Fuse if openGroup was called prior to open().
	*/
	public static function openGroup(fuseOrID:Object):Fuse
	{
		// allow openGroup() to open a new sequence.
		if (!(_oBuildMode!=null && _oBuildMode.curID>-1)) open(fuseOrID); 
		else if (_oBuildMode.curGroup!=null) closeGroup();
		_oBuildMode.curGroup = new Array();
		return getInstance(_oBuildMode.curID);
	}
	
	/**
	* Simple Syntax method that closes a group started by <code>Fuse.openGroup().</code>  Fuse resumes accepting regular element format.
	*/
	public static function closeGroup():Void
	{
		if (_oBuildMode.curGroup==null || !(_oBuildMode!=null && _oBuildMode.curID>-1)) return;
		getInstance(_oBuildMode.curID).push(_oBuildMode.curGroup);
		_oBuildMode.curGroup = null;
	}
	
	/**
	* Simple Syntax method that closes the Fuse sequence definitions. <code>Fuse.close()</code> must be called before <code>Fuse.start()</code> can be called.
	*/
	public static function close():Void
	{
		if (!(_oBuildMode!=null && _oBuildMode.curID>-1)) return;
		if (_oBuildMode.curGroup!=null) closeGroup();
		_oBuildMode.curID = -1;
	}
	
	/**
	* Simple Syntax method that can be called in place of <code>Fuse.close()</code> to both close and start the Fuse playing.
	*/
	public static function closeAndStart(setStart:Object):Void
	{
		if (!(_oBuildMode!=null && _oBuildMode.curID>-1)) return;
		var f:Fuse = getInstance(_oBuildMode.curID);
		close();
		f.start.apply(f, arguments);
	}
	
	/**
	* Simple Syntax method that restarts the Fuse most recently created using <code>Fuse.open()</code>.
	*/
	public static function startRecent(setStart:Object):Void
	{
		var f:Fuse = getInstance(_oBuildMode.prevID);
		if (f!=null) f.start.apply(f, arguments);
		else FuseKitCommon.error('108');
	}
	
	/**
	* Simple Syntax method that inserts an inline Fuse command, delay, or function-call into the sequence.
	* @param commandOrScope		may be: 'delay','start','stop','pause','resume','skipTo','setStartProps' or in the case of a function-call a scope such as this.
	* @param indexOrFunc		'delay':number of seconds. 'skipTo':destination index/label. For function-call, a string of the function name such as 'trace'
	* @param argument			for function-call, any number of arguments can follow and will be passed to the function when it's called.
	*/
	public static function addCommand(commandOrScope:Object, indexOrFunc:Object, argument:Object):Void
	{
		if (!(_oBuildMode!=null && _oBuildMode.curID>-1)) return;
		var into:Array = (_oBuildMode.curGroup!=null) ? _oBuildMode.curGroup : getInstance(_oBuildMode.curID); // New feature: allow addCommand within groups
		if (typeof commandOrScope=='string') { // assume it's a command
			if (_oBuildMode.curGroup!=null && commandOrScope!='delay') {
				FuseKitCommon.error('109',String(commandOrScope));
				return;
			}
			var validCommands:String = '|delay|start|stop|pause|resume|skipTo|setStartProps|'; // "delay" command is specific to simple syntax
			if (validCommands.indexOf('|'+commandOrScope+'|')==-1 || ((commandOrScope=='skipTo' || commandOrScope=='delay') && indexOrFunc==undefined)) {
				if (OUTPUT_LEVEL>0) FuseKitCommon.error('110',String(commandOrScope));
			}
			else {
				into.push({__buildMode:true, command:commandOrScope, commandargs:indexOrFunc});
			}
		}
		else { 
			// assume it's a function-call
			into.push({__buildMode:true, scope:commandOrScope, func:indexOrFunc, args:arguments.slice(2)});
		}
	}
	
	/**
	* Internal use only. This is the method ZigoEngine uses to route tween calls into an open Fuse instance after <code>Fuse.open()</code>.
	* @return		true if Fuse is in build-mode
	*/
	public static function addBuildItem(args:Array):Boolean
	{
		if (!(_oBuildMode!=null && _oBuildMode.curID>-1)) return false;
		var into:Array = (_oBuildMode.curGroup!=null) ? _oBuildMode.curGroup : getInstance(_oBuildMode.curID);
		if (args.length==1 && typeof args[0]=='object') {
			// Object syntax can be mixed with simple syntax by using Fuse.open(); with commands like my_mc.tween({x:'100'});
			into.push(args[0]);
		}
		else {
			into.push({__buildMode:true, tweenargs:args});
		}
		return true;
	}
	
	/**
	* Internal, used to add a Fuse instance to the _aInstances array.
	* @param 	Fuse instance
	* @return 	internal index used as Fuse's id
	*/
	private static function registerInstance(s:Fuse):Number
	{
		if(_aInstances==null) _aInstances = new Array();
		return _aInstances.push(s)-1;
	}
	
	/**
	* Interal, used to remove a Fuse instance from the _aInstances array.
	* @param id
	* @param isDestroyCall
	*/
	private static function removeInstanceAt(id:Number, isDestroyCall:Boolean):Void
	{
		if (isDestroyCall!=true) {
			Fuse(_aInstances[id]).destroy();
		}
		delete _aInstances[id];
	}
}
