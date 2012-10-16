app = require('express')()
db  = new require('mongodb').Db 'cpanel', new require('mongodb').Server 'localhost', 27017
log = console.log
c   = require 'cli-color'

app.use require('express').bodyParser()

db.open (err, db) ->
  
  app.all '/:collection', (req, res, next) ->
    res.setHeader 'Content-type', 'application/json;charset=utf-8'
    next()

  app.all '/:collection/:id', (req, res, next) ->
    res.setHeader 'Content-type', 'application/json;charset=utf-8'
    next()    

  app.get '/:collection', (req, res) ->
    if JSON.stringify(req.query) != "{}" # HORROR, I just don't remember any other way to do it
      log c.cyan "GET /#{req.params.collection}?#{JSON.stringify(req.query)}"
    else
      log c.cyan "GET /#{req.params.collection}"
    collection = db.collection req.params.collection
    collection.find(req.query).toArray (err, items) ->
      res.send items

  app.get '/:collection/:id', (req, res) ->
    log c.cyan "GET /#{req.params.collection}/#{req.params.id}"
    collection = db.collection req.params.collection
    try
      collection.findOne {"_id": require('mongodb').ObjectID.createFromHexString(req.params.id)}, (err, item) ->
        res.send item
    catch e
      collection.findOne {"_id": req.params.id}, (err, item) ->
        res.send item

  app.post '/:collection', (req, res) ->
    log c.yellow "POST /#{req.params.collection} #{JSON.stringify(req.body)}"
    collection = db.collection req.params.collection
    collection.insert req.body
    collection.findOne req.body, (err, item) ->
      res.send item

  app.put '/:collection/:id', (req, res) ->
    log c.yellow "PUT /#{req.params.collection}/#{req.params.id} #{JSON.stringify(req.body)}"
    collection = db.collection req.params.collection
    req.body._id = req.params.id
    collection.insert req.body
    collection.findOne req.body, (err, item) ->
      res.send item
  
  app.patch '/:collection/:id', (req, res) ->
    log c.yellow "PATCH /#{req.params.collection}/#{req.params.id} #{JSON.stringify(req.body)}"
    collection = db.collection req.params.collection
    res.setHeader 'Content-type', 'application/json;charset=utf-8'
    try
      collection.update {"_id": require('mongodb').ObjectID.createFromHexString(req.params.id)}, {"$set": req.body}
    catch e
      collection.update {"_id": req.params.id}, {"$set": req.body}
    collection.findOne req.body, (err, item) ->
      res.send item

  app.delete '/:collection/:id', (req, res) ->
    log c.red "DELETE /#{req.params.collection}/#{req.params.id}"
    collection = db.collection req.params.collection
    collection.remove {"_id": require('mongodb').ObjectID.createFromHexString(req.params.id)}, (err, result) ->
      res.send result

  app.listen 4567
  log c.green 'Get your coffee on table 4567'