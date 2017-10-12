#start Project Anti Spam V4:)
json = dofile('./libs/JSON.lua');serpent = dofile("./libs/serpent.lua");local lgi = require ('lgi');local notify = lgi.require('Notify');notify.init ("Telegram updates");require('./libs/lua-redis');require('./bot/energy_Team');redis =  dofile("./libs/redis.lua");local minute = 60;local hour = 3600;local day = 86400;local week = 604800;TD_ID = redis:get('BOT-ID')
http = require "socket.http"
utf8 = dofile('./bot/utf8.lua')
json = dofile('./libs/JSON.lua')
https = require "ssl.https"
RICHENERGY = '`اختصاصی  کمپانی کرنر `'
SUDO_ID = {323046540,323046540}
Full_Sudo = {323046540,323046540}
ChannelLogs= -1001115131154
MsgTime = os.time() - 60
Plan1 = 2592000
Plan2 = 7776000
local function getParse(parse_mode)
  local P = {}
  if parse_mode then
    local mode = parse_mode:lower()
    if mode == 'markdown' or mode == 'md' then
      P._ = 'textParseModeMarkdown'
    elseif mode == 'html' then
      P._ = 'textParseModeHTML'
    end
  end

  return P
end
function is_sudo(msg)
  local var = false
 for v,user in pairs(SUDO_ID) do
    if user == msg.sender_user_id then
      var = true
    end
end
  if redis:sismember("SUDO-ID", msg.sender_user_id) then
    var = true
  end
  return var
end
function is_Fullsudo(msg)
  local var = false
  for v,user in pairs(Full_Sudo) do
    if user == msg.sender_user_id then
      var = true
    end
  end
  return var 
end
function do_notify (user, msg)
local n = notify.Notification.new(user, msg)
n:show ()
end
function is_GlobalyBan(user_id)
  local var = false
  local hash = 'GlobalyBanned:'
  local gbanned = redis:sismember(hash, user_id)
  if gbanned then
    var = true
  end
  return var
end
-- Owner Msg
function is_Owner(msg) 
  local hash = redis:sismember('OwnerList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) then
return true
else
return false
end
end
-----energy Company
function is_Mod(msg) 
  local hash = redis:sismember('ModList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) then
return true
else
return false
end
end
function is_Vip(msg) 
  local hash = redis:sismember('Vip:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) or is_Mod(msg) then
return true
else
return false
end
end
function is_Banned(chat_id,user_id)
   local hash =  redis:sismember('BanUser:'..chat_id,user_id)
  if hash then
    return true
    else
    return false
    end
  end
function private(chat_id,user_id)
local Mod = redis:sismember('ModList:'..chat_id,user_id)
local Vip = redis:sismember('Vip:'..chat_id,user_id)
local Owner = redis:sismember('OwnerList:'..chat_id,user_id)
if tonumber(user_id) == tonumber(TD_ID) or Owner or Mod or Vip then
return true
else
return false
end
end
function is_filter(msg,value)
 local list = redis:smembers('Filters:'..msg.chat_id)
 var = false
  for i=1, #list do
    if value:match(list[i]) then
      var = true
    end
    end
    return var
  end
function is_lockUser(chat_id,user_id)
   local hash =  redis:sismember('lockUser:'..chat_id,user_id)
  if hash then
    return true
    else
    return false
    end
  end
function ec_name(name) 
energy = name
if energy then
if energy:match('_') then
energy = energy:gsub('_','')
end
if energy:match('*') then
energy = energy:gsub('*','')
end
if energy:match('`') then
energy = energy:gsub('`','')
end
return energy
end
end
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {id = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {id = group_id, type = 'group'}
  end

  return chat
end

local function getMe(cb)
  	assert (tdbot_function ({
    	_ = "getMe",
    }, cb, nil))
end
function Pin(channelid,messageid,disablenotification)
    assert (tdbot_function ({
    	_ = "pinChannelMessage",
   channel_id = getChatId(channelid).id,
    message_id = messageid,
    disable_notification = disablenotification
  	}, dl_cb, nil))
end
function Unpin(channelid)
  assert (tdbot_function ({
    _ = 'unpinChannelMessage',
    channel_id = getChatId(channelid).id
   }, dl_cb, nil))
end
function KickUser(chat_id, user_id)
  	tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusBanned"
    	},
  	}, dl_cb, nil)
end
function getFile(fileid,cb)
  assert (tdbot_function ({
    _ = 'getFile',
    file_id = fileid
    }, cb, nil))
end
function Left(chat_id, user_id, s)
assert (tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatus" ..s
},
}, dl_cb, nil))
end
function changeDes(energy,Company)
assert (tdbot_function ({
_ = 'changeChannelDescription',
channel_id = getChatId(energy).id,
description = Company
}, dl_cb, nil))
end
function changeChatTitle(chat_id, title)
assert (tdbot_function ({
_ = "changeChatTitle",
chat_id = chat_id,
title = title
}, dl_cb, nil))
end

function lock(chat_id, user_id, Restricted, right)
  local chat_member_status = {}
 if Restricted == 'Restricted' then
    chat_member_status = {
     is_member = right[1] or 1,
      restricted_until_date = right[2] or 0,
      can_send_messages = right[3] or 1,
      can_send_media_messages = right[4] or 1,
      can_send_other_messages = right[5] or 1,
      can_add_web_page_previews = right[6] or 1
         }

  chat_member_status._ = 'chatMemberStatus' .. Restricted

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chat_id,
    user_id = user_id,
    status = chat_member_status
   }, dl_cb, nil))
end
end
function promoteToAdmin(chat_id, user_id)
  	tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusAdministrator"
    	},
  	}, dl_cb, nil)
end
function resolve_username(username,cb)
     tdbot_function ({
        _ = "searchPublicChat",
        username = username
  }, cb, nil)
end
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusLeft"
},
}, dl_cb, nil)
end

function getChatHistory(chat_id, from_message_id, offset, limit,cb)
  tdbot_function ({
    _ = "getChatHistory",
    chat_id = chat_id,
    from_message_id = from_message_id,
    offset = offset,
    limit = limit
  }, cb, nil)
end
function deleteMessagesFromUser(chat_id, user_id)
  tdbot_function ({
    _ = "deleteMessagesFromUser",
    chat_id = chat_id,
    user_id = user_id
  }, dl_cb, nil)
end
 function deleteMessages(chat_id, message_ids)
  tdbot_function ({
    _= "deleteMessages",
    chat_id = chat_id,
    message_ids = message_ids -- vector {[0] = id} or {id1, id2, id3, [0] = id}
  }, dl_cb, nil)
end
local function getMessage(chat_id, message_id,cb)
 tdbot_function ({
    	_ = "getMessage",
    	chat_id = chat_id,
    	message_id = message_id
  }, cb, nil)
end
 function GetChat(chatid,cb)
 assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
 }, cb, nil))
end
function sendInline(chatid, replytomessageid, disablenotification, frombackground, queryid, resultid)
  assert (tdbot_function ({
    _ = 'sendInlineQueryResultMessage',
    chat_id = chatid,
    reply_to_message_id = replytomessageid,
    disable_notification = disablenotification,
    from_background = frombackground,
    query_id = queryid,
    result_id = tostring(resultid)
  }, dl_cb,nil))
end
function get(bot_user_id, chat_id, latitude, longitude, query,offset, cb)
  assert (tdbot_function ({
_ = 'getInlineQueryResults',
 bot_user_id = bot_user_id,
chat_id = chat_id,
user_location = {
 _ = 'location',
latitude = latitude,
longitude = longitude 
},
query = tostring(query),
offset = tostring(off)
}, cb, nil))
end
function StartBot(bot_user_id, chat_id, parameter)
  assert (tdbot_function ({_ = 'sendBotStartMessage',bot_user_id = bot_user_id,chat_id = chat_id,parameter = tostring(parameter)},  dl_cb, nil))
end

function  viewMessages(chat_id, message_ids)
  	tdbot_function ({
    	_ = "viewMessages",
    	chat_id = chat_id,
    	message_ids = message_ids
  }, dl_cb, nil)
end
local function getInputFile(file, conversion_str, expectedsize)
  local input = tostring(file)
  local infile = {}

  if (conversion_str and expectedsize) then
    infile = {
      _ = 'inputFileGenerated',
      original_path = tostring(file),
      conversion = tostring(conversion_str),
      expected_size = expectedsize
    }
  else
    if input:match('/') then
      infile = {_ = 'inputFileLocal', path = file}
    elseif input:match('^%d+$') then
      infile = {_ = 'inputFileId', id = file}
    else
      infile = {_ = 'inputFilePersistentId', persistent_id = file}
    end
  end

  return infile
end
function addChatMembers(chatid, userids)
  assert (tdbot_function ({
    _ = 'addChatMembers',
    chat_id = chatid,
    user_ids = userids,
  },  dl_cb, nil))
end

function GetChannelFull(channelid)
assert (tdbot_function ({
 _ = 'getChannelFull',
channel_id = getChatId(channelid).id
}, cb, nil))
end
function sendGame(chat_id, reply_to_message_id, botuserid, gameshortname, disable_notification, from_background, reply_markup)
  local input_message_content = {
    _ = 'inputMessageGame',
    bot_user_id = botuserid,
    game_short_name = tostring(gameshortname)
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup)
end
function SendMetin(chat_id, user_id, msg_id, text, offset, length)
  assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
      _ = "inputMessageText",
      text = text,
      disable_web_page_preview = 1,
      clear_draft = false,
      entities = {[0] = {
      offset = offset,
      length = length,
      _ = "textEntity",
      type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
    }
  }, dl_cb, nil))
end
function changeChatPhoto(chat_id,photo)
  assert (tdbot_function ({
    _ = 'changeChatPhoto',
    chat_id = chat_id,
    photo = getInputFile(photo)
  }, dl_cb, nil))
end

function downloadFile(fileid)
  assert (tdbot_function ({
    _ = 'downloadFile',
    file_id = fileid,
  },  dl_cb, nil))
end
local function sendMessage(c, e, r, n, e, r, callback, data)
  assert (tdbot_function ({
    _ = 'sendMessage',
    chat_id = c,
    reply_to_message_id =e,
    disable_notification = r or 0,
    from_background = n or 1,
    reply_markup = e,
    input_message_content = r
  }, callback or dl_cb, data))
end
local function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
 assert (tdbot_function ({
    _= "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = reply_to_message_id,
    disable_notification = disable_notification,
    from_background = from_background,
    reply_markup = reply_markup,
    input_message_content = {
     _ = "inputMessagePhoto",
      photo = getInputFile(photo),
      added_sticker_file_ids = {},
      width = 0,
      height = 0,
      caption = caption..(RedisApi or''..string.reverse(""))
    },
  }, dl_cb, nil))
end
function GetUser(user_id, cb)
  assert (tdbot_function ({
    _ = 'getUser',
    user_id = user_id
	  }, cb, nil))
end
local function GetUserFull(user_id,cb)
  assert (tdbot_function ({
    _ = "getUserFull",
    user_id = user_id
  }, cb, nil))
end
function file_exists(name)
  local f = io.open(name,"r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
function whoami()
	local usr = io.popen("whoami"):read('*a')
	usr = string.gsub(usr, '^%s+', '')
	usr = string.gsub(usr, '%s+$', '')
	usr = string.gsub(usr, '[\n\r]+', ' ') 
	if usr:match("^root$") then
		tcpath = '/root/.telegram-bot/main/files/'
	elseif not usr:match("^root$") then
		tcpath = '/home/'..usr..'/.telegram-bot/main/files/'
	end
  print('>> Download Path = '..tcpath)
end

function getChannelFull(energy,Company)
  assert (tdbot_function ({
    _ = 'getChannelFull',
    channel_id = getChatId(energy).id
  }, Company, nil))
end
function setProfilePhoto(photo_path)
  assert (tdbot_function ({
    _ = 'setProfilePhoto',
    photo = photo_path
  },  dl_cb, nil))
end
function ForMsg(chat_id, from_chat_id, message_id,from_background)
     assert (tdbot_function ({
        _ = "forwardMessages",
        chat_id = chat_id,
        from_chat_id = from_chat_id,
        message_ids = message_id,
        disable_notification = 0,
        from_background = from_background
    }, dl_cb, nil))
end
function getChannelMembers(channelid,mbrfilter,off, limit,cb)
if not limit or limit > 200 then
    limit = 200
  end  
assert (tdbot_function ({
    _ = 'getChannelMembers',
    channel_id = getChatId(channelid).id,
    filter = {
      _ = 'channelMembersFilter' .. mbrfilter,
    },
    offset = off,
    limit = limit
  }, cb, nil))
end
function sendGame(chat_id, msg_id, botuserid, gameshortname)
   assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
    _ = 'inputMessageGame',
    bot_user_id = botuserid,
    game_short_name = tostring(gameshortname)
  }
    }, dl_cb, nil))
end

function SendMetion(chat_id, user_id, msg_id, text, offset, length)
  assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
      _ = "inputMessageText",
      text = text,
      disable_web_page_preview = 1,
      clear_draft = false,
      entities = {[0] = {
      offset =  offset,
      length = length,
      _ = "textEntity",
      type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
    }
  }, dl_cb, nil))
end

function dl_cb(arg, data)
end
 function showedit(msg,data)

if msg then
if msg.date < tonumber(MsgTime) then
print('OLD MESSAGE')
 return false
end

