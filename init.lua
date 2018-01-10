local root = minetest.get_modpath("digital_storage");
dofile(root .. "/scripts/require.lua")(root);

require("scripts/floppy.lua").register();