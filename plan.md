// STEP 1: ensure every workspace has peacock settings:

json.settings["peacock.color"]

// if not, warn & use black


// STEP 2: for those that do, set icon
1. write svg with peacock color as fill
2. generate png
	svgexport as node module
3. do these steps
	# Take an image and make the image its own icon:
	sips -i icon.png

	# Extract the icon to its own resource file:
	/Developer/Tools/DeRez -only icns icon.png > tmpicns.rsrc

	# append this resource to the file you want to icon-ize.
	/Developer/Tools/Rez -append tmpicns.rsrc -o file.ext

	# Use the resource to set the icon.
	/Developer/Tools/SetFile -a C file.ext
4. create symlink in dock directory that points to workspace file
	ln -sfn source target