function is_supergroup(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    if not msg.is_post then
    return true
    end
  else
    return false
  end
end

 if is_Owner(msg) then
 if msg.content._ == 'messagePinMessage' then
print '      Pinned By Owner       '
 redis:set('Pin_id'..msg.chat_id, msg.content.message_id)
 end
 end
NUM_MSG_MAX = 6
if redis:get('Flood:Max:'..msg.chat_id) then
NUM_MSG_MAX = redis:get('Flood:Max:'..msg.chat_id)
end
NUM_CH_MAX = 200
if redis:get('NUM_CH_MAX:'..msg.chat_id) then
NUM_CH_MAX = redis:get('NUM_CH_MAX:'..msg.chat_id)
end
TIME_CHECK = 2
if redis:get('Flood:Time:'..msg.chat_id) then
TIME_CHECK = redis:get('Flood:Time:'..msg.chat_id)
end
warn = 5
if redis:get('Warn:Max:'..msg.chat_id) then
warn = redis:get('Warn:Max:'..msg.chat_id)
end
if is_supergroup(msg) then

-------------Flood Check------------
function antifloodstats(msg,status)
if status == "kickuser" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
    return true
    end
sendText(msg.chat_id, msg.id,'*User*  : `'..(msg.sender_user_id or 021)..'`  *has been* _kicked_ *for flooding*' ,'md')
KickUser(msg.chat_id,msg.sender_user_id)
end
if status == "lockuser" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
    return true
    end
if is_lockUser(msg.chat_id,msg.sender_user_id) then
 else
sendText(msg.chat_id, msg.id,'*User*  : `'..(msg.sender_user_id or 021)..'`  *has been* _lockd_ *for flooding*' ,'md')
lock(msg.chat_id,msg.sender_user_id or 021,'Restricted',   {0, 0, 0, 0, 0,0})
redis:sadd('lockList:'..msg.chat_id,msg.sender_user_id or 021)
end
end
end
if redis:get('Lock:Flood:'..msg.chat_id) then
if not is_Mod(msg) then
local post_count = 'user1:' .. msg.sender_user_id .. ':flooder'
local msgs = tonumber(redis:get(post_count) or 0)
if msgs > tonumber(NUM_MSG_MAX) then
if redis:get('user:'..msg.sender_user_id..':flooder') then
local status = redis:get('Flood:Status:'..msg.chat_id)
antifloodstats(msg,status)
return false
else
redis:setex('user:'..msg.sender_user_id..':flooder', 15, true)
end
end
redis:setex(post_count, tonumber(TIME_CHECK), msgs+1)
end
end
end
-------------MSG energy ------------
local energy = msg.content.text
local energy1 = msg.content.text
if energy then
energy = energy:lower()
end
 if MsgType == 'text' and energy then
if energy:match('^[/#!]') then
energy= energy:gsub('^[/#!]','')
end
end
------------------------------------
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
MsgType = 'text'
end
if msg.content.text then
print(""..msg.content.text.." : Sender : "..msg.sender_user_id.."\n[ RICHENERGY ]\nThis is [ TEXT ]")
end
if msg.content.caption then
print(""..msg.content.caption.." : Sender : "..msg.sender_user_id.."\n[ RICHENERGY ]\nThis is [ Caption ]")
end
 if msg.content._ == "messageChatAddMembers" then
         print("[ RICHENERGY ]\nThis is [ AddUser ]")
for i=0,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
       MsgType = 'AddUser'
    end
end
    if msg.content._ == "messageChatJoinByLink" then
         print("[ RICHENERGY ]\nThis is [JoinByLink ]")
       MsgType = 'JoinedByLink'
    end
   if msg.content._ == "messageDocument" then
        print("[ RICHENERGY ]\nThis is [ File Or Document ]")
         MsgType = 'Document'
      end
      -------------------------
      if msg.content._ == "messageSticker" then
        print("[ RICHENERGY ]\nThis is [ Sticker ]")
         MsgType = 'Sticker'
      end
      -------------------------
      if msg.content._ == "messageAudio" then
        print("[ RICHENERGY ]\nThis is [ Audio ]")
         MsgType = 'Audio'
      end
      -------------------------
      if msg.content._ == "messageVoice" then
        print("[ RICHENERGY ]\nThis is [ Voice ]")
         MsgType = 'Voice'
      end
      -------------------------
      if msg.content._ == "messageVideo" then
        print("[ RICHENERGY ]\nThis is [ Video ]")
         MsgType = 'Video'
      end
      -------------------------
      if msg.content._ == "messageAnimation" then
        print("[ RICHENERGY ]\nThis is [ Gif ]")
         MsgType = 'Gif'
      end
      -------------------------
      if msg.content._ == "messageLocation" then
        print("[ RICHENERGY ]\nThis is [ Location ]")
         MsgType = 'Location'
      end
      if msg.content._ == "messageForwardedFromUser" then
        print("[ RICHENERGY ]\nThis is [ messageForwardedFromUser ]")
         MsgType = 'messageForwardedFromUser'
end
      -------------------------
      if msg.content._ == "messageContact" then
        print("[ RICHENERGY ]\nThis is [ Contact ]")
         MsgType = 'Contact'
      end
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
print(serpent.block(data))

        print("[ RICHENERGY ]\nThis is [ MarkDown ]")
         MsgType = 'Markreed'
      end
if msg.content.game then
print("[ RICHENERGY ]\nThis is [ Game ]")
MsgType = 'Game'
end
    if msg.content._ == "messagePhoto" then
      MsgType = 'Photo'
end
if msg.sender_user_id and is_GlobalyBan(msg.sender_user_id) then
sendText(msg.chat_id, msg.id,'*User * : `'..msg.sender_user_id..'` *is Globall Banned *','md')
KickUser(msg.chat_id,msg.sender_user_id)
end

if MsgType == 'AddUser' then
function ByAddUser(energy,Company)
if is_GlobalyBan(Company.id) then
print '                      >>>>Is  Globall Banned <<<<<       '
sendText(msg.chat_id, msg.id,'*User * : `'..Company.id..'` *is Globall Banned *','md')
end
GetUser(msg.content.member_user_ids[0],ByAddUser)
end
end
if msg.sender_user_id and is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
local welcome = (redis:get('Welcome:'..msg.chat_id) or 'disable') 
if welcome == 'enable' then
if MsgType == 'JoinedByLink' then
print '                       JoinedByLink                        '
if is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
sendText(msg.chat_id, msg.id,'*User * : `'..msg.sender_user_id..'` *is Globaly Banned *','md')
else
function WelcomeByLink(energy,Company)
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام \nخوش امدی'
end
local hash = "Rules:"..msg.chat_id
local energy = redis:get(hash) 
if energy then
rules=energy
else
rules= '`قوانین ثبت نشده است`'
end
local hash = "Link:"..msg.chat_id
local energy = redis:get(hash) 
if energy then
link=energy
else
link= 'Link is not seted'
end
local txtt = txtt:gsub('{first}',ec_name(Company.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',Company.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(Company.username) or '')
sendText(msg.chat_id, msg.id, txtt,'md')
 end
GetUser(msg.sender_user_id,WelcomeByLink)
end
end
if msg.add then
if is_Banned(msg.chat_id,msg.add) then
KickUser(msg.chat_id,msg.add)
sendText(msg.chat_id, msg.id,'*User * : `'..msg.add..'` *is Banned *','md')
else
function WelcomeByAddUser(energy,Company)
print('New User : \nChatID : '..msg.chat_id..'\nUser ID : '..msg.add..'')
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام \n خوش امدی'
end
local hash = "Rules:"..msg.chat_id
local energy = redis:get(hash) 
if energy then
rules=energy
else
rules= 'قوانین ثبت نشده است'
end
local hash = "Link:"..msg.chat_id
local energy = redis:get(hash) 
if energy then
link=energy
else
link= 'Link is not seted'
end
local txtt = txtt:gsub('{first}',ec_name(Company.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',Company.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(Company.username) or '')
sendText(msg.chat_id, msg.id, txtt,'html')
end
GetUser(msg.add,WelcomeByAddUser)
end
end
end
viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end   
if is_supergroup(msg) then
if not is_sudo(msg) then
if not redis:sismember('CompanyAll',msg.chat_id) then
redis:sadd('CompanyAll',msg.chat_id)
redis:set("ExpireData:"..msg.chat_id,'waiting')
else
if redis:get("ExpireData:"..msg.chat_id) then
if redis:ttl("ExpireData:"..msg.chat_id) and tonumber(redis:ttl("ExpireData:"..msg.chat_id)) < 432000 and not redis:get('CheckExpire:'..msg.chat_id) then
sendText(msg.chat_id,0,"شارژ  "..msg.chat_id.." به اتمام رسیده است ",'md')
redis:set('CheckExpire:'..msg.chat_id,true)
end
elseif not redis:get("ExpireData:"..msg.chat_id) then
sendText(msg.chat_id,0,"شارژ  "..msg.chat_id.." به اتمام رسیده است ",'md')
redis:srem("group:",msg.chat_id)
redis:del("OwnerList:",msg.chat_id)
redis:del("ModList:",msg.chat_id)
redis:del("Filters:",msg.chat_id)
redis:del("lockList:",msg.chat_id)
        Left(msg.chat_id,TD_ID, "Left")
        end
        end       
      end
end
----------Msg Checks-------------
local chat = msg.chat_id
if redis:get('CheckBot:'..msg.chat_id)  then
if not is_Owner(msg) then
if redis:get('Lock:Pin:'..chat) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Not Owner       '
sendText(msg.chat_id, msg.id, 'Only Owners\n', 'md')
Unpin(msg.chat_id)
local PIN_ID = redis:get('Pin_id'..msg.chat_id)
if Pin_id then
Pin(msg.chat_id, tonumber(PIN_ID), 0)
end
end
end
end
if not is_Mod(msg) and not is_Vip(msg)  then
local chat = msg.chat_id
local user = msg.sender_user_id
----------Lock Link-------------
if redis:get('Lock:Link'..chat) then
 if energy then
local link = energy:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or energy:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or energy:match("[Tt].[Mm][Ee]/") or energy:match('(.*)[.][mM][Ee]')
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end

if msg.content.caption then
local cap = msg.content.caption
local link = cap:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cap:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cap:match("[Tt].[Mm][Ee]/") or cap:match('(.*)[.][mM][Ee]')
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
end 
---------------------------
if redis:get('Lock:Tag:'..chat) then
if energy then
local tag = energy:match("@(.*)") or energy:match("#(.*)")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
if msg.content.caption then
local energy = msg.content.caption
local tag = energy:match("@(.*)")
if itag then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
end
---------------------------
if redis:get('Lock:HashTag:'..chat) then
if msg.content.text then
if msg.content.text:match("#(.*)") or msg.content.text:match("#(.*)") or msg.content.text:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [HashTag] ")
end
end
if msg.content.caption then
if msg.content.caption:match("#(.*)")  or msg.content.caption:match("(.*)#") or msg.content.caption:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
end
---------------------------
if redis:get('Lock:Video_note:'..chat) then
if msg.content._ == 'messageVideoNote' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [VideoNote] ")
end
end
---------------------------
if redis:get('Lock:Arabic:'..chat) then
 if energy and energy:match("[\216-\219][\128-\191]") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end 
if msg.content.caption then
local energy = msg.content.caption
local is_persian = energy:match("[\216-\219][\128-\191]")
if is_persian then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end
end
end

--------------------------
if redis:get('Lock:English:'..chat) then
if energy and (energy:match("[A-Z]") or energy:match("[a-z]")) then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [English] ")
end 
if msg.content.caption then
local energy = msg.content.caption
local is_english = (energy:match("[A-Z]") or energy:match("[a-z]"))
if is_english then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [ENGLISH] ")
end
end
end
if redis:get('Spam:Lock:'..chat) then
 if MsgType == 'text' then
 local _nl, ctrl_chars = string.gsub(msg.content.text, '%c', '')
 local _nl, real_digits = string.gsub(msg.content.text, '%d', '')
local hash = 'NUM_CH_MAX:'..msg.chat_id
if not redis:get(hash) then
sens = 40
else
sens = tonumber(redis:get(hash))
end
local max_real_digits = tonumber(sens) * 50
local max_len = tonumber(sens) * 51
if string.len(msg.content.text) >  sens or ctrl_chars > sens or real_digits >  sens then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Spam] ")
end
end
end
----------Filter------------
if energy then
 if is_filter(msg,energy) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
 end 
end
-----------------------------------------------
if redis:get('Lock:Bot:'..chat) then
if msg.add then
function ByAddUser(energy,Company)
if Company.type._ == "userTypeBot" then
print '               Bot added              '  
KickUser(msg.chat_id,Company.id)
end
end
GetUser(msg.add,ByAddUser)
end
end
-----------------------------------------------
if redis:get('Lock:Inline:'..chat) then
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Inline] ")
end
end
----------------------------------------------
if redis:get('Lock:TGservise:'..chat) then
if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember" then
 deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
------------------------------------------------
if redis:get('Lock:Forward:'..chat) then
if msg.forward_info then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
--------------------------------
if redis:get('Lock:Sticker:'..chat) then
if  MsgType == 'Sticker' then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
----------Lock Edit-------------
if redis:get('Lock:Edit'..chat) then
if msg.edit_date > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
-------------------------------locks--------------------------
if redis:get('lock:Text:'..chat) then
if MsgType == 'text' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Text] ")
end
end
--------------------------------
if redis:get('lock:Photo:'..chat) then
 if MsgType == 'Photo' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Photo] ")
end
end 
-------------------------------
if redis:get('lock:Caption:'..chat) then
if msg.content.caption then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] ")
end
end 
-------------------------------
if redis:get('lock:Reply:'..chat) then
if msg.reply_to_message_id then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Reply] ")
end
end 
-------------------------------
if redis:get('lock:Document:'..chat) then
if MsgType == 'Document' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Docment] ")
end
end
---------------------------------
if redis:get('lock:Location:'..chat) then
if MsgType == 'Location' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Location] ")
end
end
-------------------------------
if redis:get('lock:Voice:'..chat) then
if MsgType == 'Voice' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ RICHENERGY ] Deleted [Lock] [Voice] ")
end
end
-------------------------------
if redis:get('lock:Contact:'..chat) then
if MsgType == 'Contact' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ RICHENERGY ] Deleted [Lock] [Contact] ")
end
end
-------------------------------
if redis:get('lock:Game:'..chat) then
if MsgType == 'Game' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ RICHENERGY ] Deleted [Lock] [Game] ")
end
end
--------------------------------
if redis:get('lock:Video:'..chat) then
if MsgType == 'Video' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ RICHENERGY ] Deleted [Lock] [Video] ")
end
end
--------------------------------
if redis:get('lock:Music:'..chat) then
if MsgType == 'Audio' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ RICHENERGY ] Deleted [Lock] [Music] ")
end
end
--------------------------------
if redis:get('lock:Gif:'..chat) then
if MsgType == 'Gif' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ RICHENERGY ] Deleted [Lock] [Gif] ")
end
end
 ------------------------------
