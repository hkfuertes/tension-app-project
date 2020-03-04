from routes.auth import auth
from routes.doctors import doctors
from routes.measures import measures
from routes.home import home
from routes.patients import patients
from routes.stats import stats

import constants as Constants


def register_blueprints(app):
    app.register_blueprint(home)
    app.register_blueprint(doctors, url_prefix='/' + Constants.API_PREFIX)
    app.register_blueprint(patients, url_prefix='/' + Constants.API_PREFIX)
    app.register_blueprint(measures, url_prefix='/' + Constants.API_PREFIX)
    app.register_blueprint(stats, url_prefix='/' + Constants.API_PREFIX)
    app.register_blueprint(auth, url_prefix='/')
