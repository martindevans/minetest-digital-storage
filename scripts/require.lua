return function(root)
    local loaded_index = {};

    _G.require = function(path)
        local loaded = loaded_index[path];
        if loaded ~= nil then
            return loaded;
        end

        loaded = dofile(root .. "/" .. path);

        --Save whatever we found
        if loaded then
            loaded_index[path] = loaded;
        end

        return loaded;
    end
end