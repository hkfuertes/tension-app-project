from datetime import datetime

from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity, jwt_required

from model import Doctor, db
from model.patient import Patient
from util import JSONTool

from routes.auth import getUser

patients = Blueprint('patients_routes', __name__)


@patients.route('/patient', methods=['POST'])
@jwt_required
def create():
    user = getUser(get_jwt_identity())
    date_time_obj = datetime.strptime(request.form['birthday'], '%d-%m-%Y')
    patient = Patient(
        user,
        name=request.form['name'],
        lastName=request.form['lastName'],
        gender=request.form['gender'],
        height=request.form['height'],
        birthday=date_time_obj
    )
    db.session.add(patient)
    db.session.commit()
    return jsonify({'result': 'success', 'data': JSONTool.object_as_dict(patient)})


@patients.route('/patient/<id>', methods=['GET'])
@jwt_required
def show(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, deleted=False).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist or deleted!'})

    if patient.doctor_id != user.id:
        return jsonify({'result': 'failed', 'error': 'Patient not belongs to doctor!'})

    return jsonify({'result': 'success', 'data': JSONTool.object_as_dict(patient)})


# Anonymize the Patient to keep information
@patients.route('/patient/<id>', methods=['DELETE'])
@jwt_required
def delete(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, deleted=False).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist or deleted!'})

    if patient.doctor_id != user.id:
        return jsonify({'result': 'failed', 'error': 'Patient not belongs to doctor!'})
    
    patient.deleted = True

    db.session.commit()

    return jsonify({'result': 'success'})



@patients.route('/patient/<id>', methods=['PUT'])
@jwt_required
def update(id):
    user = getUser(get_jwt_identity())
    patient = Patient.query.filter_by(id=id, doctor_id=user.id, deleted=False).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    if 'name' in request.form:
        patient.name = request.form['name']
    if 'lastName' in request.form:
        patient.lastName = request.form['lastName']
    if 'height' in request.form:
        patient.height = request.form['height']
    if 'gender' in request.form:
        patient.gender = request.form['gender']
    if 'birthday' in request.form:
        patient.birthday = datetime.strptime(request.form['birthday'], '%Y-%m-%d')

    db.session.commit()

    return jsonify({'result': 'success', 'data': JSONTool.object_as_dict(patient)})


@patients.route('/patients')
@jwt_required
def list():
    user = getUser(get_jwt_identity())
    patients = Patient.query.filter_by(doctor_id=user.id, deleted=False).all()
    return jsonify({'result': 'success', 'data': JSONTool.list_as_dict(patients)})
