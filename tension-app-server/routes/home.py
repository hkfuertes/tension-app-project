from flask import Blueprint, current_app as app, render_template

home = Blueprint('home_routes', __name__)


@home.route('/')
def show():
    return render_template('index.html')
