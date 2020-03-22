from datetime import datetime

from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity, jwt_required

from model import Doctor, db, Pressure, Weight
from model.patient import Patient
from util import JSONTool

from routes.auth import getUser

from rsmq import RedisSMQ

import os

measures = Blueprint('measures_routes', __name__)


'''
    MEASURE ENDPOINTS
'''


@measures.route('/patient/<id>/pulse', methods=['POST'])
@jwt_required
def pulse_add(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    if 'pulse' not in request.form:
        return jsonify({'result': 'failed', 'error': 'At least pulse is needed!'})

    pressure = Pressure(patient, None, request.form['pulse'])
    db.session.add(pressure)
    db.session.commit()

    return jsonify({'result': 'success'})


@measures.route('/patient/<id>/pressure', methods=['POST'])
@jwt_required
def pressure_add(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    if 'pulse' not in request.form:
        return jsonify({'result': 'failed', 'error': 'At least pulse is needed!'})

    pressure = Pressure(patient, None,
                        request.form['pulse'],
                        (('high' in request.form) and request.form['high']) or None,
                        (('low' in request.form) and request.form['low']) or None,
                        )
    db.session.add(pressure)
    db.session.commit()

    return jsonify({'result': 'success'})


@measures.route('/patient/<id>/pressure', methods=['GET'])
@jwt_required
def pressure_get(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    pressure = Pressure.query.filter_by(patient_id=patient.id).all()

    return jsonify({'result': 'success', 'data': JSONTool.list_as_dict(pressure)})


@measures.route('/patient/<id>/pulse', methods=['GET'])
@jwt_required
def pulse_get(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    pressure = Pressure.query.filter_by(patient_id=patient.id, high=None, low=None).all()

    return jsonify({'result': 'success', 'data': JSONTool.list_as_dict(pressure)})


@measures.route('/patient/<id>/weight', methods=['POST'])
@jwt_required
def weight_add(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    if 'weight' not in request.form:
        return jsonify({'result': 'failed', 'error': 'weight key not found in request!'})

    weight = Weight(patient, None, request.form['weight'])
    db.session.add(weight)
    db.session.commit()

    return jsonify({'result': 'success'})


@measures.route('/patient/<id>/weight', methods=['GET'])
@jwt_required
def weight_get(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    weight = Weight.query.filter_by(patient_id=patient.id).all()

    return jsonify({'result': 'success', 'data': JSONTool.list_as_dict(weight)})

