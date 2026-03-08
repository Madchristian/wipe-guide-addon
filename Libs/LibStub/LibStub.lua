--[[
    LibStub — Library Stub
    STUB: Echte Version von CurseForge/WoWAce laden!
    https://www.curseforge.com/wow/addons/libstub

    LibStub ist ein minimaler Library-Versioning-Stub für WoW Addons.
    Er ermöglicht es, Libraries versioniert zu laden und Konflikte zu vermeiden.
]]

-- Nur laden wenn LibStub noch nicht existiert
if LibStub then return end

local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = setmetatable({}, {
    __call = function(self, major, silent)
        if not self.libs[major] and not silent then
            error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
        end
        return self.libs[major]
    end
})

LibStub.libs = {}
LibStub.minors = {}

function LibStub:NewLibrary(major, minor)
    assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
    minor = assert(tonumber(strmatch(minor, "%d+")), "Minor version must either be a number or contain a number.")

    local oldminor = self.minors[major]
    if oldminor and oldminor >= minor then return nil end

    self.minors[major] = minor
    self.libs[major] = self.libs[major] or {}
    return self.libs[major], oldminor
end

function LibStub:GetLibrary(major, silent)
    if not self.libs[major] and not silent then
        error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
    end
    return self.libs[major], self.minors[major]
end

function LibStub:IterateLibraries()
    return pairs(self.libs)
end

setmetatable(LibStub, { __call = LibStub.GetLibrary })
_G["LibStub"] = LibStub
