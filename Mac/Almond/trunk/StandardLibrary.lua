plugin = {
        description = "Default plugin",
        copyright = "Copyright (C) 2009 Jakob Borg / nym.se",
        methods = {
                fileAge = {
                        description = "Create age is between min and max",
                        type = "test",
                        arguments = {
                                -- File name is always the first argument and shouldn't be mentioned here
                                -- It is functionally equivalent to { description = "File name", type = "string", default = "" }
                                { description = "Minimum age", type = "seconds", default = "0" },
                                { description = "Maximum age", type = "seconds", default = "0" },
                        },
                },
                fileSize = {
                        description = "File size is between min and max",
                        type = "test",
                        arguments = {
                                -- File name is always the first argument and shouldn't be mentioned here
                                -- It is functionally equivalent to { description = "File name", type = "string", default = "" }
                                { description = "Minimum size", type = "bytes", default = "0" },
                                { description = "Maximum size", type = "bytes", default = "0" },
                        },
                },
                deleteFile = {
                        description = "Move to trash",
                        type = "action",
                        arguments = {
                                -- File name is always the first argument and shouldn't be mentioned here
                                -- It is functionally equivalent to { description = "File name", type = "path", default = "" }
                        },
                },
                moveFileTo = {
                        description = "Move to folder",
                        type = "action",
                        arguments = {
                                -- File name is always the first argument and shouldn't be mentioned here
                                -- It is functionally equivalent to { description = "File name", type = "string", default = "" }
                                { description = "Destination path", type = "path", default = "" },
                        },
                },
        },
};

function fileAge (filename, minAge, maxAge)
        return 0;
end

function fileSize (filename, minSize, maxSize)
        return 0;
end

function deleteFile (filename)
        os.remove(filename);
end

function moveFileTo (filename, newPath)
        os.rename(filename, newPath + "/" + filename);
end

