package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
import openfl.Lib;

using StringTools;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Characters';
		rpcTitle = 'Characters Extras Menu'; //for Discord Rich Presence

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Proto Girl Friend', //Name
			'If checked, it toggles between Final gf or proto gf', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Xmas Pico on week 5', //Name
			'Toggle between bf xmas or pico xmas.', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Old Bf icon', //Name
			'If checked Toggles between current bf icon or the yellow one', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
}