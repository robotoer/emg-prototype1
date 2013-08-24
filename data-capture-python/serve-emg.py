#!/usr/bin/env python

# from wsgiref.simple_server import make_server
# from ws4py.websocket import EchoWebSocket
# from ws4py.server.wsgirefserver import WSGIServer, WebSocketWSGIRequestHandler
# from ws4py.server.wsgiutils import WebSocketWSGIApplication

# server = make_server(
#     host='',
#     port=9000,
#     server_class=WSGIServer,
#     handler_class=WebSocketWSGIRequestHandler,
#     app=WebSocketWSGIApplication(handler_cls=EchoWebSocket))
# server.initialize_websockets_manager()
# server.serve_forever()

import cherrypy
from ws4py.server.cherrypyserver import WebSocketPlugin, WebSocketTool
from ws4py.websocket import EchoWebSocket

cherrypy.config.update({'server.socket_port': 9000})
WebSocketPlugin(cherrypy.engine).subscribe()
cherrypy.tools.websocket = WebSocketTool()

class Root(object):
  @cherrypy.expose
  def index(self):
    return 'some HTML with a websocket javascript connection'

  @cherrypy.expose
  def ws(self):
    # handler = cherrypy.request.ws_handler
    pass


cherrypy.quickstart(
    Root(),
    '/',
    config={
        '/ws': {
            'tools.websocket.on': True,
            'tools.websocket.handler_cls': EchoWebSocket
        }
    })
