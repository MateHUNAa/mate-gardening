local str_find = string.find
local str_sub = string.sub
local str_gmatch = string.gmatch

---@class diff
---@field start  integer # The number of bytes at the beginning of the replacement
---@field finish integer # The number of bytes at the end of the replacement
---@field text   string  # What to replace

---@param  uri  string # The uri of file
---@param  text string # The content of file
---@return nil|diff[]
function OnSetText(uri, text)
     -- ignore .vscode dir, extension files (i.e. natives), and other meta files
     if str_find(uri, '[\\/]%.vscode[\\/]') or str_sub(text, 1, 8) == '---@meta' then return end

     -- ignore files using fx asset protection
     if str_sub(text, 1, 4) == 'FXAP' then return '' end

     local diffs = {}
     local count = 0

     for start, realName, finish in text:gmatch [=[require[ ]*["']()__(.-)()["']]=] do
             diffs[#diffs+1] = {
                 start  = start,
                 finish = finish - 1,
                 text   = realName,
             }
     end

     -- prevent diagnostic errors in fxmanifest.lua and __resource.lua files
     if str_find(uri, 'fxmanifest%.lua$') or str_find(uri, '__resource%.lua$') then
          count = count + 1
          diffs[count] = {
               start = 1,
               finish = 0,
               text = '---@diagnostic disable: undefined-global\n'
          }
     end

     -- prevent diagnostic errors from safe navigation (foo?.bar and foo?[bar])
     for safeNav in str_gmatch(text, '()%?[%.%[]+') do
          count = count + 1
          diffs[count] = {
               start  = safeNav,
               finish = safeNav,
               text   = '',
          }
     end

     -- prevent "need-check-nil" diagnostic when using safe navigation
     -- only works for the first index, and requires dot notation (i.e. mytable.index, not mytable["index"])
     for pre, whitespace, tableStart, tableName, tableEnd in str_gmatch(text, '([=,;%s])([%s]*)()([_%w]+)()%?[%.%[]+') do
          count = count + 1
          diffs[count] = {
               start  = tableStart - 1,
               finish = tableEnd - 1,
               text   = ('%s(%s or {})'):format(whitespace == '' and pre or '', tableName)
          }
     end

     if text:find("%+=") or text:find("%-=") or text:find("%/=") then
          return ''
     end


     if #diffs == 0 then
             return nil
     end

     return diffs
end
