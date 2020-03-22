from datetime import datetime

from flasgger import swag_from
from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity, jwt_required

from model import Doctor, db
from util import JSONTool

from routes.auth import getUser

from flask import current_app as app

doctors = Blueprint('doctors_routes', __name__)


@doctors.route('/doctor', methods=['POST'])
def create():
    if request.headers.get('PSK', None) != app.config['PSK']:
        return jsonify({'result': 'failed', 'error': "You do not have permission to create a Doctor!"})

    newdoctor = Doctor(
        email=request.form['email'],
        password=request.form['password'],
        name=request.form['name'],
        lastName=request.form['lastName'],
    )
    db.session.add(newdoctor)
    db.session.commit()
    return jsonify({'result': 'success', 'data': JSONTool.object_as_dict(newdoctor)})


@doctors.route('/doctor', methods=['GET'])
@jwt_required
def show():
    doctor = getUser(get_jwt_identity())
    return jsonify({'result': 'success', 'data': JSONTool.object_as_dict(doctor)})


@doctors.route('/doctor', methods=['DELETE'])
@jwt_required
def delete():
    doctor = getUser(get_jwt_identity())

    db.session.delete(doctor)
    db.session.commit()

    return jsonify({'result': 'success', 'data': doctor.email})


@doctors.route('/doctor', methods=['PUT'])
@jwt_required
def update():
    doctor = getUser(get_jwt_identity())
    if doctor is None:
        return jsonify({'result': 'failed', 'error': 'doctor does not exist!'})

    if 'name' in request.form:
        doctor.name = request.form['name']
    if 'lastName' in request.form:
        doctor.lastName = request.form['lastName']

    db.session.commit()

    return jsonify({'result': 'success', 'data': JSONTool.object_as_dict(doctor)})