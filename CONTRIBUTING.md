# To contribute

**If you are working on an existing issue, please claim it with your comment, so there is no duplicate work.**

## What you will need before you begin:
1. [VSCode](https://code.visualstudio.com/)
2. Clone/Download the repository.
3. VSCode [Lua Extension](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
4. VSCode [Factorio Mod Extension](https://marketplace.visualstudio.com/items?itemName=justarandomgeek.factoriomod-debug)
6. Add your factorio location to the [factorio.versions setting](.vscode/settings.json)
7. Click the Factorio version selection in the vscode status bar to generate factorio EmmyLua docs in the .vscode folder that will give you autocomplete/intellisense information
8. See more info on the [Factorio Mod Extension Workspace docs](https://github.com/justarandomgeek/vscode-factoriomod-debug/blob/HEAD/doc/workspace.md)
9. If you have not cloned the code into the factorio mods folder, you can use the [sync script](./tools/copy-local.sh) to copy the src contents into a new mod folder in the `%appdata%/Factorio/mods/` folder


## Hidden Files in VSCode
Some files are hidden in vscode by default, see the `files.exclude` option in the [settings file](.vscode/settings.json)

There is a [recommended extension](.vscode/extensions.json) `adrianwilczynski.toggle-hidden` that allows to easily toggle hidden files on and off


## Dev
* The main code is in the [src](./src/) folder
* See the [src/README.md](./src/README.md) details
* You can run the [copy-local.sh](./tools/copy-local.sh) script to sync to factorio folder
* See [common console commands](https://wiki.factorio.com/Console)
* A list of existing style can be found in `Factorio/data/core/prototypes/style.lua`


### References
* [Factorio API](http://lua-api.factorio.com/latest/)
* [Factorio Wiki - Multiplayer](https://wiki.factorio.com/Multiplayer)
* [Factorio Wiki - Console](https://wiki.factorio.com/Console)
* [Factorio Wiki - Research](https://wiki.factorio.com/Research)
* [Factorio RElms - Console Commands](https://factorio-realms.com/tutorials/useful_factorio_console_commands)
* [Afforess/Factorio-Stdlib](https://github.com/Afforess/Factorio-Stdlib)
* [Afforess/Factorio-Stdlib Doc](http://afforess.github.io/Factorio-Stdlib/index.html)
* [3RaGaming/3Ra-Enhanced-Vanilla](https://github.com/3RaGaming/3Ra-Enhanced-Vanilla)
* [RedMew](https://github.com/Refactorio/RedMew)
* [Lua Doc](https://www.lua.org/manual/5.3/)
* [Lua tutspoint](https://www.tutorialspoint.com/lua/index.htm)
