--[=[ 
name: Restore File (EDR Quarantine)
filetype: Infocyte Extension
type: Response
description: |  
    Restores a file by path
author: Datto Support
created: 2024-05-02
updated: 2024-05-03

# Runtime arguments
args:
- path:
    description: path to restore
    type: string
    required: true

]=]


--[=[ SECTION 1: Inputs ]=]
-- hunt.arg(name = <string>, isRequired = <boolean>, [default])
path =  hunt.arg.string("path")
-- Path to file to restore
hunt.log(string.format("Running with Runtime Arguments: path=%s", hunt.arg.string("path")))

--[=[ SECTION 2: Functions ]=]

function file_exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    else
        return false
    end
end

--[=[ SECTION 3: Execute Restore ]=]

if file_exists(path) then
    hunt.log(string.format("File to revert was found on the device already. Not restoring old version"))
    hunt.status.bad()
    return
else
    edr.quarantine.unquarantine(path)
    hunt.log(string.format("File restored to path=%s", file:path()))
    hunt.status.good()
    return
end