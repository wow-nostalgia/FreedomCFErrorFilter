local filterChatErrors = true

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
