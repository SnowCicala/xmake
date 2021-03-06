--!The Make-like Build Utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        check.lua
--

-- imports
import("core.tool.tool")
import("platforms.checker", {rootdir = os.programdir()})

-- check the toolchains
function _check_toolchains(config)

    -- get toolchains
    local toolchains = config.get("toolchains")
    if not toolchains then
        local sdkdir = config.get("sdk")
        if sdkdir then
            toolchains = path.join(sdkdir, "bin")
        end
    end

    -- get cross
    local cross = ""
    if toolchains then
        local ldpathes = os.match(path.join(toolchains, "*-ld"))
        for _, ldpath in ipairs(ldpathes) do
            local ldname = path.basename(ldpath)
            if ldname then
                cross = ldname:sub(1, -3)
            end
        end
    end

    -- done
    checker.check_toolchain(config, "cc",   cross, "gcc",       "the c compiler") 
    checker.check_toolchain(config, "cxx",  cross, "g++",       "the c++ compiler") 
    checker.check_toolchain(config, "cxx",  cross, "gcc",       "the c++ compiler") 
    checker.check_toolchain(config, "as",   cross, "gcc",       "the assember")
    checker.check_toolchain(config, "ld",   cross, "g++",       "the linker") 
    checker.check_toolchain(config, "ld",   cross, "gcc",       "the linker") 
    checker.check_toolchain(config, "ar",   cross, "ar",        "the static library archiver") 
    checker.check_toolchain(config, "ex",   cross, "ar",        "the static library extractor") 
    checker.check_toolchain(config, "sh",   cross, "g++",       "the shared library linker") 
    checker.check_toolchain(config, "sh",   cross, "gcc",       "the shared library linker") 
    checker.check_toolchain(config, "sc",   cross, "swiftc",    "the swift compiler") 
end

-- check it
function main(kind)

    -- init the check list of config
    _g.config = 
    {
        { checker.check_arch, "i386" }
    ,   checker.check_ccache
    ,   _check_toolchains
    }

    -- init the check list of global
    _g.global = 
    {
        checker.check_ccache
    }

    -- check it
    checker.check(kind, _g)
end

