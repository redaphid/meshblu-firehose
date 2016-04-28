_               = require 'lodash'
MeshbluFirehose = require 'meshblu-firehose-socket.io'
MeshbluHttp     = require 'meshblu-http'
MeshbluConfig   = require 'meshblu-config'

uuid = 'd6fdd86d-b36f-4f85-9697-0718aada8f64'

meshbluConfig = new MeshbluConfig(
  uuid: uuid
  token: '3dda6691441855bbe9e48a340c3486964327202a'
  hostname: 'meshblu.octoblu.com'
  port: '443'
  protocol: 'https'
).toJSON()

firehoseConfig = new MeshbluConfig(
  uuid: uuid
  token: '3dda6691441855bbe9e48a340c3486964327202a'
  hostname: 'meshblu-firehose-socket-io.octoblu.com'
  port: '443'
  protocol: 'https'
).toJSON()

console.log firehoseConfig
firehose = new MeshbluFirehose meshbluConfig: firehoseConfig
meshblu  = new MeshbluHttp meshbluConfig


subscribe = (callback) ->
  subscription = subscriberUuid: uuid, emitterUuid: uuid, type: 'message.received'
  meshblu.createSubscription subscription, =>
    subscription = subscriberUuid: uuid, emitterUuid: uuid, type: 'configure.received'
    meshblu.createSubscription subscription, callback


subscribe (error) =>
  return console.log "Error subscribing: #{error.message}" if error?
  console.log "subscribed."
  firehose.on 'message', ({metadata, data}) =>
    from = _.first metadata.route
    return console.log "ready to go!" if data.starting && from.uuid = uuid
    console.log JSON.stringify data, null, 2

  firehose.connect {uuid}, =>
    console.log 'connected to firehose'
    message = {devices: [uuid], starting: true}
    console.log {message}
    meshblu.message message, (error) =>
      return console.log "Error sending message: #{error.message}" if error?
      console.log "Message sent."



console.log(firehose)
