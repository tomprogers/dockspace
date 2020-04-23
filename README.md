# dockspace

A MacOS tool that creates custom shortcuts for all your VS Code workspaces.

```sh
$ dockspace workspaces_directory svg_icon shortcuts_directory
```

## How to get it

1. Download the `dockspace.sh` script from this repo, and mark it executable.

```sh
# download & rename from "dockspace.sh" to "dockspace"
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomprogers/dockspace/master/src/shell.sh > ~/scripts/dockspace)"
# make it executable
$ chmod ugo+x ~/scripts/dockspace
```

2. Install dependencies

dockspace uses about a dozen CLI tools, some of which are exclusive to MacOS. Two are not standard, but can be installed using homebrew:
- `jq` : used to parse workspace files
- `librsvg` : used to convert SVGs into rasters

```sh
$ brew install jq librsvg
```

For the curious: the Mac-specific tools are all related to setting file icons, which are stored in Mac's resource fork. The main ones are `DeRez`, `Rez`, `SetFile`, and `sips`.


## How to use it

dockspace works best if you keep all your `.code-workspace` files in a single directory. If you don't, you can either run it once for each workspace, or put all those files together (which will require hand-editing the paths inside them).

You also need to provide it with an icon, in SVG format. (Future versions will support other image formats.) See below for details about optional ways to customize the SVG.

Finally, you have to create the directory where the shortcuts will go. Future versions of dockspace will create the folder if necessary.

Once everything is prepared, run dockspace:

```sh
$ dockspace workspaces_directory svg_icon shortcuts_directory
```

Where:
- `workspaces_directory` is the path to a directory that contains one or more `.code-workspace` files
- `svg_icon` is the path to the SVG file to use as the shortcut icon
- `shortcuts_directory` is the path to the diretory where the shortcut should be created


#### An example

On my machine:
- I've been keeping all my `.code-workspace` files in a single folder, at `~/projects/.vscode-workspaces`
- I created a custom SVG for my shortcuts, and that file is on my desktop at `~/Desktop/workspace-icon.svg`
- I created a new folder to hold the shortcuts, at `~/projects/.shortcuts`

So I ran this:

```sh
dockspace ~/projects/.vscode-workspaces ~/Desktop/workspace-icon.svg ~/projects/.shortcuts
```

### Dock configuration

dockspace doesn't add the shortcuts to the MacOS Dock automatically. (Future versions might.) So, this step is still manual.

1. Open Finder, and drag your folder of shortcuts onto the Dock. You can do this before or after running dockspace.
2. I think the Dock folder looks best as a single icon rather than a stack:
    - Right-click on it in the Dock, and choose "Folder" in the "Display As" section.
    - I also recommend sorting by Name so that the location of each item in the list is stable over time.
3. You can change the icon of the Dock folder, too:
    1. I recommend doing this *after* adding the folder has been added to the dock, otherwise the custom icon appears in the directory listing.
    1. Use Preview to open an image you want to use as the icon.
        - The image must be a raster graphic (i.e. *not* an SVG). Although, you *did* just install `librsvg`, which converts SVGs to rasters. (See below for instructions.)
        - Don't use the spacebar, which opens using QuickLook. Instead, double-click the image, or right-click and Open With > Preview.app
    2. In Preview, copy the entire image content by pressing `Cmd+A`, `Cmd+C`
    3. In Finder (i.e. *not* the Dock), use "Get Info" on your shortcuts folder (`Cmd+I`, or right-click and "Get Info").
    4. In the info panel that appears, click on the icon in the upper-left corner, then _paste_ the copied image by pressing `Cmd+V`.


### Customizing the workspace icon
