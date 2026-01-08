local filterChatErrors = true

if not C_Timer then
    C_Timer = {}
end

do
    local timers = {}
    local frame = CreateFrame("Frame")

    frame:SetScript("OnUpdate", function(self, elapsed)
        for i = #timers, 1, -1 do
            local t = timers[i]
            t.delay = t.delay - elapsed
            if t.delay <= 0 then
                table.remove(timers, i)
                pcall(t.func)
            end
        end
    end)

    function C_Timer.After(delay, func)
        if type(delay) ~= "number" or type(func) ~= "function" then
            return
        end
        table.insert(timers, { delay = delay, func = func })
    end
end


local orig_SendChatMessage = SendChatMessage

function SendChatMessage(msg, chatType, lang, target, ...)
    if chatType == "WHISPER" then
        filterChatErrors = false
        C_Timer.After(0.35, function() 
            filterChatErrors = true
        end)
    end
    return orig_SendChatMessage(msg, chatType, lang, target, ...)
end


local function BlockCrossFactionError(_, event, msg, ...)
    if msg == ERR_CHAT_WRONG_FACTION and filterChatErrors then
        return true
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", BlockCrossFactionError)
