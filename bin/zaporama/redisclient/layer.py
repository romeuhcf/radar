from yowsup.layers.interface import YowInterfaceLayer, ProtocolEntityCallback
from yowsup.layers.auth import YowAuthenticationProtocolLayer
from yowsup.layers import YowLayerEvent
from yowsup.layers.network import YowNetworkLayer
import sys
from yowsup.common import YowConstants
import datetime
import os
import logging
from yowsup.layers.protocol_receipts.protocolentities    import *
from yowsup.layers.protocol_groups.protocolentities      import *
from yowsup.layers.protocol_presence.protocolentities    import *
from yowsup.layers.protocol_messages.protocolentities    import *
from yowsup.layers.protocol_acks.protocolentities        import *
from yowsup.layers.protocol_ib.protocolentities          import *
from yowsup.layers.protocol_iq.protocolentities          import *
from yowsup.layers.protocol_contacts.protocolentities    import *
from yowsup.layers.protocol_chatstate.protocolentities   import *
from yowsup.layers.protocol_privacy.protocolentities     import *
from yowsup.layers.protocol_media.protocolentities       import *
from yowsup.layers.protocol_media.mediauploader import MediaUploader
from yowsup.layers.protocol_profiles.protocolentities    import *
from yowsup.common.tools import ModuleTools
import asyncore
import json


import redis
from threading import Thread
from time import sleep

class RedisLayer(YowInterfaceLayer):
    def __init__(self, *args, **kwargs):
        super(RedisLayer, self).__init__(*args, **kwargs)
        self.connected = False
        self.redis = redis.StrictRedis(host='localhost', port=6379, db=0)


    def hadoken(self):
        self.disconnect();

    def output(self, message, tag = "general"):
        if tag is not None:
            print("%s: %s" % (tag, message))
        else:
            print(message)


    @ProtocolEntityCallback("success")
    def onSuccess(self, successProtocolEntity):
        # yay! we are connected
        self.connected = True
        self.outcome_worker_thread = Thread(target=RedisLayer.outcome_process, args=(self,))
        self.outcome_worker_thread.daemon=True
        self.outcome_worker_thread.start()
