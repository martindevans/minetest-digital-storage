local names = require("scripts/names.lua");

local function register_disk()

    minetest.register_craftitem(names.floppy_disk(), {
        description = "Floppy Disk",
        inventory_image = "digital_storage_floppy.png",
        stack_max = 1
    });

    minetest.register_craft({
        output = names.floppy_disk(),
        recipe = {
            { "",               "default:paper",            "" },
            { "default:paper",  "default:mese_crystal",     "default:paper" },
            { "",               "default:paper",            "" },
        }
    });
end

local function on_digiline_receive(pos, node, channel, msg)
    local node_meta = minetest.get_meta(pos);

    --Exit asap if this message is not for us!
    local mychannel = node_meta:get_string("channel");
    if channel ~= mychannel then return; end

    local node_inv = node_meta:get_inventory();
    local disk_stack = node_inv:get_stack("disk", 1);

    --Exit if there's no disk in the drive!
    if not disk_stack or disk_stack:is_empty() then return; end

    local stack_meta = disk_stack:get_meta();

    --Sanity check the message has the right parts
    if not msg.op or type(msg.op) ~= "string" then return; end
    if not msg.addr or type(msg.op) ~= "string" then return; end

    local key = "data:" .. msg.addr;
    if msg.op == "get" then
        local data = stack_meta:get_string(key);
        digiline:receptor_send(pos, digiline.rules.default, channel, data);
    elseif msg.op == "put" then
        if not msg.data or type(msg.op) ~= "string" then return; end
        stack_meta:set_string(key, msg.data);
        node_inv:set_stack("disk", 1, disk_stack);
    elseif msg.op == "del" then
        stack_meta:set_string(key, nil);
        node_inv:set_stack("disk", 1, disk_stack);
    end
end

local function only_allow_floppy_disk_put(pos, listname, index, stack, player)
    if stack:get_name() == names.floppy_disk() then
        return 1;
    else
        return 0;
    end
end

local function on_construct(pos)
    local node = minetest.get_meta(pos);

    local inv = node:get_inventory();
    inv:set_size("disk", 1);

    node:set_string("formspec", "field[channel;Channel;${channel}]")
end

local function on_receive_fields (pos, formname, fields, sender)
    if fields.channel then
        local node = minetest.get_meta(pos);
        node:set_string("channel", fields.channel);
        node:set_string("formspec", "invsize[8,6;]list[context;disk;0,0;1,1;]list[current_player;main;0,1;8,5;]");
    end
end

local function register_drive()
    minetest.register_node(names.floppy_drive(), {
        tiles = {
            "digital_storage_floppy_drive_top.png",
            "digital_storage_floppy_drive_bot.png",
            "digital_storage_floppy_drive_side.png",
            "digital_storage_floppy_drive_side.png",
            "digital_storage_floppy_drive_side.png",
            "digital_storage_floppy_drive_front.png"
        },
        groups = { dig_immediate = 2 },

        on_construct = on_construct,
        allow_node_data_inventory_put = only_allow_floppy_disk_put,
        on_receive_fields = on_receive_fields,
        digiline = {
            receptor = {},
            effector = {
                action = on_digiline_receive
            }
        }
    });
    
    minetest.register_craft({
        output = names.floppy_drive(),
        recipe = {
            { "default:stone",  "default:stone",        "default:stone" },
            { "default:stone",  "default:mese_crystal", "default:stone" },
            { "default:stone",  "default:stone",        "default:stone" },
        }
    });
end

return {
    register = function()
        register_drive();
        register_disk();
    end
}