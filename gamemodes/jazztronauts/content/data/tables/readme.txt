This is a dumping ground for various extracted tables and variables that were previously hardcoded.
Eventually, I'd like for these to be copied into garrysmod/data/jazztronauts/cfg on the first boot and then loaded from there
so that other addons or the player/server operator can modify them as they see fit.
Warning: Change these values at your own risk, Jazztronauts will probably crash if you put something dumb in one of these files.

Documentation:

mapNames.json:

IntroMap: The map used for the intro cutscene.
EncounterMap: The map used for the Silent Hill scenes in NG+
EndMaps: The map used for the normal and NG+ endings, in that order.
HubMap: The map the trolley returns to.

missionTable.json:

This is currently unused, as I haven't figured out how to fully extract the datastructure. I'm working on it though.

npcTable.json:
IMPORTANT NOTICE: The order of the entries in here matters. THINGS WILL BREAK if you move the default NPC entries around.
Add any custom NPC entries after NPC_CAT_ASH.
That being said, here's the fields for when you want to add your own NPC entry.

script_name: Name used in internal code and the mission list. This is also used to refer to them in dialogue scripts.
but in lowercase and with the 'npc_' part trimmed off.

localization_name: JazzLocalize key for the NPC's name. This is looked up and loaded from
jazztronauts/resource/localization/[lang]/jazztonauts.properties
where [lang] is an IETF language tag. For example, `en` for English and `en-PT` for Pirate English
The Player will then see the NPC's name translated into their language.

model: Path from gameinfo.txt to the model used for the NPC. For best results with dialogue scripts, this should include the same
named sequences as the default models, and the same order of skinfamilies facial expressions. I believe the code should be able
to handle both the custom Jazztronauts skeleton and the standard ValveBiped skeleton. Milage may vary however.