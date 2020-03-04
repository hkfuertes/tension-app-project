from flask import Flask, jsonify
from flask_jwt_extended import JWTManager
from flask_bootstrap import Bootstrap
from flasgger import Swagger

from routes import register_blueprints
from util import Configurator

from model import db


app = Flask(__name__, template_folder="templates/", static_folder="static/")
Bootstrap(app)
config = Configurator.configure(app)
jwt = JWTManager(app)
db.init_app(app)
app.config['db'] = db

register_blueprints(app)

'''
swagger_template = {
    # Other settings

    'components': {
        'securitySchemes': {
            'bearerAuth': {
                'type': 'http',
                'scheme': 'bearer',
                'bearerFormat': 'JWT'
            }
        }
    },

    # Other settings
}

app.config['SWAGGER'] = {
    'title': 'TensionApp Server',
    'description': 'Blood pressure, Pulse and Weight management app.',
    'contact': {
        'email': 'hkfuertes@gmail.com'
    }
}
swagger = Swagger(app)
'''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=config.PORT)