#        self.presence_name("Romeu HC Fonseca...")
#        self.profile_setStatus("bem, obrigado")
#        self.profile_setPicture("walterwhitereal.jpg")

        print "Conectado e Iniciado"

    @ProtocolEntityCallback("failure")
    def onFailure(self, entity):
        self.connected = False
        self.outcome_worker_thread.join()
        print("Connection Failed, reason: %s" % entity.getReason())

    def normalizeJid(self, number):
        if '@' in number:
            return number
        elif "-" in number:
            return "%s@g.us" % number

        return "%s@s.whatsapp.net" % number

    def assertConnected(self):
        if self.connected:
            return True
        else:
            print("Not connected")
            return False

    def outcome_process(self):

        #loop_thread = Thread(target=asyncore.loop, name="Asyncore Loop")
        #loop_thread.daemon = True
        #loop_thread.start()


        while self.connected:
            payload = self.redis.rpop("zaporama:outcome:" + self.getOwnJid(False))
            if payload:
                print("Got from redis: %s" % payload)

                data = json.loads(payload)
                # TODO tratar o envento q vem do redis como uma chamada para qqr metodo da api
                # TODO nao chamar metodos da api aqui, apenas enfileirar metodo como o demo cli
                outgoingMessageProtocolEntity = TextMessageProtocolEntity( data['body'], _id = data.get('id') , to = self.normalizeJid(data['human']))
                self.toLower(outgoingMessageProtocolEntity)
                continue
            sleep(1)

    @ProtocolEntityCallback("message")
    def onMessage(self, messageProtocolEntity):
        if messageProtocolEntity.getType() == 'text':
            self.onTextMessage(messageProtocolEntity)
        elif messageProtocolEntity.getType() == 'media':
            self.onMediaMessage(messageProtocolEntity)

        #self.toLower(messageProtocolEntity.forward(messageProtocolEntity.getFrom()))
        self.toLower(messageProtocolEntity.ack())
        self.toLower(messageProtocolEntity.ack(True))
        self.output("Sent delivered receipt", tag = "Message %s" % messageProtocolEntity.getId())
    def redisPush(self, data):
        key = "zaporama:income"
        payload = json.dumps(data)
        self.redis.lpush(key, payload)
        print("Sent lpush to redis %s at key=%s" % (payload, key))

    def onTextMessage(self,messageProtocolEntity):
        self.redisPush({
            'type': 'text',
            'body': messageProtocolEntity.getBody(),
            'human': messageProtocolEntity.getFrom(False),
            'robot': self.getOwnJid(False),
            'timestamp': messageProtocolEntity.getTimestamp() })

    def onMediaMessage(self, messageProtocolEntity):
        # just print info
        if messageProtocolEntity.getMediaType() == "image":
            self.redisPush({'type':'image', 'url': messageProtocolEntity.url, 'human' : messageProtocolEntity.getFrom(False)})
            print("Echoing image %s to %s" % (messageProtocolEntity.url, messageProtocolEntity.getFrom(False)))

        elif messageProtocolEntity.getMediaType() == "location":
            self.redisPush({'type':'location', 'latitude': messageProtocolEntity.getLatitude(), 'longitude': messageProtocolEntity.getLongitude(), 'human' : messageProtocolEntity.getFrom(False)})
            print("Echoing location (%s, %s) to %s" % (messageProtocolEntity.getLatitude(), messageProtocolEntity.getLongitude(), messageProtocolEntity.getFrom(False)))

        elif messageProtocolEntity.getMediaType() == "vcard":
            self.redisPush({'type':'vcard', 'vcard': messageProtocolEntity.getCardData(), name: messageProtocolEntity.getName(), 'human' : messageProtocolEntity.getFrom(False)})
            print("Echoing vcard (%s, %s) to %s" % (messageProtocolEntity.getName(), messageProtocolEntity.getCardData(), messageProtocolEntity.getFrom(False)))

    ########## PRESENCE ###############
    ##@clicmd("Set presence name")
    def presence_name(self, name):
        if self.assertConnected():
            entity = PresenceProtocolEntity(name = name)
            self.toLower(entity)

    ##@clicmd("Set presence as available")
    def presence_available(self):
        if self.assertConnected():
            entity = AvailablePresenceProtocolEntity()
            self.toLower(entity)

    ##@clicmd("Set presence as unavailable")
    def presence_unavailable(self):
        if self.assertConnected():
            entity = UnavailablePresenceProtocolEntity()
            self.toLower(entity)

    ##@clicmd("Unsubscribe from contact's presence updates")
    def presence_unsubscribe(self, contact):
        if self.assertConnected():
            entity = UnsubscribePresenceProtocolEntity(self.aliasToJid(contact))
            self.toLower(entity)

    ##@clicmd("Subscribe to contact's presence updates")
    def presence_subscribe(self, contact):
        if self.assertConnected():
            entity = SubscribePresenceProtocolEntity(self.aliasToJid(contact))
            self.toLower(entity)

    ########### END PRESENCE #############

    ####### contacts/ profiles ####################
    ##@clicmd("Set status text")
    def profile_setStatus(self, text):
        if self.assertConnected():

            def onSuccess(resultIqEntity, originalIqEntity):
                self.output("Status updated successfully")

            def onError(errorIqEntity, originalIqEntity):
                logger.error("Error updating status")

            entity = SetStatusIqProtocolEntity(text)
            self._sendIq(entity, onSuccess, onError)

    ##@clicmd("Get profile picture for contact")
    def contact_picture(self, jid):
        if self.assertConnected():
            entity = GetPictureIqProtocolEntity(self.aliasToJid(jid), preview=False)
            self._sendIq(entity, self.onGetContactPictureResult)

    ##@clicmd("Get profile picture preview for contact")
    def contact_picturePreview(self, jid):
        if self.assertConnected():
            entity = GetPictureIqProtocolEntity(self.aliasToJid(jid), preview=True)
            self._sendIq(entity, self.onGetContactPictureResult)

    ##@clicmd("Get lastseen for contact")
    def contact_lastseen(self, jid):
        if self.assertConnected():
            def onSuccess(resultIqEntity, originalIqEntity):
                self.output("%s lastseen %s seconds ago" % (resultIqEntity.getFrom(), resultIqEntity.getSeconds()))

            def onError(errorIqEntity, originalIqEntity):
                logger.error("Error getting lastseen information for %s" % originalIqEntity.getTo())

            entity = LastseenIqProtocolEntity(self.aliasToJid(jid))
            self._sendIq(entity, onSuccess, onError)


    ##@clicmd("Set profile picture")
    def profile_setPicture(self, path):
        if self.assertConnected() and ModuleTools.INSTALLED_PIL():

            def onSuccess(resultIqEntity, originalIqEntity):
                self.output("Profile picture updated successfully")

            def onError(errorIqEntity, originalIqEntity):
                logger.error("Error updating profile picture")

            #example by @aesedepece in https://github.com/tgalal/yowsup/pull/781
            #modified to support python3
            try:
                from PIL import Image
                src = Image.open(path)
                pictureData = src.resize((640, 640)).tobytes("jpeg", "RGB")
                picturePreview = src.resize((96, 96)).tobytes("jpeg", "RGB")
                iq = SetPictureIqProtocolEntity(self.getOwnJid(), picturePreview, pictureData)
                self._sendIq(iq, onSuccess, onError)
            except Exception as e:
                print "Unexpected error:", str(e)
        else:
            logger.error("Python PIL library is not installed, can't set profile picture")

    ########### groups

    #@clicmd("List all groups you belong to", 5)
    def groups_list(self):
        if self.assertConnected():
            entity = ListGroupsIqProtocolEntity()
            self.toLower(entity)

    #@clicmd("Leave a group you belong to", 4)
    def group_leave(self, group_jid):
        if self.assertConnected():
            entity = LeaveGroupsIqProtocolEntity([self.aliasToJid(group_jid)])
            self.toLower(entity)



    #@clicmd("Create a new group with the specified subject and participants. Jids are a comma separated list but optional.", 3)
    def groups_create(self, subject, jids = None):
        if self.assertConnected():
            jids = [self.aliasToJid(jid) for jid in jids.split(',')] if jids else []
            entity = CreateGroupsIqProtocolEntity(subject, participants=jids)
            self.toLower(entity)

    #@clicmd("Invite to group. Jids are a comma separated list")
    def group_invite(self, group_jid, jids):
        if self.assertConnected():
            jids = [self.aliasToJid(jid) for jid in jids.split(',')]
            entity = AddParticipantsIqProtocolEntity(self.aliasToJid(group_jid), jids)
            self.toLower(entity)

    #@clicmd("Promote admin of a group. Jids are a comma separated list")
    def group_promote(self, group_jid, jids):
        if self.assertConnected():
            jids = [self.aliasToJid(jid) for jid in jids.split(',')]
            entity = PromoteParticipantsIqProtocolEntity(self.aliasToJid(group_jid), jids)
            self.toLower(entity)

    #@clicmd("Remove admin of a group. Jids are a comma separated list")
    def group_demote(self, group_jid, jids):
        if self.assertConnected():
            jids = [self.aliasToJid(jid) for jid in jids.split(',')]
            entity = DemoteParticipantsIqProtocolEntity(self.aliasToJid(group_jid), jids)
            self.toLower(entity)

    #@clicmd("Kick from group. Jids are a comma separated list")
    def group_kick(self, group_jid, jids):
        if self.assertConnected():
            jids = [self.aliasToJid(jid) for jid in jids.split(',')]
            entity = RemoveParticipantsIqProtocolEntity(self.aliasToJid(group_jid), jids)
            self.toLower(entity)


    #@clicmd("Change group subject")
    def group_setSubject(self, group_jid, subject):
        if self.assertConnected():
            entity = SubjectGroupsIqProtocolEntity(self.aliasToJid(group_jid), subject)
            self.toLower(entity)

    #@clicmd("Set group picture")
    def group_picture(self, group_jid, path):
        if self.assertConnected() and ModuleTools.INSTALLED_PIL():

            def onSuccess(resultIqEntity, originalIqEntity):
                self.output("Group picture updated successfully")

            def onError(errorIqEntity, originalIqEntity):
                logger.error("Error updating Group picture")

            #example by @aesedepece in https://github.com/tgalal/yowsup/pull/781
            #modified to support python3
            from PIL import Image
            src = Image.open(path)
            pictureData = src.resize((640, 640)).tobytes("jpeg", "RGB")
            picturePreview = src.resize((96, 96)).tobytes("jpeg", "RGB")
            iq = SetPictureIqProtocolEntity(self.aliasToJid(group_jid), picturePreview, pictureData)
            self._sendIq(iq, onSuccess, onError)
        else:
            logger.error("Python PIL library is not installed, can't set profile picture")


    #@clicmd("Get group info")
    def group_info(self, group_jid):
        if self.assertConnected():
            entity = InfoGroupsIqProtocolEntity(self.aliasToJid(group_jid))
            self.toLower(entity)

    #@clicmd("Get shared keys")
    def keys_get(self, jids):
        if ModuleTools.INSTALLED_AXOLOTL():
            from yowsup.layers.axolotl.protocolentities.iq_key_get import GetKeysIqProtocolEntity
            if self.assertConnected():
                jids = [self.aliasToJid(jid) for jid in jids.split(',')]
                entity = GetKeysIqProtocolEntity(jids)
                self.toLower(entity)
        else:
            logger.error("Axolotl is not installed")

    #@clicmd("Send prekeys")
    def keys_set(self):
        if ModuleTools.INSTALLED_AXOLOTL():
            from yowsup.layers.axolotl import YowAxolotlLayer
            if self.assertConnected():
                self.broadcastEvent(YowLayerEvent(YowAxolotlLayer.EVENT_PREKEYS_SET))
        else:
            logger.error("Axolotl is not installed")

    #@clicmd("Send init seq")
    def seq(self):
        priv = PrivacyListIqProtocolEntity()
        self.toLower(priv)
        push = PushIqProtocolEntity()
        self.toLower(push)
        props = PropsIqProtocolEntity()
        self.toLower(props)
        crypto = CryptoIqProtocolEntity()
        self.toLower(crypto)


    #@clicmd("Delete your account")
    def account_delete(self):
        if self.assertConnected():
            if self.accountDelWarnings < self.__class__.ACCOUNT_DEL_WARNINGS:
                self.accountDelWarnings += 1
                remaining = self.__class__.ACCOUNT_DEL_WARNINGS - self.accountDelWarnings
                self.output("Repeat delete command another %s times to send the delete request" % remaining, tag="Account delete Warning !!")
            else:
                entity = UnregisterIqProtocolEntity()
                self.toLower(entity)

    #@clicmd("Send message to a friend")
    def message_send(self, number, content):
        if self.assertConnected():
            outgoingMessage = TextMessageProtocolEntity(content.encode("utf-8") if sys.version_info >= (3,0) else content, to = self.aliasToJid(number))
            self.toLower(outgoingMessage)

    #@clicmd("Broadcast message. numbers should comma separated phone numbers")
    def message_broadcast(self, numbers, content):
        if self.assertConnected():
            jids = [self.aliasToJid(number) for number in numbers.split(',')]
            outgoingMessage = BroadcastTextMessage(jids, content)
            self.toLower(outgoingMessage)

    ##@clicmd("Send read receipt")
    def message_read(self, message_id):
        pass

    ##@clicmd("Send delivered receipt")
    def message_delivered(self, message_id):
        pass



    #@clicmd("Send an image with optional caption")
    def image_send(self, number, path, caption = None):
        if self.assertConnected():
            jid = self.aliasToJid(number)
            entity = RequestUploadIqProtocolEntity(RequestUploadIqProtocolEntity.MEDIA_TYPE_IMAGE, filePath=path)
            successFn = lambda successEntity, originalEntity: self.onRequestUploadResult(jid, path, successEntity, originalEntity, caption)
            errorFn = lambda errorEntity, originalEntity: self.onRequestUploadError(jid, path, errorEntity, originalEntity)

            self._sendIq(entity, successFn, errorFn)

    #@clicmd("Send audio file")
    def audio_send(self, number, path):
        if self.assertConnected():
            jid = self.aliasToJid(number)
            entity = RequestUploadIqProtocolEntity(RequestUploadIqProtocolEntity.MEDIA_TYPE_AUDIO, filePath=path)
            successFn = lambda successEntity, originalEntity: self.onRequestUploadResult(jid, path, successEntity, originalEntity)
            errorFn = lambda errorEntity, originalEntity: self.onRequestUploadError(jid, path, errorEntity, originalEntity)

            self._sendIq(entity, successFn, errorFn)
    #@clicmd("Send typing state")
    def state_typing(self, jid):
        if self.assertConnected():
            entity = OutgoingChatstateProtocolEntity(ChatstateProtocolEntity.STATE_TYPING, self.aliasToJid(jid))
            self.toLower(entity)

    #@clicmd("Send paused state")
    def state_paused(self, jid):
        if self.assertConnected():
            entity = OutgoingChatstateProtocolEntity(ChatstateProtocolEntity.STATE_PAUSED, self.aliasToJid(jid))
            self.toLower(entity)

    #@clicmd("Sync contacts, contacts should be comma separated phone numbers, with no spaces")
    def contacts_sync(self, contacts):
        if self.assertConnected():
            entity = GetSyncIqProtocolEntity(contacts.split(','))
            self.toLower(entity)

    #@clicmd("Disconnect")
    def disconnect(self):
        if self.assertConnected():
            self.broadcastEvent(YowLayerEvent(YowNetworkLayer.EVENT_STATE_DISCONNECT))

    #@clicmd("Quick login")
    def L(self):
        if self.connected:
            return self.output("Already connected, disconnect first")
        self.getLayerInterface(YowNetworkLayer).connect()
        return True

    #@clicmd("Login to WhatsApp", 0)
    def login(self, username, b64password):
        self.setCredentials(username, b64password)
        return self.L()



    ######## receive #########

    @ProtocolEntityCallback("chatstate")
    def onChatstate(self, entity):
        print(entity)

    @ProtocolEntityCallback("iq")
    def onIq(self, entity):
        print(entity)

    @ProtocolEntityCallback("ack")
    def onAck(self, entity):
        #formattedDate = datetime.datetime.fromtimestamp(self.sentCache[entity.getId()][0]).strftime('%d-%m-%Y %H:%M')
        #print("%s [%s]:%s"%(self.username, formattedDate, self.sentCache[entity.getId()][1]))
        if entity.getClass() == "message":
            self.redisPush({'type':'ack', 'id': entity.getId()})
            self.output(entity.getId(), tag = "Sent")
            #self.notifyInputThread()

    @ProtocolEntityCallback("receipt")
    def onReceipt(self, entity):
        self.toLower(entity.ack())


    @ProtocolEntityCallback("notification")
    def onNotification(self, notification):
        notificationData = notification.__str__()
        if notificationData:
            self.output(notificationData, tag = "Notification")
        else:
            self.output("From :%s, Type: %s" % (self.jidToAlias(notification.getFrom()), notification.getType()), tag = "Notification")

        self.toLower(notification.ack())


    def getTextMessageBody(self, message):
        return message.getBody()

    def getMediaMessageBody(self, message):
        if message.getMediaType() in ("image", "audio", "video"):
            return self.getDownloadableMediaMessageBody(message)
        else:
            return "[Media Type: %s]" % message.getMediaType()


    def getDownloadableMediaMessageBody(self, message):
        return "[Media Type:{media_type}, Size:{media_size}, URL:{media_url}]".format(
                media_type = message.getMediaType(),
                media_size = message.getMediaSize(),
                media_url = message.getMediaUrl()
                )


        def doSendImage(self, filePath, url, to, ip = None, caption = None):
            entity = ImageDownloadableMediaMessageProtocolEntity.fromFilePath(filePath, url, ip, to, caption = caption)
        self.toLower(entity)

    def doSendAudio(self, filePath, url, to, ip = None, caption = None):
        entity = AudioDownloadableMediaMessageProtocolEntity.fromFilePath(filePath, url, ip, to)
        self.toLower(entity)

    def __str__(self):
        return "CLI Interface Layer"

    ########### callbacks ############

    def onRequestUploadResult(self, jid, filePath, resultRequestUploadIqProtocolEntity, requestUploadIqProtocolEntity, caption = None):

        if requestUploadIqProtocolEntity.mediaType == RequestUploadIqProtocolEntity.MEDIA_TYPE_AUDIO:
            doSendFn = self.doSendAudio
        else:
            doSendFn = self.doSendImage

        if resultRequestUploadIqProtocolEntity.isDuplicate():
            doSendFn(filePath, resultRequestUploadIqProtocolEntity.getUrl(), jid,
                    resultRequestUploadIqProtocolEntity.getIp(), caption)
        else:
            successFn = lambda filePath, jid, url: doSendFn(filePath, url, jid, resultRequestUploadIqProtocolEntity.getIp(), caption)
            mediaUploader = MediaUploader(jid, self.getOwnJid(), filePath,
                    resultRequestUploadIqProtocolEntity.getUrl(),
                    resultRequestUploadIqProtocolEntity.getResumeOffset(),
                    successFn, self.onUploadError, self.onUploadProgress, async=False)
            mediaUploader.start()

    def onRequestUploadError(self, jid, path, errorRequestUploadIqProtocolEntity, requestUploadIqProtocolEntity):
        logger.error("Request upload for file %s for %s failed" % (path, jid))

    def onUploadError(self, filePath, jid, url):
        logger.error("Upload file %s to %s for %s failed!" % (filePath, url, jid))

    def onUploadProgress(self, filePath, jid, url, progress):
        sys.stdout.write("%s => %s, %d%% \r" % (os.path.basename(filePath), jid, progress))
        sys.stdout.flush()

    def onGetContactPictureResult(self, resultGetPictureIqProtocolEntiy, getPictureIqProtocolEntity):
        # do here whatever you want
        # write to a file
        # or open
        # or do nothing
        # write to file example:
        #resultGetPictureIqProtocolEntiy.writeToFile("/tmp/yowpics/%s_%s.jpg" % (getPictureIqProtocolEntity.getTo(), "preview" if resultGetPictureIqProtocolEntiy.isPreview() else "full"))
        pass
