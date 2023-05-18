# So You Wanna Make Custom Jazztronauts Content?

Then you've come to the right place! This is a stash of documentation on how to do that, created as I (wertercatt) work on my UGC Refactoring project.

_Jazztronauts_ has currently a lot of hardcoded data tables and spaghetti code, which makes it hard to add your custom things.  
This branch is still a heavy work in progress though, so I can't guarantee that mods targetting this WIP state will be forward-compatible when the refactoring process is finished.

Please use this file as an index to help you find what you're looking for.

## JSON Tables

The JSON tables are located in `gamemodes/jazztronauts/content/data/tables/` and were previously hardcoded Lua tables within Jazztronauts' code.  
Due to their previously hardcoded state, your mileage may vary when modifying the default values. Feel free to report any issues you encounter so they can be documented and potentially fixed if the behavior is reasonable.

* [mapNames.json](jsonTables/mapNames.md)
* [npcTable.json](jsonTables/npcTable.md)
* [missionTable.json](jsonTables/missionTable.md)

## Language Dependent Files

Some paths to files have IETF language tags like `en` for English or `en-PT` for Pirate English embedded in them.  
I will use the placeholder `[lang]` to stand in for these.  
Note that _Jazztronauts_ will use the English language tag `en` as a fallback when it can't find a version for the player's specific language.  
As such, make sure to support that language as a minimum.

### jazztronauts.properties

Localized versions of text strings that aren't part of a dialogue script are stored in a file with the Java Properties format.  
It is located at `resource/localization/[lang]/jazztronauts.properties`

For more information, see its [dedicated page](propertiesFile.md)
