plugin = {
        description = "Default plugin",
        copyright = "Copyright (C) 2009 Jakob Borg / nym.se",
        methods = {
                fileAge = {
                        description = "Create age is between min and max",
                        type = "predicate",--(23=8;399(
                        arguments = {
                                -- file name is alway the first argument and shouldn't be mentioned here
                                { description = "Minimum age", type = "seconds", default = "0" },
                                { description = "Maximum age", type = "seconds", default = "0" },
                        },
                },
                fileSize = {
                        description = "File size is between min and max",
                        type = "predicate",
                        arguments = {
                                -- file name is alway the first argument and shouldn't be mentioned here
                                { description = "Minimum size", type = "bytes", default = "0" },
                                { description = "Maximum size", type = "bytes", default = "0" },
                        },
                },
        },
};

function fileAge (filename, minAge, maxAge)
        return 0
end

function fileSize (filename, minSize, maxSize)
        return 0
end

