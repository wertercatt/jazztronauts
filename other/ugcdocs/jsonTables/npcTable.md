# npcTable.json

## Important Notice

The order of the entries in here matters. THINGS WILL BREAK if you move the default NPC entries around.  
Add any custom NPC entries after `NPC_CAT_ASH`.

## Table Variables

* `script_name` Name used in internal code and the mission list. This is also used to refer to them in dialogue scripts but in lowercase and with the 'npc_' part trimmed off.
* `localization_name` JazzLocalize key for the NPC's name. This is looked up and loaded from [jazztronauts.properties](../propertiesFile.md) so players can see the NPC's name translated into their language.
* `model` Path from gameinfo.txt to the model used for the NPC. For best results with dialogue scripts, this should include the same named sequences as the default models, and the same order of skinfamilies facial expressions. I believe the code should be able to handle both the custom Jazztronauts skeleton and the standard ValveBiped skeleton. Use other skeletons at your own risk.

## Special Considerations

As one of the most complex parts of Jazztronauts, NPCs need some extra care to work properly.

### Idle Dialogue

Hardcoded within the [jazz_cat entity](../mapping/entities/jazz_cat.md) is the behavior for loading the NPC's Idle Dialogue.  
When an NPC is interacted with who doesn't have a mission or an event for a player, the code will automatically look in the dialogue script `idle.txt` for something to say.  
It will load a marker starting with `begin` followed by the NPC's place in the table. Note that `NPC_CAT_BAR` is the first place in the table, not the zeroth.

As an example, let's say you've added an new NPC, `NPC_NED` by inserting this block of JSON after `NPC_CAT_ASH` in the default npcTable.json file:

```json
    {    
        "script_name": "NPC_NED",
        "localization_name": "jazz.custom.nedmod.npcs.ned",
        "model": "models/police.mdl"
    }
```

Now, let's count the NPC entries.  

1. `NPC_CAT_BAR`
2. `NPC_CAT_SING`
3. `NPC_CAT_PIANO`
4. `NPC_CAT_CELLO`
5. `NPC_NARRATOR`
6. `NPC_BAR`
7. `NPC_CAT_VOID`
8. `NPC_CAT_ASH`
9. `NPC_NED`

`NPC_NED` is the ninth entry, so the game will try to load the dialogue marker `begin9` from `idle.txt` as the idle dialogue.  
If it can't find it, it will load the dialogue marker `begin` from `idle.txt` which contains the following placeholder dialogue:  

```
    Hi, I have no idle scripts%%
    and yet I'm speaking.%%
    Please do not call the police.
    &exit
```

### Mission/Event Dialogue

_Jazztronauts_ will automatically load NPC dialogue for Missions defined in the [missionTable](missionTable.md)  
Note that Missions and Events are zero-indexed, so the first Mission for `NPC_CAT_CELLO` is defined as his zeroth Mission.  
All defined Missions must have an accompanying Event. They will have the same ID.
The filename for the dialogue script must start with the full `script_name` for your NPC.  
You must then add `.mission` or `.event` respectively to the filename.  
Finally, add the ID you've defined as an integer and the `.txt` extension.  

As an example, the first Mission for `NPC_CAT_CELLO` uses the dialogue file `npc_cat_cello.mission0.txt`  
It automatically has a corresponding Event registered which will use the dialogue file `npc_cat_cello.event0.txt`

### Spawning

The `HubMap` defined in your [mapNames](mapNames.md) must have a [jazz_cat entity](../mapping/entities/jazz_cat.md) set to spawn your NPC.  
If there isn't one, your NPC will not appear in game.
