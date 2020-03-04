from flask import Blueprint, jsonify, current_app as app
from flask_jwt_extended import jwt_required

from model import Pressure, Weight, Patient
from util import JSONTool

stats = Blueprint('stats_routes', __name__)


@stats.route('/stats/pressure', methods=['GET'])
@jwt_required
def pressure():
    db = app.config["db"]
    stat = db.session.query(Pressure, Patient).filter(Pressure.low != None, Pressure.high != None).filter(
        Patient.id == Pressure.patient_id).all()
    return_obj = [{
        'timestamp': x[0].timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        'high': x[0].high,
        'low': x[0].low,
        'pulse': x[0].pulse,
        'gender': x[1].gender,
        'height': x[1].height,
        'age': x[1].getAge()
    } for x in stat]

    return jsonify({'result': 'success', 'data': return_obj})


@stats.route('/stats/pulse', methods=['GET'])
@jwt_required
def pulse():
    db = app.config["db"]
    stat = db.session.query(Pressure, Patient).filter(
        Patient.id == Pressure.patient_id).all()
    return_obj = [{
        'timestamp': x[0].timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        'pulse': x[0].pulse,
        'gender': x[1].gender,
        'height': x[1].height,
        'age': x[1].getAge()
    } for x in stat]

    return jsonify({'result': 'success', 'data': return_obj})


@stats.route('/stats/weight', methods=['GET'])
@jwt_required
def weight():
    db = app.config["db"]
    stat = db.session.query(Weight, Patient).filter(
        Patient.id == Pressure.patient_id).all()
    return_obj = [{
        'timestamp': x[0].timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        'weight': x[0].weight,
        'gender': x[1].gender,
        'height': x[1].height,
        'age': x[1].getAge()
    } for x in stat]

    return jsonify({'result': 'success', 'data': return_obj})
