import json
import os
from os.path import dirname


def readFile(file_path):
    if not os.path.exists(file_path):
        return None
    with open(file_path) as json_file:
        data = json.load(json_file)
        return data


def configure(app):
    file = readFile(dirname(__file__) + '/../config.json')
    config = Config()
    config.DB_URL = os.getenv('DB_URL', file and file['DB_URL'])
    config.JWT_SECRET = os.getenv('JWT_SECRET', file and file['JWT_SECRET'])
    config.PORT = os.getenv('PORT', file and file['PORT'])
    config.PSK = os.getenv('PSK', file and file['PSK'])

    if not config.isValid():
        raise NameError('Config not valid, check ENV or config.json')

    app.config['SQLALCHEMY_DATABASE_URI'] = config.DB_URL
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = config.JWT_SECRET
    app.config['PSK'] = config.PSK

    return Config


class Config:
    DB_URL = None
    JWT_SECRET = None
    PORT = None
    PSK = None

    def isValid(self):
        return (self.DB_URL is not None) \
               and (self.JWT_SECRET is not None) \
               and (self.PORT is not None) \
               and (self.PSK is not None)
