## Digital Storage

This mod for [Minetest](https://www.minetest.net/) adds in persistent storage accessible with [Digilines](https://github.com/minetest-mods/digilines).

### Example Usage

1. Place down a `digital_storage:floppy_drive` node.
2. Insert a `digital_storage:floppy_disk` item into the drive.
3. Connect the drive to a LuaController with digiline wires

To store something in the disk:

```
digiline_send("floppy_channel_name", { op = "put", addr = "key", data = "value" });
```

To retrieve something from the disk:

```
digiline_send("floppy_channel_name", { op = "get", addr = "key" });
```

This will send back a message on the same channel with the data. No message will be sent if there was no data.

To delete something from the disk:

```
digiline_send("floppy_channel_name", { op = "del", addr = "key" });
```