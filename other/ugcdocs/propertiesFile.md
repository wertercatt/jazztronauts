# jazztronauts.properties

Lines starting with `#` are comments to help you understand what a group of keys is used for.
Every entry in this file is a JazzLocalize key, followed by an equals sign. Each word in the key's name must be seperated by periods. Keys are grouped based on their words, left to right.  
Key names must consist only of lower case English letters and periods. Their localized text can be any UTF-8 string though.
Do not give duplicate entries the same name.  
After the equals sign is the localized text for that language.  
To add a new key, just add a new entry at the bottom of the file. I would recommend prefixing your keys with `jazz.custom.` and then an identifier for your mod.  
Continuing from the example NPC mod described in [the npcTable.json page](jsonTables/npcTable.md), you could add a grouping at the end like this for the NPC's English name:

```properties
#==============================================================================
#	Example NPC Ned mod by wertercatt
#==============================================================================
jazz.custom.nedmod.npcs.ned=Ned
```
