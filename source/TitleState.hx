package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import lime.app.Application;
import openfl.Assets;

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	static var initialized:Bool = false;
	var mustUpdate:Bool = false;
	public static var updateVersion:String = '';

	override public function create():Void
	{
		super.create();

		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 2, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(0, 0, FlxG.width, FlxG.height));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 1.3, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));

			initialized = true;

			#if CHECK_FOR_UPDATES
			if(ClientPrefs.checkForUpdates && !closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}
		#end

			FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
			FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};
		}

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stageback'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.updateHitbox();
		add(bg);

		var logoBl:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logoBl.screenCenter();
		logoBl.color = FlxColor.BLACK;
		add(logoBl);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		add(logo);

		FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		FlxG.sound.playMusic(Paths.music('title'), 0);

		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER && !transitioning)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);

			transitioning = true;
			FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
			});
			FlxG.sound.playMusic(Paths.music('titleShoot'), 0.7);
		}

		super.update(elapsed);
	}
}
