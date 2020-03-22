from datetime import datetime

from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity, jwt_required

from model import Doctor, db, Patient, PatientUser
from util import JSONTool

from routes.auth import getUser

patients = Blueprint('patients_routes', __name__)


@patients.route('/patient', methods=['POST'])
@jwt_required
def create():
    user = getUser(get_jwt_identity())
    if(('email' in request.form) and ('password' in request.form)):
        date_time_obj = datetime.strptime(request.form['birthday'], '%d-%m-%Y')
        try:
            patientUser=PatientUser(
                name=request.form['name'],
                lastName=request.form['lastName'],
                email=request.form['email'],
                password=request.form['password'],
            )
            
            db.session.add(patientUser)
            db.session.commit()
        except Exception as error:
            db.session.flush()
            db.session.rollback()
            return jsonify({'result': 'failed', 'data': str(error.orig) + " for parameters" + str(error.params)})

        patient = Patient(
            doctor=user,
            id=patientUser.id,
            gender=request.form['gender'],
            height=request.form['height'],
            birthday=date_time_obj
        )
        db.session.add(patient)
        db.session.commit()

        p_json = JSONTool.object_as_dict(patient)
        p_json['name'] = patientUser.name
        p_json['lastName'] = patientUser.lastName
        p_json['email'] = patientUser.email

        return jsonify({'result': 'success', 'data': p_json})
    else:
        return jsonify({'result': 'failed', 'detail':'Email and Password are required!'})


@patients.route('/patient/<id>', methods=['GET'])
@jwt_required
def show(id):
    user = getUser(get_jwt_identity())
    patientUser = PatientUser.query.filter_by(id=id, deleted=False).first()
    
    if patientUser is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist or deleted!'})

    patient = Patient.query.filter_by(id=patientUser.id, doctor_id=user.id).first()

    if patient is None:
        return jsonify({'result': 'failed', 'error': 'Patient not belongs to doctor!'})

    p_json = JSONTool.object_as_dict(patient)
    p_json['name'] = patientUser.name
    p_json['lastName'] = patientUser.lastName
    p_json['email'] = patientUser.email

    return jsonify({'result': 'success', 'data': p_json})


# Anonymize the Patient to keep information
@patients.route('/patient/<id>', methods=['DELETE'])
@jwt_required
def delete(id):
    user = getUser(get_jwt_identity())
    patientUser = PatientUser.query.filter_by(id=id, deleted=False).first()

    if patientUser is None:
        return jsonify({'result': 'failed', 'error': 'Patient does not exist or deleted!'})

    patient = Patient.query.filter_by(id=patientUser.id, doctor_id=user.id).first()
    if patient.doctor_id != user.id:
        return jsonify({'result': 'failed', 'error': 'Patient not belongs to doctor!'})
    
    patientUser.deleted = True

    db.session.commit()

    return jsonify({'result': 'success'})



@patients.route('/patient/<id>', methods=['PUT'])
@jwt_required
def update(id):
    user = getUser(get_jwt_identity())
    patientUser = PatientUser.query.filter_by(id=id,deleted=False).first()
    patient = Patient.query.filter_by(id=patientUser.id, doctor_id=user.id).first()

    if (patientUser is None) or (patient is None):
        return jsonify({'result': 'failed', 'error': 'Patient does not exist, or does not belong to doctor!'})

    if 'name' in request.form:
        patientUser.name = request.form['name']
    if 'lastName' in request.form:
        patientUser.lastName = request.form['lastName']
    
    if 'height' in request.form:
        patient.height = request.form['height']
    if 'gender' in request.form:
        patient.gender = request.form['gender']
    if 'birthday' in request.form:
        patient.birthday = datetime.strptime(request.form['birthday'], '%Y-%m-%d')
    if 'treatment' in request.form:
        patient.treatment = request.form['treatment']
    if 'rythm_type' in request.form:
        patient.rythm_type = request.form['rythm_type']
    if 'limit_systolic' in request.form:
        patient.limit_systolic = request.form['limit_systolic']
    if 'limit_diastolic' in request.form:
        patient.limit_diastolic = request.form['limit_diastolic']
    if 'limit_pulse' in request.form:
        patient.limit_pulse = request.form['limit_pulse']
    
    if 'history' in request.form:
        patient.history = request.form['history']
    if 'erc' in request.form:
        patient.erc = request.form['erc'].lower() == 'true'
    if 'erc_fg' in request.form:
        patient.erc_fg = request.form['erc_fg']
    if 'asma' in request.form:
        patient.asma = request.form['asma'].lower() == 'true'
    if 'epoc' in request.form:
        patient.epoc = request.form['epoc'].lower() == 'true'
    if 'dm' in request.form:
        patient.dm = request.form['dm'].lower() == 'true'
    if 'dislipemia' in request.form:
        patient.dislipemia = request.form['dislipemia'].lower() == 'true'
    if 'isquemic_cardiopatia' in request.form:
        patient.isquemic_cardiopatia = request.form['isquemic_cardiopatia'].lower() == 'true'
    if 'prev_insuf_cardiaca' in request.form:
        patient.prev_insuf_cardiaca = request.form['prev_insuf_cardiaca'].lower() == 'true'


    db.session.commit()

    p_json = JSONTool.object_as_dict(patient)
    p_json['name'] = patientUser.name
    p_json['lastName'] = patientUser.lastName
    p_json['email'] = patientUser.email

    return jsonify({'result': 'success', 'data': p_json})


@patients.route('/patients')
@jwt_required
def list():
    user = getUser(get_jwt_identity())
    patients = Patient.query.filter_by(doctor_id=user.id).all()
    retVal = []
    for p in patients:
        current_patient = PatientUser.query.filter_by(id=p.id).first()
        p_json = JSONTool.object_as_dict(p)
        p_json['name'] = current_patient.name
        p_json['lastName'] = current_patient.lastName
        p_json['email'] = current_patient.email
        if(not current_patient.deleted):
            retVal.append(p_json)
    return jsonify({'result': 'success', 'data': retVal})
