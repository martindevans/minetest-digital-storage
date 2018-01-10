local function n(name)
    name = "digital_storage:" .. name;
    return function()
        return name;
    end
end

return {
    floppy_drive = n("floppy_drive"),

    floppy_disk = n("floppy_disk")
};