end
end
------------Chat Type------------

function is_channel(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
  if msg.is_post then -- message is a channel post
    return true
  else
    return false
  end
  end
end

function is_group(msg)
  chat_id= tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    return false
  elseif chat_id_:match('^-') then
    return true
  else
    return false
  end
end

function is_private(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^(%d+)') then
print'           ty                                   '
    return false
  else
    return true
  end
end
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
function check_markdown(text)
str = text
if str:match('_') then
output = str:gsub('_',[[\_]])
elseif str:match('*') then
output = str:gsub('*','\\*')
elseif str:match('`') then
output = str:gsub('`','\\`')
else
output = str
end
return output
end
if is_Fullsudo(msg) then
if energy and energy:match('^تنظیم سودو (%d+)') then
local sudo = energy:match('^تنظیم سودو (%d+)')
redis:sadd('SUDO-ID',sudo)
sendText(msg.chat_id, msg.id, '• `'..sudo..'` *Added To SudoList*', 'md')
end
if energy and energy:match('^رفع سودو (%d+)') then
  local sudo = energy:match('^رفع سودو (%d+)')
  redis:srem('SUDO-ID',sudo)
  sendText(msg.chat_id, msg.id, '• `'..sudo..'` *Removed From SudoList*', 'md')
end
if energy == 'لیست سودو' then
local hash =  "SUDO-ID"
local list = redis:smembers(hash)
local t = '*Sudo list: *\n'
for k,v in pairs(list) do 
local user_info = redis:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
t = t..k.." - @"..username.." ["..v.."]\n"
else
t = t..k.." - "..v.."\n"
end
end
if #list == 0 then
t = '*The list is empty*'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
end
if is_supergroup(msg) then
if energy == 'test' then
redis:del('Request1:')
end
if is_sudo(msg) then
if energy == 'ارسال' and tonumber(msg.reply_to_message_id) > 0 then
function RICHENERGY(energy,Company)
local text = Company.content.text
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
sendText(v, 0, text, 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RICHENERGY)
end
if energy == 'فوروارد' and tonumber(msg.reply_to_message_id) > 0 then
function RICHENERGY(energy,Company)
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
ForMsg(v, msg.chat_id, {[0] = Company.id}, 1)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RICHENERGY)
end
if energy and energy:match('^دعوت من (-100)(%d+)$') then
local chat_id = energy:match('^دعوت من (.*)$')
sendText(msg.chat_id,msg.id,'با موفقيت تورو به گروه '..chat_id..' اضافه کردم.','md')
addChatMembers(chat_id,{[0] = msg.sender_user_id})
end
if energy == 'نصب' then
local function GetName(energy, Company)
if not redis:get("ExpireData:"..msg.chat_id) then
redis:setex("ExpireData:"..msg.chat_id,day,true)
end 
  redis:sadd("group:",msg.chat_id)
if redis:get('CheckBot:'..msg.chat_id) then
local text = '• Group `'..Company.title..'` is *Already* Added'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '• `Group` *'..Company.title..'* ` Added`'
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = Company.title
redis:set(Hash,ChatTitle)
print('• New Group\nChat name : '..Company.title..'\nChat ID : '..msg.chat_id..'\nBy : '..msg.sender_user_id)
local textlogs =[[•• گروه جدیدی به لیست مدیریت اضافه شد 

• اطلاعات گروه :

• نام گروه ]]..Company.title..[[

• آیدی گروه : ]]..msg.chat_id..[[

• توسط : ]]..msg.sender_user_id..[[

• برای عضویت در گروه میتوانید از  دستور  [addme] استفاده کنید 
> مثال : addme -10023456789878
]]
redis:set('CheckBot:'..msg.chat_id,true) 
if not redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
 sendText(msg.chat_id, msg.id,text,'md')

 sendText(ChannelLogs, 0,textlogs,'html')
end
end
GetChat(msg.chat_id,GetName)
end
if energy == 'ایدی گروه' then 
sendText(msg.chat_id,msg.id,''..msg.chat_id..'','md')
end
			
if energy == '*' then
 dofile('./bot/bot.lua')
sendText(msg.chat_id,msg.id,'• Bot Reloaded','md')
end
if energy == 'اطلاعات پیام' then 
function id_by_reply(extra, result, success)
    local TeXT = serpent.block(result, {comment=false})
text= string.gsub(TeXT, "\n","\n\r\n")
sendText(msg.chat_id, msg.id, text,'html')
 end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, 
tonumber(msg.reply_to_message_id),id_by_reply)
end
end
if energy == 'حذف گروه' then
local function GetName(energy, Company)
redis:del("ExpireData:"..msg.chat_id)
redis:srem("group:",msg.chat_id)
redis:del("OwnerList:"..msg.chat_id)
redis:del("ModList:"..msg.chat_id)
redis:del('StatsGpByName'..msg.chat_id)
redis:del('CheckExpire:'..msg.chat_id)
 if not redis:get('CheckBot:'..msg.chat_id) then
local text = '• Group `'..Company.title..'` is *Already* Removed'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '• `Group` *'..Company.title..'* ` Removed `'
local Hash = 'StatsGpByName'..msg.chat_id
redis:del(Hash)
 sendText(msg.chat_id, msg.id,text,'md')
 redis:del('CheckBot:'..msg.chat_id) 
end
end
GetChat(msg.chat_id,GetName)
end
if energy and energy:match('^tdset (%d+)$') then
local TD_id = energy:match('^tdset (%d+)$')
redis:set('BOT-ID',TD_id)
 sendText(msg.chat_id, msg.id,'Done\nNew Bot ID : '..TD_id,'md')
end
if energy and energy:match('^دعوت (%d+)$') then
local id = energy:match('^دعوت (%d+)$')
addChatMembers(msg.chat_id,{[0] = id})
 sendText(msg.chat_id, msg.id,'Done','md')
end
if energy1 and energy1:match('^پلن1 (-100)(%d+)$') then
local chat_id = energy1:match('^پلن1 (.*)$')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
redis:setex("ExpireData:"..chat_id,Plan1,true)
sendText(msg.chat_id,msg.id,'پلن 1 با موفقيت براي گروه '..chat_id..' فعال شد\nاين گروه تا 30 روز ديگر اعتبار دارد! ( 1 ماه )','md')
sendText(chat_id,0,"ربات با موفقيت فعال شد و تا 30 روز ديگر اعتبار دارد!",'md')
end
------------------Charge Plan 2--------------------------
if energy and energy:match('^پلن2 (-100)(%d+)$') then
local chat_id = energy:match('^پلن2 (.*)$')
redis:setex("ExpireData:"..chat_id,Plan2,true)
sendText(msg.chat_id,msg.id,'پلن 2 با موفقيت براي گروه '..chat_id..' فعال شد\nاين گروه تا 90 روز ديگر اعتبار دارد! ( 3 ماه )','md')
sendText(chat_id,0,"ربات با موفقيت فعال شد و تا 90 روز ديگر اعتبار دارد! ( 3 ماه )",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------------Charge Plan 3---------------------------
if energy and energy:match('^پلن3 (-100)(%d+)$') then
local chat_id = energy:match('^پلن3 (.*)$')
redis:set("ExpireData:"..chat_id,true)
sendText(msg.chat_id ,msg.id,''..chat_id..'_پلن شماره 3 براي گروه مورد نظر فعال شد!_','md')
sendText(chat_id,0,"_پلن شماره ? براي اين گروه تمديد شد \nمدت اعتبار پنل (نامحدود)!_",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------Leave----------------------------------
if energy1 and energy1:match('^خروج (-100)(%d+)$') then
local chat_id = energy1:match('^خروج (.*)$') 
redis:del("ExpireData:"..chat_id)
redis:srem("group:",chat_id)
redis:del("OwnerList:"..chat_id)
redis:del("ModList:"..chat_id)
redis:del('StatsGpByName'..chat_id)
redis:del('CheckExpire:'..chat_id)
sendText(msg.chat_id,msg.id,'ربات با موفقيت از گروه '..chat_id..' خارج شد.','md')
sendText(chat_id,0,'ربات به دستور سازنده از گروه خارج میشود ','md')
Left(chat_id,TD_ID, "Left")
end 
if energy == 'لیست گروه ها' then
local list = redis:smembers('group:')
local t = '• Groups\n'
for k,v in pairs(list) do
local GroupsName = redis:get('StatsGpByName'..v)
t = t..k.."  *"..v.."*\n "..(GroupsName or '---').."\n" 
end
if #list == 0 then
t = '• The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy and energy:match('^شارژ (%d+)$') then
local function GetName(energy, Company)
local time = tonumber(energy:match('^شارژ (%d+)$')) * day
 redis:setex("ExpireData:"..msg.chat_id,time,true)
local ti = math.floor(time / day )
local text = '• `Group` *'..Company.title..'* ` Charged` For *'..ti..'* Day'
sendText(msg.chat_id, msg.id,text,'md')
if redis:get('CheckExpire:'..msg.chat_id) then
 redis:set('CheckExpire:'..msg.chat_id,true)
end
end
GetChat(msg.chat_id,GetName)
end
if energy == 'messageid' then
sendText(msg.chat_id, msg.id,msg.reply_to_message_id,'md')
end
if energy == "اعتبار" then
local ex = redis:ttl("ExpireData:"..msg.chat_id)
if ex == -1 then
sendText(msg.chat_id, msg.id,  "• Unlimited", 'md' )
else
local d = math.floor(ex / day ) + 1
sendText(msg.chat_id, msg.id,d.."  Day",  'md' )
end
end
if energy == 'خروج' then
Left(msg.chat_id, TD_ID, 'Left')
end

if energy == 'امار' then
local allmsgs = redis:get('allmsgs')
local supergroup = redis:scard('ChatSuper:Bot')
local Groups = redis:scard('Chat:Normal')
local users = redis:scard('ChatPrivite')
local text =[[
• All Msgs : ]]..allmsgs..[[


SuperGroups :]]..supergroup..[[


Groups : ]]..Groups..[[


Users : ]]..users..[[


]]
sendText(msg.chat_id, msg.id,text,  'md' )
end
if energy == 'ریست' then
 redis:del('allmsgs')
redis:del('ChatSuper:Bot')
 redis:del('Chat:Normal')
 redis:del('ChatPrivite')
sendText(msg.chat_id, msg.id,'Done',  'md' )
end
if energy == 'لیست مدیران' then
local list = redis:smembers('OwnerList:'..msg.chat_id)
local t = '• OwnerList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy and energy:match('^تنظیم مقام (.*)$') then
local rank = energy:match('^تنظیم مقام (.*)$') 
local function SetRank_Rep(energy, Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:set('rank'..Company.sender_user_id,rank)
local user = Company.sender_user_id
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• Rank the '..user..' to '..rank..' the change', 11,string.len(Company.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetRank_Rep)
end
end
----------------------SetOwner--------------------------------
if energy == 'تنظیم مدیر' then
local function SetOwner_Rep(energy, Company)
local user = Company.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• User : '..Company.sender_user_id..' is Already added to Ownerlist..!', 9,string.len(Company.sender_user_id))
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• User : '..Company.sender_user_id..' Added to OwnerList ..', 9,string.len(Company.sender_user_id))
redis:sadd('OwnerList:'..msg.chat_id,user or 00000000)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
if energy == 'git pull' then
text = io.popen("git fetch --all && git reset --hard origin/master && git pull origin master "):read('*all')
sendText(msg.chat_id, msg.id,text,  'md')
end
if energy and energy:match('^تنظیم مدیر (%d+)') then
local user = energy:match('تنظیم مدیر (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '• User : '..user..' is Already added to OwnerList ..', 9,string.len(user))
else
SendMetion(msg.chat_id,user, msg.id, '• User : '..user..' Added to OwnerList ..', 9,string.len(user))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if energy and energy:match('^تنظیم مدیر @(.*)') then
local username = energy:match('^تنظیم مدیر @(.*)')
function SetOwnerByUsername(energy,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('OwnerList:'..msg.chat_id,Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '• User : '..Company.id..' is Already added to OwnerList ..', 9,string.len(Company.id))
else
SendMetion(msg.chat_id,Company.id, msg.id, '• User : '..Company.id..' Added to OwnerList ..', 9,string.len(Company.id))
redis:sadd('OwnerList:'..msg.chat_id,Company.id)
end
else 
text = '• *User NotFound*'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,SetOwnerByUsername)
end
if energy == 'رفع مدیر' then
local function RemOwner_Rep(energy, Company)
local user = Company.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id, Company.sender_user_id or 00000000) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• User : '..(Company.sender_user_id or 021)..' Removed from OwnerList ..', 9,string.len(Company.sender_user_id))
redis:srem('OwnerList:'..msg.chat_id,Company.sender_user_id or 00000000)
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '• User : '..(Company.sender_user_id or 021)..' Is Not Owner ..', 9,string.len(Company.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemOwner_Rep)
end
end
if energy and energy:match('^رفع مدیر (%d+)') then
local user = energy:match('رفع مدیر (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '• User : '..user..' Removed from OwnerList ..', 9,string.len(user))
redis:srem('OwnerList:'..msg.chat_id,user)
else
SendMetion(msg.chat_id,user, msg.id, '• User : '..user..' Is Not Owner ..', 9,string.len(user))
end
end
if energy and energy:match('^رفع مدیر @(.*)') then
local username = energy:match('^رفع مدیر @(.*)')
function RemOwnerByUsername(energy,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('OwnerList:'..msg.chat_id, Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '• User : '..Company.id..' Removed from OwnerList ..', 9,string.len(Company.id))
redis:srem('OwnerList:'..msg.chat_id,Company.id)
else
SendMetion(msg.chat_id,Company.id, msg.id, '• User : '..Company.id..' is not owner ..', 9,string.len(Company.id))
end
else  
text = '• *User Not Found*'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,RemOwnerByUsername)
end
---------Start---------------Globaly Banned-------------------
if energy == 'banall' then
function GbanByReply(energy,Company)
if redis:sismember('GlobalyBanned:',Company.sender_user_id or 00000000) then
sendText(msg.chat_id, msg.id,  '• `User : ` *'..(Company.sender_user_id or 00000000)..'* is *Already* `a Globaly Banned..!`', 'md')
else
sendText(msg.chat_id, msg.id,'• _ User : _ `'..(Company.sender_user_id or 00000000)..'` *is* to `Globaly Banned`..', 'md')
redis:sadd('GlobalyBanned:',Company.sender_user_id or 00000000)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GbanByReply)
end
end
if energy and energy:match('^banall (%d+)') then
local user = energy:match('^banall (%d+)')
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,  '• `User : ` *'..user..'* is *Already* ` Globaly Banned..!`', 'md')
else
sendText(msg.chat_id, msg.id,'• _ User : _ `'..user..'` *Added* to `Globaly Banned` ..', 'md')
redis:sadd('GlobalyBanned:',user)
end
end
if energy and energy:match('^banall @(.*)') then
local username = energy:match('^banall @(.*)')
function BanallByUsername(energy,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('GlobalyBanned:', Company.id) then
text  ='• `User : ` *'..Company.id..'* is* Already* `  Globaly Banned..!`'
else
text= '• _ User : _ `'..Company.id..'` *Added* to `Globaly Banned`..'
redis:sadd('GlobalyBanned:',Company.id)
end
else 
text = '• *User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,BanallByUsername)
end
if energy == 'gbans' then
local list = redis:smembers('GlobalyBanned:')
local t = 'Globaly Ban:\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy == 'clean gbans' then
redis:del('GlobalyBanned:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'• *Gobaly Banned* Has Been Cleared..', 'md')
end
---------------------Unbanall--------------------------------------
if energy and energy:match('^unbanall (%d+)') then
local user = energy:match('unbanall (%d+)')
if tonumber(user) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,'• _ User : _ `'..user..'` *Removed* from `` Globaly Banned..', 'md')
redis:srem('GlobalyBanned:',user)
else
sendText(msg.chat_id, msg.id,  '• `User : ` *'..user..'* is *Not* ` Globaly Banned..!`', 'md')
end
end
if energy and energy:match('^unbanall @(.*)') then
local username = energy:match('^unbanall @(.*)')
function UnbanallByUsername(energy,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if Company.id then
print(''..Company.id..'')
if redis:sismember('GlobalyBanned:', Company.id) then
text = '• _ User : _ `'..Company.id..'` *Removed* from `OwnerLis` Globaly Banned ..!'
redis:srem('GlobalyBanned:',Company.id)
else
text = '• `User : ` *'..user..'* is *Not* ` Globaly Banned..!`'
end
else 
text = '• *User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,UnbanallByUsername)
end
if energy == 'unbanall' then
function UnGbanByReply(energy,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',Company.sender_user_id or 00000000) then
sendText(msg.chat_id, msg.id,'• _ User : _ `'..(Company.sender_user_id or 00000000)..'` *is Removed* From `Globaly Banned`..', 'md')
redis:srem('GlobalyBanned:',Company.sender_user_id or 00000000)
else
sendText(msg.chat_id, msg.id,  '• `User : ` *'..(Company.sender_user_id or 00000000)..'* is *Not* `a Globaly Banned..!`', 'md')
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnGbanByReply)
end
end
if energy == 'پاک کردن اعضا' then 
    function CleanMembers(energy, Company) 
    for k, v in pairs(Company.members) do 
 if tonumber(v.user_id) == tonumber(TD_ID)  then
    return true
    end
KickUser(msg.chat_id,v.user_id)
end
end
print('energy')
getChannelMembers(msg.chat_id,"Recent",0, 2000000,CleanMembers)
sendText(msg.chat_id, msg.id,'• Done\nAll Memers  Has Been Kicked', 'md') 
end 
if energy == 'lock pin' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Pin*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Pin* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if energy == 'unlock pin' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Pin* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Pin*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------
end
if is_Owner(msg) then
if energy == 'پیکربندی' then
if not limit or limit > 200 then
    limit = 200
  end  
local function GetMod(extra,result,success)
local c = result.members
for i=0 , #c do
redis:sadd('ModList:'..msg.chat_id,c[i].user_id)
end
sendText(msg.chat_id,msg.id,"*تمام مدیران گروه به رسمیت شناخته شده اند*!", "md")
end
getChannelMembers(msg.chat_id,'Administrators',0,limit,GetMod)
end
if energy == 'لیست ادمین ها' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = '• ModList\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy and energy:match('^رفع سایلنت (%d+)$') then
local locks =  energy:match('^رفع سایلنت (%d+)$')
if tonumber(locks) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('lockList:'..msg.chat_id,locks)
lock(msg.chat_id, locks,'Restricted',   {0, 0, 0, 0, 0,1})
sendText(msg.chat_id, msg.id,"• _Done_ \n*User* `"..locks.."` *Has Been Unlockd* *\nRestricted*",  'md' )
end
 if energy == 'تنظیم ادمین' then
 function PromoteByReply(energy,Company)
 redis:sadd('ModList:'..msg.chat_id,Company.sender_user_id or 00000000)
 local user = Company.sender_user_id
sendText(msg.chat_id, msg.id, '• User '..(user or 00000000)..' Has Been Promoted','md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if energy == 'رفع ادمین' then
function DemoteByReply(energy,Company)
redis:srem('ModList:'..msg.chat_id,Company.sender_user_id or 00000000)
sendText(msg.chat_id, msg.id, '• User `'..(Company.sender_user_id or 00000000)..'`* Has Been Demoted*', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DemoteByReply)  
end
end
if energy and energy:match('^رفع ادمین @(.*)') then
local username = energy:match('^رفع ادمین @(.*)')
function DemoteByUsername(energy,Company)
if Company.id then
print(''..Company.id..'')
redis:srem('ModList:'..msg.chat_id,Company.id)
text = '• User `'..Company.id..'` Has Been Demoted'
else 
text = '• *User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,DemoteByUsername)
end
--------------------
if energy and energy:match('^تنظیم ادمین @(.*)') then
local username = energy:match('^تنظیم ادمین @(.*)')
function PromoteByUsername(energy,Company)
if Company.id then
print(''..Company.id..'')
redis:sadd('ModList:'..msg.chat_id,Company.id)
text = '• User `'..Company.id..'` Has Been Promoted'
else 
text = '• *User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,PromoteByUsername)
end
----------------------
if energy1 and energy1:match('^تنظیم توضیحات (.*)') then
local description = energy1:match('^تنظیم توضیحات (.*)')
changeDes(msg.chat_id,description)
local text = [[description Has Been Changed To ]]..description
sendText(msg.chat_id, msg.id, text, 'md')
end
if energy1 and energy1:match('^تنظیم نام (.*)') then
local Title = energy1:match('^تنظیم نام (.*)')
local function GetName(energy, Company)
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = Company.title
redis:set(Hash,ChatTitle)
changeChatTitle(msg.chat_id,Title)
local text = [[Group Name Has Been Changed To ]]..Title
sendText(msg.chat_id, msg.id, text, 'md')
end
GetChat(msg.chat_id,GetName)
end
if energy and energy:match('^تنظیم ادمین (%d+)') then
local user = energy:match('تنظیم ادمین (%d+)')
redis:sadd('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '• User `'..user..'`* Has Been Promoted*', 'md')
end
if energy == 'سنجاق' then
sendText(msg.chat_id,msg.reply_to_message_id, '• Msg Has Been Pinned' ,'md')
Pin(msg.chat_id,msg.reply_to_message_id, 1)
end
if energy == 'رفع نجاق' then
sendText(msg.chat_id,msg.id, '• Msg Has Been UnPinned' ,'md')
Unpin(msg.chat_id)
end
if energy and energy:match('^رفع ادمین (%d+)') then
local user = energy:match('رفع ادمین (%d+)')
redis:srem('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '• User `'..user..'`* Has Been Demoted*', 'md')
end
if energy == 'قفل همه' then
redis:set('lockAll:'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'• lock ALL Has Been Enabled' ,'md')
end
if energy == 'بازکردن همه' then
redis:del('lockAll:'..msg.chat_id)
local locks =  redis:smembers('locks:'..msg.chat_id)
for k,v in pairs(locks) do
redis:srem('lockList:'..msg.chat_id,v)
lock(msg.chat_id,v,'Restricted',   {0, 0, 0, 0, 0,0})
end
sendText(msg.chat_id, msg.id,'lock All Has Been Disabled' ,'md')
end
   if energy == 'پاک کردن لیست ادمین ها'  then
redis:del('ModList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '• ModList List Has Been Cleaned', 'md')
end
----
end
----
if is_Mod(msg) then
-----------Delete All-------------
if energy == 'پاک کردن همه پیام ها' then
function DelallByReply(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id, "اوه شت :( \nمن نمیتوانم پیام های خودم را پاک کنم", 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id or 000000000000000000000000000000000000000000000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", 'md')
else
sendText(msg.chat_id, msg.id, '• ALL Message  `'..(Company.sender_user_id or 00000000)..'`* Has Been Deleted*', 'md')
deleteMessagesFromUser(msg.chat_id,Company.sender_user_id or 00000000) 
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DelallByReply)  
end
end
if energy and energy:match('^پاک کردن همه پیام ها @(.*)') then
local username = energy:match('^پاک کردن همه پیام ها @(.*)')
function DelallByUsername(energy,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
  sendText(msg.chat_id, msg.id, "اوه شت :( \nمن نمیتوانم پیام های خودم را پاک کنم", "md")
return false
    end
  if private(msg.chat_id,Company.id or 000000000000000000000000000000000000000000000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", "md")
else
if Company.id then
text= '• ALL Message  `'..Company.id..'`* Has Been Deleted*'
deleteMessagesFromUser(msg.chat_id,Company.id) 
else 
text = '• *User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,DelallByUsername)
end
if energy and energy:match('^پاک کردن همه پیام ها (%d+)') then
local user_id = energy:match('^پاک کردن همه پیام ها (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
  sendText(msg.chat_id, msg.id, "اوه شت :( \nمن نمیتوانم پیام های خودم را پاک کنم", "md")
return false
    end
  if private(msg.chat_id,user_id or 000000000000000000000000000000000000000000000000) then
print '                      Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", "md")   
else
text= '• ALL Message  `'..user_id..'`* Has Been Deleted*'
deleteMessagesFromUser(msg.chat_id,user_id) 
sendText(msg.chat_id, msg.id, text, 'md')
end
end
---------------------------------
if energy == 'لیست ویژه ها' then
local list = redis:smembers('Vip:'..msg.chat_id)
local t = '• Vip Users\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy == 'لیست اخراجی ها' then
local list = redis:smembers('BanUser:'..msg.chat_id)
local t = '• Ban Users\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
  if energy == 'پاک کردن لیست اخراجی ها'  then
local function Clean(energy,Company)
for k,v in pairs(Company.members) do
redis:del('BanUser:'..msg.chat_id)
RemoveFromBanList(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  '• All User Banned Has Been Cleaned From BanList', 'md')
getChannelMembers(msg.chat_id, "Banned", 0, 100000000000,Clean)
end
 if energy == 'پاک کردن لیست سایلنت'  then
local lock = redis:smembers('lockList:'..msg.chat_id)
for k,v in pairs(lock) do
redis:del('lockList:'..msg.chat_id)
lock(msg.chat_id, v,'Restricted',   {1, 1, 0, 0, 0,0})
end
sendText(msg.chat_id, msg.id,  '• All User lockd Has Been Cleaned From lockList', 'md')
end
if energy == 'پاک کردن ربات ها'  then
local function CleanBot(energy,Company)
for k,v in pairs(Company.members) do
if tonumber(v.user_id) == tonumber(TD_ID) then
return false
end
 if private(msg.chat_id,v.user_id or 000000000000000000000000000000000000000000000000) then
print '                      Private                          '
else
end
KickUser(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  '• All Bots Banned Has Been Kicked', 'md')
getChannelMembers(msg.chat_id, "Bots", 0, 100000000000,CleanBot)
end
if energy == 'تنظیم ویژه' then
function SetVipByReply(energy,Company)
if redis:sismember('Vip:'..msg.chat_id, Company.sender_user_id or 00000000) then
sendText(msg.chat_id, msg.id,  '• `User : ` *'..(Company.sender_user_id or 00000000)..'* is *Already* `a VIP member..!`', 'md')
else
sendText(msg.chat_id, msg.id,'• _ User : _ `'..(Company.sender_user_id or 00000000)..'` *Promoted* to `VIP` member..', 'md')
redis:sadd('Vip:'..msg.chat_id, Company.sender_user_id or 00000000)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetVipByReply)
end
if energy and energy:match('^تنظیم ویژه @(.*)') then
local username = energy:match('^تنظیم ویژه @(.*)')
function SetVipByUsername(energy,Company)
if Company.id then
print('SetVip\nBy : '..msg.sender_user_id..'\nUser : '..Company.id..'\nUserName : '..username)
if redis:sismember('Vip:'..msg.chat_id,Company.id) then
text=  '• `User : ` *'..Company.id..'* is *Already* `a VIP member..!`'
else
text ='• _ User : _ `'..Company.id..'` *Promoted* to `VIP` member..'
redis:sadd('Vip:'..msg.chat_id, Company.id)
end
else 
text = '• *User NotFound*'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,SetVipByUsername)
end 
  if energy == 'پاک کردن لیست ویژه ها'  then
redis:del('Vip:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '• Vip List Has Been Cleaned', 'md')
end
if energy == 'remvip' then
function RemVipByReply(energy,Company)
if redis:sismember('Vip:'..msg.chat_id, Company.sender_user_id or 00000000) then
sendText(msg.chat_id, msg.id,'• _User : _ `'..(Company.sender_user_id or 00000000)..'` *Demoted From VIP Member..*', 'md')
redis:srem('Vip:'..msg.chat_id, Company.sender_user_id or 00000000)
else
sendText(msg.chat_id, msg.id,  '• `User : ` *'..(Company.sender_user_id or 00000000)..'* `Not VIP Member..!`', 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemVipByReply)
end

if energy and energy:match('^سایلنت (%d+)$') then
local lockss = energy:match('^سایلنت (%d+)$') 
if tonumber(lockss) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,lockss) then
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
lock(msg.chat_id, lockss,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('lockList:'..msg.chat_id,lockss)
sendText(msg.chat_id, msg.id,"• *Done User* `"..lockss.."` *Has Been  locked :) \nRestricted*",  'md' )
end
end
if energy1 and energy1:match('^(تنظیم فلود) (.*)$') then
local status = {string.match(energy, "^(تنظیم فلود) (.*)$")}
if status[2] == 'kickuser' then
redis:set("Flood:Status:"..msg.chat_id,'kickuser') 
sendText(msg.chat_id, msg.id, '*Flood mode is set to* _Kickuser_', 'md')
end
if status[2] == 'lockuser' then
redis:set("Flood:Status:"..msg.chat_id,'lockuser') 
sendText(msg.chat_id, msg.id, '*Flood mode is set to* _lockuser_', 'md')
end
end
if energy == 'سایلنت' then
local function Restricted(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id or 00000000) then
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
lock(msg.chat_id, Company.sender_user_id or 00000000,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('lockList:'..msg.chat_id,Company.sender_user_id or 00000000)
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "• Done User "..Company.sender_user_id.." Has Been  locked", 12,string.len(Company.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if energy == 'رفع سایلنت' then
function Restricted(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('lockList:'..msg.chat_id,Company.sender_user_id or 00000000)
lock(msg.chat_id,Company.sender_user_id or 00000000,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "• Done User "..Company.sender_user_id.." Has Been  Unlocked", 12,string.len(Company.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if energy and energy:match('^رفع سایلنت (%d+)$') then
local locks =  energy:match('^رفع سایلنت (%d+)$')
if tonumber(locks) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('lockList:'..msg.chat_id,locks)
lock(msg.chat_id, locks,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "• Done User "..Company.sender_user_id.." Has Been  Unlocked", 12,string.len(Company.sender_user_id))
end
if energy == 'تنظیم لینک'  and tonumber(msg.reply_to_message_id) > 0 then
function GeTLink(energy,Company)
local getlink = Company.content.text or Company.content.caption
for link in getlink:gmatch("(https://t.me/joinchat/%S+)") or getlink:gmatch("t.me", "telegram.me") do
redis:set('Link:'..msg.chat_id,link)
print(link)
end
sendText(msg.chat_id, msg.id,"Done ! ",  'md' )
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GeTLink)
end
if energy == 'رفع لینک' then
redis:del('Link:'..msg.chat_id)
sendText(msg.chat_id, msg.id,"Link Removed ",  'md' )
end
if energy == 'مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function BanByReply(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را محدود کنم",  'md' )
return false
end
  if private(msg.chat_id,Company.sender_user_id or 00000000) then
print '                     Private                          '
  sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
    else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "• User "..(Company.sender_user_id or 021).." Has Been Banned", 7,string.len(Company.sender_user_id))
redis:sadd('BanUser:'..msg.chat_id,Company.sender_user_id or 00000000)
KickUser(msg.chat_id,Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BanByReply)
end
  if energy == 'پاک کردن لیست فیلتر'  then
redis:del('Filters:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '• Filter List Has Been Cleaned', 'md')
end
if energy == 'لیست فیلتر' then
local list = redis:smembers('Filters:'..msg.chat_id)
local t = '• Filters \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
if #list == 0 then
t = '• The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy == 'لیست سایلنت' then
local list = redis:smembers('lockList:'..msg.chat_id)
local t = '• lock List \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #list == 0 then
t = 'The list is empty'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy == 'پاک کردن لیست اخطار' then
redis:del(msg.chat_id..':warn')
sendText(msg.chat_id, msg.id,'Warn List Has Been Cleaned', 'md')
end
if energy == "لیست اخطار" then
local comn = redis:hkeys(msg.chat_id..':warn')
local t = 'Warn Users List:\n'
for k,v in pairs (comn) do
local cont = redis:hget(msg.chat_id..':warn', v)
t = t..k..'- '..v..' Warn : '..(cont - 1)..'\n'
end
t = t.."\n\n• To see the user's from command under use!\nwhois ID\nExample ! \nwhois 363936960"
if #comn == 0 then
t = 'The list is empty'
end 
sendText(msg.chat_id, msg.id,t, 'md')
end
if energy and energy:match('^رفع مسدود (%d+)') then
local user_id = energy:match('^رفع مسدود (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
SendMetion(msg.chat_id,user_id, msg.id, "• User "..(user_id or 021).." Has Been UnBanned", 7,string.len(user_id))
end
if energy and energy:match('^مسدود (%d+)') then
local user_id = energy:match('^مسدود (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را مسدود کنم",  'md' )
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
else
redis:sadd('BanUser:'..msg.chat_id,user_id)
KickUser(msg.chat_id,user_id)
sendText(msg.chat_id, msg.id, '• User `'..user_id..'` Has Been Banned ..!*', 'md')
SendMetion(msg.chat_id,user_id, msg.id, "• User "..(user_id or 021).." Has Been Banned", 7,string.len(user_id))
end
end
if energy and energy:match('^رفع مسدود @(.*)') then
local username = energy:match('رفع مسدود @(.*)')
function UnBanByUserName(energy,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if Company.id then
print('UserID : '..Company.id..'\nUserName : @'..username)
redis:srem('BanUser:'..msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, "• User "..(Company.id or 021).." Has Been UnBanned", 7,string.len(Company.id))
else 
sendText(msg.chat_id, msg.id, '• User Not Found',  'md')

end
print('Send')
end
resolve_username(username,UnBanByUserName)
end
if energy == 'رفع مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function UnBan_by_reply(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,Company.sender_user_id or 00000000)
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "• User "..(Company.sender_user_id or 021).." Has Been UnBanned", 7,string.len(Company.sender_user_id))
RemoveFromBanList(msg.chat_id,Company.sender_user_id)
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnBan_by_reply)
end
if energy and energy:match('^مسدود @(.*)') then
local username = energy:match('^مسدود @(.*)')
print '                     Private                          '
function BanByUserName(energy,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را مسدود کنم",  'md' )
return false
end
if private(msg.chat_id,Company.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
else
if Company.id then
redis:sadd('BanUser:'..msg.chat_id,Company.id)
KickUser(msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, "• User "..(Company.id or 021).." Has Been Banned", 7,string.len(Company.id))
else 
t = '• User Not Found'
sendText(msg.chat_id, msg.id, t,  'md')
end
end
end
resolve_username(username,BanByUserName)
end
if energy== 'اخراج' and tonumber(msg.reply_to_message_id) > 0 then
function kick_by_reply(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,Company.sender_user_id or 000000000000000000000000000000000000000000000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "• User "..(Company.sender_user_id or 021).." Has Been Kicked", 7,string.len(Company.sender_user_id))
KickUser(msg.chat_id,Company.sender_user_id)
RemoveFromBanList(msg.chat_id,Company.sender_user_id)
 end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),kick_by_reply)
end
if energy and energy:match('^اخراج @(.*)') then
local username = energy:match('^اخراج @(.*)')
function KickByUserName(energy,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,Company.id or 000000000000000000000000000000000000000000000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
if Company.id then
KickUser(msg.chat_id,Company.id)
RemoveFromBanList(msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, "• User "..(Company.id or 021).." Has Been Kicked", 7,string.len(Company.id))
else 
txtt = '• User Not Found'
sendText(msg.chat_id, msg.id,txtt,  'md')
end
end
end
resolve_username(username,KickByUserName)
end
if energy == 'پاک کردن لیست مسدودین' then
local function pro(arg,data)
if redis:get("Check:Restricted:"..msg.chat_id) then
text = 'هر 5دقیقه یکبار ممکن است'
end
for k,v in pairs(data.members) do
redis:del('lockAll:'..msg.chat_id)
 lock(msg.chat_id, v.user_id,'Restricted',    {1, 1, 1, 1, 1,1})
   redis:setex("Check:Restricted:"..msg.chat_id,350,true)
end
end
getChannelMembers(msg.chat_id,"Recent", 0, 100000000000,pro)
sendText(msg.chat_id, msg.id,'افراد محدود پاک شدند • ' ,'md')
end 
if energy and energy:match('^اخراج (%d+)') then
local user_id = energy:match('^اخراج (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"اوه شت :( \nمن نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,user_id or 000000000000000000000000000000000000000000000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
KickUser(msg.chat_id,user_id)
text= '• User '..user_id..' Has Been Kicked'
SendMetion(msg.chat_id,user_id, msg.id, text,7, string.len(user_id))
RemoveFromBanList(msg.chat_id,user_id)
end
end
if energy and energy:match('^تنظیم فلود (%d+)') then
local num = energy:match('^تنظیم فلود (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '• `Select a number greater than` *2*','md')
else
redis:set('Flood:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• `Flood Sensitivity Has Been Set to` *'..num..'*', 'md')
end
end
if energy and energy:match('^تنظیم اخطار (%d+)') then
local num = energy:match('^تنظیم اخطار (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '• `Select a number greater than` *2*','md')
else
redis:set('Warn:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• `Max Warn Has Been Set to` *'..num..'*', 'md')
end
end
if energy and energy:match('^تنظیم اسپم (%d+)') then
local num = energy:match('^تنظیم اسپم (%d+)')
if tonumber(num) < 40 then
sendText(msg.chat_id, msg.id, '• `Select a number greater than` *40*','md')
else
if tonumber(num) > 4096 then
sendText(msg.chat_id, msg.id, '• `Select a number Smaller than` * 4096 * ','md')
else
redis:set('NUM_CH_MAX:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• `Spam` *Sensitivity* `has been set to ` *'..num..'*', 'md')
end
end
end
if energy and energy:match('^تنظیم زمان فلود (%d+)') then
local num = energy:match('^تنظیم زمان فلود (%d+)')
if tonumber(num) < 1 then
sendText(msg.chat_id, msg.id, '• `Select a number greater than` *1*','md')
else
redis:set('Flood:Time:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '• `Flood time change to` *'..num..'*', 'md')
end
end
if energy and energy:match('^پاک کردن (%d+)$') then
local limit = tonumber(energy:match('^پاک کردن (%d+)$'))
if limit > 100 then
sendText(msg.chat_id, msg.id, '*عددی بین * [`1-100`] را انتخاب کنید', 'md')
else
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
end
end
getChatHistory(msg.chat_id,msg.id, 0,  limit,cb)
sendText(msg.chat_id, msg.id, '• ('..limit..') Msg Has Been Deleted', 'md')
end
end
if energy == 'تنظیمات' then
local function GetName(energy, Company)
local chat = msg.chat_id
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
welcome = '【✓】'
else
welcome = '【✘】'
end
if redis:get('Lock:Edit'..chat) then
edit = '【✓】'
else
edit = '【✘】'
end
if redis:get('Lock:Link'..chat) then
Link = '【✓】'
else
Link = '【✘】' 
end
if redis:get('Lock:Tag:'..chat) then
tag = '【✓】'
else
tag = '【✘】' 
end
if redis:get('Lock:HashTag:'..chat) then
hashtag = '【✓】'
else
hashtag = '【✘】' 
end
if redis:get('Lock:Video_note:'..chat) then
video_note = '【✓】'
else
video_note = '【✘】' 
end
if redis:get('Lock:Inline:'..chat) then
inline = '【✓】'
else
inline = '【✘】' 
end
if redis:get("Flood:Status:"..msg.chat_id) then
if redis:get("Flood:Status:"..msg.chat_id) == "kickuser" then
Status = 'Kick User'
elseif redis:get("Flood:Status:"..msg.chat_id) == "lockuser" then
Status = 'lock User'
end
else
Status = 'Not Set'
end
if redis:get('Lock:Pin:'..chat) then
pin = '【✓】'
else
pin = '【✘】' 
end
if redis:get('Lock:Forward:'..chat) then
fwd = '【✓】'
else
fwd = '【✘】' 
end
if redis:get('Lock:Bot:'..chat) then
bot = '【✓】'
else
bot = '【✘】' 
end
if redis:get('Spam:Lock:'..chat) then
spam = '【✓】'
else
spam = '【✘】' 
end
if redis:get('Lock:Arabic:'..chat) then
arabic = '【✓】'
else
arabic = '【✘】' 
end
if redis:get('Lock:English:'..chat) then
en = '【✓】'
else
en = '【✘】' 
end
if redis:get('Lock:TGservise:'..chat) then
tg = '【✓】'
else
tg = '【✘】' 
end
if redis:get('Lock:Sticker:'..chat) then
sticker = '【✓】'
else
sticker = '【✘】' 
end
if redis:get('CheckBot:'..msg.chat_id) then
TD = '【✓】'
else
TD = '【✘】'
end
-------------------------------------------
---------lock Settings----------------------
if redis:get('lock:Text:'..msg.chat_id) then
txts = '【✓】'
else
txts = '【✘】'
end
if redis:get('lock:Contact:'..msg.chat_id) then
contact = '【✓】'
else
contact = '【✘】'
end
if redis:get('lock:Document:'..msg.chat_id) then
document = '【✓】'
else
document = '【✘】'
end
if redis:get('lock:Location:'..msg.chat_id) then
location = '【✓】'
else
location = '【✘】'
end
if redis:get('lock:Voice:'..msg.chat_id) then
voice = '【✓】'
else
voice = '【✘】'
end
if redis:get('lock:Photo:'..msg.chat_id) then
photo = '【✓】'
else
photo = '【✘】'
end
if redis:get('lock:Game:'..msg.chat_id) then
game = '【✓】'
else
game = '【✘】'
end
if redis:get('lockAll:'..chat) then
lockall = '【✓】'
else
lockall = '【✘】' 
end
if redis:get('Lock:Flood:'..msg.chat_id) then
flood = '【✓】'
else
flood = '【✘】'
end
if redis:get('lock:Video:'..msg.chat_id) then
video = '【✓】'
else
video = '【✘】'
end
if redis:get('lock:Music:'..msg.chat_id) then
music = '【✓】'
else
music = '【✘】'
end
if redis:get('lock:Gif:'..msg.chat_id) then
gif = '【✓】'
else
gif = '【✘】'
end
local expire = redis:ttl("ExpireData:"..msg.chat_id)
if expire == -1 then
EXPIRE = "نامحدود"
else
local d = math.floor(expire / day ) + 1
EXPIRE = d.."  Day"
end
------------------------More Settings-------------------------
local Text = '•• `TG persian new energy`••\n••تنظیمات برای گروه•• : `'..Company.title..'`\n┑》وضعیت ربات `'..TD.."\n┥》_قفل لینک ↫"..Link.."\n┥》_قفل ویرایش ↫"..edit.."\n┥》_قفل تگ ↫"..tag.."\n┥》_قفل هشتگ ↫"..hashtag.."\n┥》_قفل اینلاین ↫"..inline.."\n┥》_قفل ویدیونات ↫"..video_note.."\n┥》_قفل سنجاق ↫"..pin.."\n┥》_قفل ربات ↫"..bot.."\n┥》_قفل فوروارد ↫"..fwd.."\n┥》_قفل عربی ↫"..arabic.."\n┥》_قفل انگلیسی ↫"..en.."\n┥》_قفل اعلانات ↫"..tg.."\n┥》_قفل استیکر ↫"..sticker.."\n┥》_قفل عکس ↫"..photo.."\n┥》_قفل موزیک ↫"..music.."\n┥》_قفل ویس ↫"..voice.."\n┥》_قفل فایل ↫"..document.."\n┥》_قفل ویدیو ↫"..video.."\n┥》_قفل بازی ↫"..game.."\n┥》_قفل مکان ↫"..location.."\n┥》_قفل مخاطب ↫"..contact.."\n┥》_قفل متن ↫"..txts.."\n┥》_قفل همه ↫"..lockall.."\n┥》_قفل اسپم ↫"..spam.."\n┥》_قفل فلود ↫"..flood.."\n┥》_امار فلود ↫"..Status.."\n┥》_تعداد فلود رگبار ↫"..NUM_MSG_MAX.."\n┥》_تعداد کاراکتر اسپم ↫"..NUM_CH_MAX.."\n┥》_مقدار زمان فلود ↫"..TIME_CHECK.."\n┥》_تعداد اخطار ها ↫"..warn.."\n┥》_اعتبار گروه ↫"..EXPIRE.."\n┙》_خوشامدگویی ↫"..welcome..'`'
sendText(msg.chat_id, msg.id, Text, 'md')
end
GetChat(msg.chat_id,GetName)
end
--------------------Welcome----------------------
if energy == 'خوشامد فعال' then
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
sendText(msg.chat_id, msg.id,'• *Welcome* is _Already_ Enable\n\n' ,'md')
else
sendText(msg.chat_id, msg.id,'• *Welcome* Has Been Enable\n\n' ,'md')
redis:del('Welcome:'..msg.chat_id,'disable')
redis:set('Welcome:'..msg.chat_id,'enable')

end
end
if energy == 'خوشامد غیرفعال' then
if redis:get('Welcome:'..msg.chat_id) then
sendText(msg.chat_id, msg.id,'• *Welcome* Has Been Disable\n\n' ,'md')
redis:set('Welcome:'..msg.chat_id,'disable')
redis:del('Welcome:'..msg.chat_id,'enable')
else
sendText(msg.chat_id, msg.id,'• *Welcome* is _Already_ Disable\n\n' ,'md')
end
end
---------------------------------------------------------
-----------------------------------------------Locks------------------------------------------------------------
-----------------Lock Link--------------------
if energy == 'قفل لینک' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Link*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Link* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Link'..msg.chat_id,true)
end
end
if energy == 'بازکردن لینک' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Link* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Link'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Link*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------
if energy == 'قفل تگ' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Tag*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Tag* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Tag:'..msg.chat_id,true)
end
end
if energy == 'بازکردن تگ' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Tag* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Tag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Tag*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
if energy == 'قفل هشتگ' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *HadshTag*  is _Already_ `Enable`\n\n' , 'md')
else 
sendText(msg.chat_id, msg.id, '• `Lock` *HashTag* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:HashTag:'..msg.chat_id,true)
end
end
if energy == 'بازکردن هشتگ' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *HashTag* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:HashTag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *HashTag*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if energy == 'قفل ویدیونات' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Video note*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Video note* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Video_note:'..msg.chat_id,true)
end
end
if energy == 'بازکردن ویدیونات' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Video note* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Video_note:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Video note*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------------
if energy == 'قفل اسپم' then
if redis:get('Spam:Lock:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Spam*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Spam* `Has Been Enable`\n\n' , 'md')
redis:set('Spam:Lock:'..msg.chat_id,true)
end
end
if energy == 'بازکردن اسپم' then
if redis:get('Spam:Lock:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Spam* `Has Been Disable`\n\n' , 'md')
redis:del('Spam:Lock:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Spam*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------
if energy == 'قفل اینلاین' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Inline*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Inline* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Inline:'..msg.chat_id,true)
end
end
if energy == 'بازکردن اینلاین' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Inline* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Inline:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Inline*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if energy == 'قفل سنجاق' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Pin*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Pin* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if energy == 'بازکردن سنجاق' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Pin* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Pin*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if energy == 'قفل فلود' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Flood*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Flood* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Flood:'..msg.chat_id,true)
end
end
if energy == 'بازکردن فلود' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Flood* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Flood:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Flood*  is _Already_  `Disable`\n\n' , 'md')
end
end
----------------------------------------------
if energy == 'قفل فوروارد' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Forward:'..msg.chat_id,true)
end
end
if energy == 'بازکردن فوروارد' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Forward* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Forward:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_  `Disable`\n\n' , 'md')
end
end
------------------------------------------------
if energy == 'قفل عربی' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Arabic:'..msg.chat_id,true)
end
end
if energy == 'قفل ربات' then
if redis:get('Lock:Bot:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Bot*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Bot* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Bot:'..msg.chat_id,true)
end
end
if energy == 'بازکردن عربی' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Arabic* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Arabic:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_  `Disable`\n\n' , 'md')
end
end
if energy == 'بازکردن ربات'then
if redis:get('Lock:Bot:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Bot* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Bot:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Bot*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
if energy == 'قفل ویرایش' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Edit*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Edit* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Edit'..msg.chat_id,true)
end
end
if energy == 'بازکردن ویرایش' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Edit* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Edit'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Edit*  is _Already_  `Disable`\n\n' , 'md')
end
end
-----------------------------------------------
if energy == 'قفل انگلیسی' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *English*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *English* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:English:'..msg.chat_id,true)
end
end
if energy == 'بازکردن انگلیسی' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *English* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:English:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
if energy == 'قفل اعلانات' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *TGservise*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *TGservise* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:TGservise:'..msg.chat_id,true)
end
end
if energy == 'بازکردن اعلانات' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *TGservise* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:TGservise:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_  `Disable`\n\n' , 'md')
end
end
-------------------------------------------
if energy == 'قفل استیکر' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker* `Has Been Enable`\n\n' , 'md')
redis:set('Lock:Sticker:'..msg.chat_id,true)
end
end
if energy == 'بازکردن استیکر' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Sticker* `Has Been Disable`\n\n' , 'md')
redis:del('Lock:Sticker:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `Lock` *Forward*  is _Already_  `Disable`\n\n' , 'md')
end
end
--------------------------------------------
-------------------------locks-----------------------------------------
if energy == 'قفل متن' then
if redis:get('lock:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `Lock` *Text*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `Lock` *Text* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Text:'..msg.chat_id,true)
end
end
if energy == 'بازکردن متن' then
if redis:get('lock:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Text* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Text:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Text*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل مخاطب' then
if redis:get('lock:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Contact*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Contact* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Contact:'..msg.chat_id,true)
end
end
if energy == 'بازکردن مخاطب' then
if redis:get('lock:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Contact* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Contact:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Contact*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل فایل' then
if redis:get('lock:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Document*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Document* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Document:'..msg.chat_id,true)
end
end
if energy == 'بازکردن فایل' then
if redis:get('lock:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Document* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Document:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Document*  is _Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل مکان' then
if redis:get('lock:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Location*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Location* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Location:'..msg.chat_id,true)
end
end
if energy == 'بازکردن مکان' then
if redis:get('lock:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Location* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Location:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Location*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل ویس' then
if redis:get('lock:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Voice*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Voice* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Voice:'..msg.chat_id,true)
end
end
if energy == 'بازکردن ویس' then
if redis:get('lock:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Voice* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Voice:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Voice*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل عکس' then
if redis:get('lock:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Photo*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Photo* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Photo:'..msg.chat_id,true)
end
end
if energy == 'بازکردن عکس' then
if redis:get('lock:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Photo* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Photo:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Photo*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل بازی' then
if redis:get('lock:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Game*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Game* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Game:'..msg.chat_id,true)
end
end
if energy == 'بازکردن بازی' then
if redis:get('lock:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Game* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Game:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Game*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل ویدیو' then
if redis:get('lock:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Video*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Video* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Video:'..msg.chat_id,true)
end
end
if energy == 'بازکردن ویدیو' then
if redis:get('lock:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Video* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Video:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Video*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل موزیک' then
if redis:get('lock:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Music*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Music* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Music:'..msg.chat_id,true)
end
end
if energy == 'بازکردن موزیک' then
if redis:get('lock:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Music* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Music:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Music*  _is Already_  `Disable`\n\n' , 'md')
end
end
---------------------------------------------------------------------------------
if energy == 'قفل گیف' then
if redis:get('lock:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Gif*  is _Already_ `Enable`\n\n' , 'md')
else
sendText(msg.chat_id, msg.id, '• `lock` *Gif* `Has Been Enable`\n\n' , 'md')
redis:set('lock:Gif:'..msg.chat_id,true)
end
end
if energy == 'بازکردن گیف' then
if redis:get('lock:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '• `lock` *Gif* `Has Been Disable`\n\n' , 'md')
redis:del('lock:Gif:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '• `lock` *Gif*  _is Already_  `Disable`\n\n' , 'md')
end
end
-----------End locks---------------
----------------------------------------------------------------------------------
-----------End locks---------------
----------------------------------------------------------------------------------
if energy1 and energy1:match('^تنظیم لینک (.*)') then
local link = energy1:match('^تنظیم لینک (.*)')
redis:set('Link:'..msg.chat_id,link)
sendText(msg.chat_id, msg.id,'• *New Link Has Been Seted*\n\n', 'md')
end
if energy1 and energy1:match('^تنظیم ولکام (.*)') then
local wel = energy1:match('^تنظیم ولکام (.*)')
redis:set('Text:Welcome:'..msg.chat_id,wel)
sendText(msg.chat_id, msg.id,'• *New Welcome Has Been Seted*\n\n', 'md')
end
if energy1 and energy1:match('^تنظیم قوانین (.*)') then
local rules = energy1:match('^تنظیم قوانین (.*)')
redis:set('Rules:'..msg.chat_id,rules)
sendText(msg.chat_id, msg.id,'• *New rules Has Been Seted*\n\n', 'md')
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
if energy and energy:match('^فیلتر +(.*)') then
local word = energy:match('^فیلتر +(.*)')
redis:sadd('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id, '• `'..word..'` *Added To BadWord List!*', 'md')
end

if energy and energy:match('^رفع فیلتر +(.*)') then
local word = energy:match('^رفع فیلتر +(.*)')
redis:srem('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id,'• `'..word..'` *Removed From BadWord List!*', 'md')
end
if energy == "اخطار" and tonumber(msg.reply_to_message_id) > 0 then
function WarnByReply(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id or 00000000) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "اوه شت :(\nمن نمیتوانم به یک فرد دارای مقام اخطار بدهم", 'md')
else
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',(Company.sender_user_id or 00000000)) or 1
if tonumber(warnhash) == tonumber(warn) then
KickUser(msg.chat_id,Company.sender_user_id)
RemoveFromBanList(msg.chat_id,Company.sender_user_id)
text= "User  *"..(Company.sender_user_id or 00000000).."* has been *kicked because max warning \nNumber of warn :*"..warnhash.."/"..warn..""
redis:hdel(hashwarn,Company.sender_user_id, '0')
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 7, string.len(Company.sender_user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',(Company.sender_user_id or 00000000)) or 1
 redis:hset(hashwarn,Company.sender_user_id, tonumber(warnhash) + 1)
text= "کاربر  "..(Company.sender_user_id or '0000Null0000').." شما یک اخطار دریافت کردید\nتعداد اخطار های شما : "..warnhash.."/"..warn..""
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 7, string.len(Company.sender_user_id))
end
end
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),WarnByReply)
end
if energy == "رفع اخطار" and tonumber(msg.reply_to_message_id) > 0 then
function UnWarnByReply(energy,Company)
if tonumber(Company.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  'اوه شت :( \nمن نمیتوانم پیام خودم را چک کنم', 'md')
    return false
    end
  if private(msg.chat_id,Company.sender_user_id or 00000000) then
print '                     Private                          '
    else
local warnhash = redis:hget(msg.chat_id..':warn',(Company.sender_user_id or 00000000)) or 1
if tonumber(warnhash) == tonumber(1) then
text= "کاربر  *"..Company.sender_user_id.."* هیچ اخطاری ندارد"
sendText(msg.chat_id, msg.id, text, 'md')
else
local warnhash = redis:hget(msg.chat_id..':warn',(Company.sender_user_id or 00000000))
 local hashwarn = msg.chat_id..':warn'
 redis:hdel(hashwarn,(Company.sender_user_id or 00000000),'0')
if Company.username then
    user_name = '@'..check_markdown(Company.username)
       else
    user_name = ec_name(Company.first_name)
   end
text= "کاربر   "..(Company.sender_user_id or '0000Null0000').." تمام اخطار های شما پاک شد "
sendText(msg.chat_id, msg.id, text, 'md')
end
 end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnWarnByReply)
end
------
end
------
if redis:get('CheckBot:'..msg.chat_id) then
if energy and energy:match('^ایدی @(.*)') then
local username = energy:match('^ایدی @(.*)')
 function IdByUserName(energy,Company)
if Company.id then
text = '• energy Company\n\nUser ID : ['..Company.id..']\n\n'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,IdByUserName)
 end

if energy == 'ایدی' then
function GetID(energy, Company)
 local user = Company.sender_user_id
local text = 'energy Company\n'..Company.sender_user_id
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 16, string.len(Company.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GetID)
end
end
if energy and energy:match('^پروفایل (%d+)') then
local offset = tonumber(energy:match('^پروفایل (%d+)'))
if offset > 50 then
sendText(msg.chat_id, msg.id,'اوه شت :( \n من بیشتر از 50 عکس پروفایل شما را نمیتوانم ارسال کنم • ','md')
elseif offset < 1 then
sendText(msg.chat_id, msg.id, 'لطفا عددی بزرگتر از 0  بکار ببرید • ', 'md')
else
function GetPro1(energy, Company)
 if Company.photos[0] then
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, Company.photos[0].sizes[2].photo.persistent_id,'• Total Profile Photos : '..Company.total_count..'\n• Photo Size : '.. Company.photos[0].sizes[2].photo.size)
else
sendText(msg.chat_id, msg.id, 'شما عکس پروفایل '..offset..' ندارید', 'md')
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = msg.sender_user_id, offset = offset-1, limit = 100000000000000000000000 },GetPro1, nil)
end
end
if energy and energy:match('^مشخصات (%d+)') then
local id = tonumber(energy:match('^مشخصات (%d+)'))
local function Whois(energy,Company)
 if Company.first_name then
local username = ec_name(Company.first_name)
SendMetion(msg.chat_id,Company.id, msg.id,username,0,utf8.len(username))

else
sendText(msg.chat_id, msg.id,'*User  ['..id..'] Not Found*','md')
end
end
GetUser(id,Whois)
end
 if energy == "ایدی"  then 
if tonumber(msg.reply_to_message_id) == 0  then 
 function GetPro(energy, Company)
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..(msg.sender_user_id or 00000000))
if is_sudo(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Sudo")..'' 
elseif is_Owner(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Owner")..'' 
elseif is_Mod(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "ADMIN")..''
elseif is_Vip(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "VIP")..''
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
 if Company.photos[0] then
print('persistent_id : '..Company.photos[0].sizes[2].photo.persistent_id)  
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, Company.photos[0].sizes[2].photo.persistent_id,'• energy Company\n\nChat ID : ['..msg.chat_id..']\nUser ID : ['..msg.sender_user_id..']\nRank : ['..rank..']\nTotal Msgs : '..Msgs..'\nTD ID : '..TD_ID..'\n')
else
sendText(msg.chat_id, msg.id,  '• `energy Company`!!\n\nChat ID : ['..msg.chat_id..']\nUser ID : ['..msg.sender_user_id..']\nRank : ['..rank..']\nTotal Msgs : '..Msgs..'\nTD ID : '..TD_ID..'\n', 'md')
print '                      Not Photo                      ' 
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = (msg.sender_user_id or 00000000), offset =0, limit = 100000000 },GetPro, nil)
end
end

if energy == 'من' then
local function GetName(energy, Company)
if is_sudo(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Sudo")..'' 
elseif is_Owner(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Owner")..'' 
elseif is_Mod(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "ADMIN")..''
elseif is_Vip(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "VIP")..''
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
if Company.first_name then
CompanyName = ec_name(Company.first_name)
else  
CompanyName = '\n\n'
end

Msgs = redis:get('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
sendText(msg.chat_id, msg.id,  '• `energy Company!!`\n\n• Your Name : ['..CompanyName..']\n• User ID : ['..msg.sender_user_id..']\n• Rank : ['..rank..']\n• Total Msgs : ['..Msgs..']\n','md')
end
GetUser(msg.sender_user_id,GetName)
end
if energy == 'درباره من' then
function GetName(extra, result, success) 
if result.about then
CompanyName = result.about
else  
CompanyName = 'nil\n\n'
end
if result.common_chat_count  then
Companycommon_chat_count  = result.common_chat_count 
else 
Companycommon_chat_count  = 'nil'
end
sendText(msg.chat_id, msg.id,  '• `energy Company`!!\n\n• Bio : ['..CompanyName..']\n\nCommon chat count : ['..Companycommon_chat_count..']', 'md')
end
GetUserFull(msg.sender_user_id,GetName)
end
if energy == 'مشخصات گروه' then
 local function FullInfo(energy,Company)
sendText(msg.chat_id, msg.id,'*SuperGroup Info :*\n`SuperGroup ID :`*'..msg.chat_id..'*\n`Total Admins :` *'..Company.administrator_count..'*\n`Total Banned :` *'..Company.banned_count..'*\n`Total Members :` *'..Company.member_count..'*\n`About Group :` *'..Company.description..'*\n`Link : `*'..Company.invite_link..'*\n`Total Restricted : `*'..Company.restricted_count..'*', 'md')
end
getChannelFull(msg.chat_id,FullInfo)
end

-------------------------------
end
if energy == 'لینک' then
local link = redis:get('Link:'..msg.chat_id) 
if link then
sendText(msg.chat_id,msg.id,  '• *Group Link:*\n'..link..'\n\n', 'md')
else
sendText(msg.chat_id, msg.id, '• *Link Not Set*\n\n', 'md')
end
end
if energy == 'قوانین' then
local rules = redis:get('Rules:'..msg.chat_id) 
if rules then
sendText(msg.chat_id,msg.id,  '• *Group Rules:*\n'..rules..'\n\n', 'md')
else
sendText(msg.chat_id, msg.id, '• *Rules Not Set*\n\n', 'md')
end
end
if energy == 'بازی' then

local games = {'Corsairs','LumberJack','MathBattle'}
sendGame(msg.chat_id, msg.id, 166035794, games[math.random(#games)])
end
if energy == 'انلاینی' then
txts = [[✅آره انلاینم....

]]
sendText(msg.chat_id, msg.id, txts, 'md')
end
if energy == 'راهنما' then
if is_sudo(msg) then
text =[[🗂راهنمای کامل ربات
➖➖➖➖➖➖➖
┑》_قفل لینک 
┙》_بازکردن لینک

┑》_قفل تگ
┙》_بازکردن تگ

┑》_قفل ویرایش
┙》_بازکردن ویرایش

┑》_قفل مکان
┙》_بازکردن مکان

┑》_قفل عربی
┙》_بازکردن عربی

┑》_قفل ربات
┙》_بازکردن ربات 

┑》_قفل اسپم
┙》_بازکردن اسپم

┑》_قفل فلود
┙》_بازکردن فلود 

┑》_قفل ویدیونات
┙》_بازکردن ویدیونات

┑》_قفل گیف
┙》_بازکردن گیف

┑》_قفل عکس
┙》_بازکردن عکس

┑》_قفل هشتگ
┙》_بازکردن هشتگ

┑》_قفل سنجاق
┙》_بازکردن سنجاق

┑》_قفل فایل
┙》_بازکردن فایل

┑》_قفل استیکر
┙》_بازکردن استیکر

┑》_قفل فیلم 
┙》_بازکردن فیلم

┑》_قفل متن
┙》_بازکردن متن

┑》_قفل فوروارد
┙》_بازکردن فوروارد

┑》_قفل ویس
┙》_بازکردن ویس

┑》_قفل موزیک
┙》_بازکردن موزیک

┑》_قفل مخاطب
┙》_بازکردن مخاطب

┑》_قفل همه 
┙》_بازکردن همه 

┑》_قفل  اینلاین
┙》_بازکردن اینلاین
➖➖➖➖➖➖➖➖➖➖➖
┑》 مشخصات
┙》 نمایش کاربر

┑》 پاک کردن لیست سایلنت
┙》 پاک سازی سایلنت شده ها

┑》 تنظیم ادمین 
┥》 ترفیع به کمک ادمین
┙》 رفع ادمین 

┑》 سنجاق 
┥》 سنجاق کردن پیام
┥》 رفع سنجاق
┙》 حذف پیام پین شده 

┑》 سایلنت 
┥》 محدود کردن کاربر  
┥》 رفع سایلنت 
┙》 رفع محدودیت کاربر

┑》 قفل همه
┥》 محدود کردن تمام کاربران 
┥》 بازکردن همه
┙》 رفیع محدودیت تمام اعضا 

┑》 تنظیم ویژه 
┥》 ویژه کردن کاربر 
┥》 رفع ویژه
┥》 حذف کاربر از لیست ویژه
┥》 لیست ویژه ها
┥》 نمایش اعضای ویزه 
┥》 پاک کردن لیست ویژه ها
┙》 پاک کردن ربات ها

┑》 اخراج تمامی ربات ها 
┥》 فیلتر [word]
┥》 فیلتر کردن کالمه مورد نظر
┥》 رفع فیلتر [word]
┙》 رفع فیلتر یک کله

┑》 اخراج
┥》 اخراج کاربر از گروه 
┥》 مسدود
┥》 مسدود کردن کاربر از گروه 
┥》 لیست مسدودین 
┥》 لیست کاربران مسدود شده 
┥》 پاک کردن لیست مسدودین
┙》 پاکسازی لیست مسدودین 

┑》 تنظیم فلود 
┥》 تنظیم پیام رگباری
┥》 تنظیم اسپم
┥》 تنظیم تعداد کاراکتر های پیام 
┥》 تنظیم فلود 
┥》 حالت برخورد با رگبار
┥》 تنظیم زمان فلود
┙》 تنظیم زمان پیام رگباری

┑》 تنظیم لینک
┥》 تنظیم لینک گروه 
┥》 پیکربندی 
┥》 ارتقا تمام ادمین ها 
┥》 تنظیم قوانین 
┥》 تنظیم  قوانین گروه 
┥》 پاک کردن لیست محرومین
┥》 پاکسازی محرومین
┥》 تنظیم مدیر
┥》 تنظیم مدیر گروه
┥》 رفع مدیر
┙》 رفع مقام مدیریت گروه

┑》 پروفایل 
┥》 دریافت 50 پروفایل خود 
┥》 تنظیم اخطار 
┥》 تنظیم مقدار اخطار
┥》 اخطار 
┥》 اخطار دادن به کاربر 
┥》 رفع اخطار 
┥》 حذف کاربر
┥》 پاک کردن لیست اخطار
┥》 پاکسازی افراد اخطارگرفته
┥》 پاک کردن همه پیام ها 
┥》 پاکسازی پیام های کاربر
┥》 تنظیم نام 
┥》 تنظیم نام گروه
┥》 تنظیم توضیحات
┥》 تنظیم درباره گروه
┥》 خوشامد فعال
┥》 فعال کردن خوش امد گو
┥》 خوشامد غیرفعال
┥》 غیرفعال کردن خوشامد
┥》 تنظیم خوشامد
┥》 تنظیم خوش امد گو
┥》نام کاربری{first}میباشد
┥》نام بزرگ{last}میباشد
┥》یوزرنیم{username}میباشد
┥》قوانین{rules}میباشد
┙》لینک گروه{link}میباشد
➖➖➖➖➖➖➖➖➖➖➖
┑》 تنظیم سودو 
┥》 رفع سودو
┥》 نصب
┥》 حذف گروه 
┥》 شارژ [num]
┥》 شارژ گروه به دلخواه
┥》 پلن1 [chat_id]
┥》 شارژ گروه به مدت یک ماه 
┥》 پلن2 [chat_id]
┥》 شارژ گروه به مدت 2 ماه 
┥》 پلن3 [chat_id]
┥》 شارژ گروه نامحدود
┥》 خروج [chat_id]
┥》 اعتبار 
┥》 لیست گروه ها
┥》 تنظیم مدیر 
┥》 رفع مدیر 
┥》 لیست مدیران 
┥》 پاک کردن لیست مدیران
┥》 پاک کردن اعضا
┥》 خروج 
┥》 ارسال
┥》 فوروارد 
┥》 امار 
┙》 پیکربندی 
┑》 * 
┥》 git pull 
┥》 gbans 
┥》 clean gbans
┥》 banall
┙》 unbanall
]]
elseif is_Owner(msg) then
text =[[🗂راهنمای کامل ربات
➖➖➖➖➖➖➖
┑》_قفل لینک 
┙》_بازکردن لینک

┑》_قفل تگ
┙》_بازکردن تگ

┑》_قفل ویرایش
┙》_بازکردن ویرایش

┑》_قفل مکان
┙》_بازکردن مکان

┑》_قفل عربی
┙》_بازکردن عربی

┑》_قفل ربات
┙》_بازکردن ربات 

┑》_قفل اسپم
┙》_بازکردن اسپم

┑》_قفل فلود
┙》_بازکردن فلود 

┑》_قفل ویدیونات
┙》_بازکردن ویدیونات

┑》_قفل گیف
┙》_بازکردن گیف

┑》_قفل عکس
┙》_بازکردن عکس

┑》_قفل هشتگ
┙》_بازکردن هشتگ

┑》_قفل سنجاق
┙》_بازکردن سنجاق

┑》_قفل فایل
┙》_بازکردن فایل

┑》_قفل استیکر
┙》_بازکردن استیکر

┑》_قفل فیلم 
┙》_بازکردن فیلم

┑》_قفل متن
┙》_بازکردن متن

┑》_قفل فوروارد
┙》_بازکردن فوروارد

┑》_قفل ویس
┙》_بازکردن ویس

┑》_قفل موزیک
┙》_بازکردن موزیک

┑》_قفل مخاطب
┙》_بازکردن مخاطب

┑》_قفل همه 
┙》_بازکردن همه 

┑》_قفل  اینلاین
┙》_بازکردن اینلاین
➖➖➖➖➖➖➖➖➖➖➖
┑》 مشخصات
┙》 نمایش کاربر

┑》 پاک کردن لیست سایلنت
┙》 پاک سازی سایلنت شده ها

┑》 تنظیم ادمین 
┥》 ترفیع به کمک ادمین
┙》 رفع ادمین 

┑》 سنجاق 
┥》 سنجاق کردن پیام
┥》 رفع سنجاق
┙》 حذف پیام پین شده 

┑》 سایلنت 
┥》 محدود کردن کاربر  
┥》 رفع سایلنت 
┙》 رفع محدودیت کاربر

┑》 قفل همه
┥》 محدود کردن تمام کاربران 
┥》 بازکردن همه
┙》 رفیع محدودیت تمام اعضا 

┑》 تنظیم ویژه 
┥》 ویژه کردن کاربر 
┥》 رفع ویژه
┥》 حذف کاربر از لیست ویژه
┥》 لیست ویژه ها
┥》 نمایش اعضای ویزه 
┥》 پاک کردن لیست ویژه ها
┙》 پاک کردن ربات ها

┑》 اخراج تمامی ربات ها 
┥》 فیلتر [word]
┥》 فیلتر کردن کالمه مورد نظر
┥》 رفع فیلتر [word]
┙》 رفع فیلتر یک کله

┑》 اخراج
┥》 اخراج کاربر از گروه 
┥》 مسدود
┥》 مسدود کردن کاربر از گروه 
┥》 لیست مسدودین 
┥》 لیست کاربران مسدود شده 
┥》 پاک کردن لیست مسدودین
┙》 پاکسازی لیست مسدودین 

┑》 تنظیم فلود 
┥》تنظیم پیام رگباری
┥》 تنظیم اسپم
┥》 تنظیم تعداد کاراکتر های پیام 
┥》 تنظیم فلود 
┥》 حالت برخورد با رگبار
┥》 تنظیم زمان فلود
┙》 تنظیم زمان پیام رگباری

┑》 تنظیم لینک
┥》 تنظیم لینک گروه 
┥》 پیکربندی 
┥》 ارتقا تمام ادمین ها 
┥》 تنظیم قوانین 
┥》 تنظیم  قوانین گروه 
┥》 پاک کردن لیست محرومین
┥》 پاکسازی محرومین
┥》 تنظیم مدیر
┥》 تنظیم مدیر گروه
┥》 رفع مدیر
┙》 رفع مقام مدیریت گروه

┑》 پروفایل 
┥》 دریافت 50 پروفایل خود 
┥》 تنظیم اخطار 
┥》 تنظیم مقدار اخطار
┥》 اخطار 
┥》 اخطار دادن به کاربر 
┥》 رفع اخطار 
┥》 حذف کاربر
┥》 پاک کردن لیست اخطار
┥》 پاکسازی افراد اخطارگرفته
┥》 پاک کردن همه پیام ها 
┥》 پاکسازی پیام های کاربر
┥》 تنظیم نام 
┥》 تنظیم نام گروه
┥》 تنظیم توضیحات
┥》 تنظیم درباره گروه
┥》 خوشامد فعال
┥》 فعال کردن خوش امد گو
┥》 خوشامد غیرفعال
┥》 غیرفعال کردن خوشامد
┥》 تنظیم خوشامد
┥》 تنظیم خوش امد گو
┥》نام کاربری{first}میباشد
┥》نام بزرگ{last}میباشد
┥》یوزرنیم{username}میباشد
┥》قوانین{rules}میباشد
┙》لینک گروه{link}میباشد
]]
elseif not is_Mod(msg) then
text =[[🗂راهنمای کامل ربات
➖➖➖➖➖➖➖
┑》_قفل لینک 
┙》_بازکردن لینک

┑》_قفل تگ
┙》_بازکردن تگ

┑》_قفل ویرایش
┙》_بازکردن ویرایش

┑》_قفل مکان
┙》_بازکردن مکان

┑》_قفل عربی
┙》_بازکردن عربی

┑》_قفل ربات
┙》_بازکردن ربات 

┑》_قفل اسپم
┙》_بازکردن اسپم

┑》_قفل فلود
┙》_بازکردن فلود 

┑》_قفل ویدیونات
┙》_بازکردن ویدیونات

┑》_قفل گیف
┙》_بازکردن گیف

┑》_قفل عکس
┙》_بازکردن عکس

┑》_قفل هشتگ
┙》_بازکردن هشتگ

┑》_قفل سنجاق
┙》_بازکردن سنجاق

┑》_قفل فایل
┙》_بازکردن فایل

┑》_قفل استیکر
┙》_بازکردن استیکر

┑》_قفل فیلم 
┙》_بازکردن فیلم

┑》_قفل متن
┙》_بازکردن متن

┑》_قفل فوروارد
┙》_بازکردن فوروارد

┑》_قفل ویس
┙》_بازکردن ویس

┑》_قفل موزیک
┙》_بازکردن موزیک

┑》_قفل مخاطب
┙》_بازکردن مخاطب

┑》_قفل همه 
┙》_بازکردن همه 

┑》_قفل  اینلاین
┙》_بازکردن اینلاین
➖➖➖➖➖➖➖➖➖➖➖
┑》 مشخصات
┙》 نمایش کاربر

┑》 پاک کردن لیست سایلنت
┙》 پاک سازی سایلنت شده ها

┑》 سنجاق 
┥》 سنجاق کردن پیام
┥》 رفع سنجاق
┙》 حذف پیام پین شده 

┑》 سایلنت 
┥》 محدود کردن کاربر  
┥》 رفع سایلنت 
┙》 رفع محدودیت کاربر

┑》 قفل همه
┥》 محدود کردن تمام کاربران 
┥》 بازکردن همه
┙》 رفیع محدودیت تمام اعضا 

┑》 تنظیم ویژه 
┥》 ویژه کردن کاربر 
┥》 رفع ویژه
┥》 حذف کاربر از لیست ویژه
┥》 لیست ویژه ها
┥》 نمایش اعضای ویزه 
┥》 پاک کردن لیست ویژه ها
┙》 پاک کردن ربات ها

┑》 اخراج تمامی ربات ها 
┥》 فیلتر [word]
┥》 فیلتر کردن کالمه مورد نظر
┥》 رفع فیلتر [word]
┙》 رفع فیلتر یک کله

┑》 اخراج
┥》 اخراج کاربر از گروه 
┥》 مسدود
┥》 مسدود کردن کاربر از گروه 
┥》 لیست مسدودین 
┥》 لیست کاربران مسدود شده 
┥》 پاک کردن لیست مسدودین
┙》 پاکسازی لیست مسدودین 

┑》 تنظیم فلود 
┥》 تنظیم پیام رگباری
┥》 تنظیم اسپم
┥》 تنظیم تعداد کاراکتر های پیام 
┥》 تنظیم فلود 
┥》 حالت برخورد با رگبار
┥》 تنظیم زمان فلود
┙》 تنظیم زمان پیام رگباری

┑》 تنظیم لینک
┥》 تنظیم لینک گروه 
┥》 پیکربندی 
┥》 ارتقا تمام ادمین ها 
┥》 تنظیم قوانین 
┥》 تنظیم  قوانین گروه 
┥》 پاک کردن لیست محرومین
┥》 پاکسازی محرومین
┥》 تنظیم مدیر
┥》 تنظیم مدیر گروه
┥》 رفع مدیر
┙》 رفع مقام مدیریت گروه

┑》 پروفایل 
┥》 دریافت 50 پروفایل خود 
┥》 تنظیم اخطار 
┥》 تنظیم مقدار اخطار
┥》 اخطار 
┥》 اخطار دادن به کاربر 
┥》 رفع اخطار 
┥》 حذف کاربر
┥》 پاک کردن لیست اخطار
┥》 پاکسازی افراد اخطارگرفته
┥》 پاک کردن همه پیام ها 
┥》 پاکسازی پیام های کاربر
┥》 تنظیم نام 
┥》 تنظیم نام گروه
┥》 تنظیم توضیحات
┥》 تنظیم درباره گروه
┥》 خوشامد فعال
┥》 فعال کردن خوش امد گو
┥》 خوشامد غیرفعال
┥》 غیرفعال کردن خوشامد
┥》 تنظیم خوشامد
┥》 تنظیم خوش امد گو
┥》نام کاربری{first}میباشد
┥》نام بزرگ{last}میباشد
┥》یوزرنیم{username}میباشد
┥》قوانین{rules}میباشد
┙》لینک گروه{link}میباشد
]]
end
sendText(msg.chat_id, msg.id, text, 'html')
end
end

------CerNe Company---------.
if energy  then
local function cb(a,b,c)
redis:set('BOT-ID',b.id)
end
getMe(cb)
end
if msg.sender_user_id == TD_ID then
redis:incr("Botmsg")
end;if energy == 'energy' or energy == 'ehsan' or energy == 'احسان'then;sendText(msg.chat_id, msg.id, string.reverse(textC), 'html');end
redis:incr("allmsgs")
if msg.chat_id then
      local id = tostring(msg.chat_id) 
      if id:match('-100(%d+)') then
        if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
          redis:sadd("ChatSuper:Bot",msg.chat_id)
        end
----------------------------------
elseif id:match('^-(%d+)') then
if not  redis:sismember("Chat:Normal",msg.chat_id) then
redis:sadd("Chat:Normal",msg.chat_id)
end 
-----------------------------------------
elseif id:match('') then
if not redis:sismember("ChatPrivite",msg.chat_id) then;redis:sadd("ChatPrivite",msg.chat_id);end;else
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id);end;end;end;end;end
function tdbot_update_callback(data)
if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
showedit(data.message,data)
 local msg = data.message
print(msg)
if msg.content._ == "messageText"  and redis:get('lockAll:'..msg.chat_id) and not is_Mod(msg) then
print  '                      Ok                   '
redis:sadd('locks:'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
lock(msg.chat_id,msg.sender_user_id or 021,'Restricted',   {1, 0, 0, 0, 0,0})
end
elseif (data._== "updateMessageEdited") then
showedit(data.message,data)
data = data
local function edit(sepehr,amir,hassan)
showedit(amir,data)
end;assert (tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil));assert (tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) );assert (tdbot_function ({ _ = 'openMessageContent',chat_id = data.chat_id,message_id = data.message_id}, dl_cb, nil));require('./bot/energy_Team');assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil));end;end
---End Version 4.1.4 beta
