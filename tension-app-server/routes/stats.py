from flask import Blueprint, jsonify, current_app as app
from flask_jwt_extended import jwt_required

from model import Pressure, Weight, Patient
from util import JSONTool

stats = Blueprint('stats_routes', __name__)

sql = """select
patients_info.id,
pressures.timestamp,
ROUND(DATEDIFF(pressures.timestamp, patients_info.birthday)/365) as 'age',
high,low,pulse,
gender,height,
rythm_type,
erc, erc_fg, asma, epoc, dm, dislipemia, isquemic_cardiopatia, prev_insuf_cardiaca,
weights.weight, weights.timestamp as 'wtimestamp'
from patients_info, pressures, weights,
(select w2.patient_id, max(w2.timestamp) as 'ftimestamp' from weights w2 group by w2.patient_id) r
where patients_info.id = pressures.patient_id 
and patients_info.id = weights.patient_id 
and weights.timestamp= r.ftimestamp;
"""


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
        'age': x[1].getAge(x[0].timestamp)
    } for x in stat]

    return jsonify({'result': 'success', 'data': return_obj})


@stats.route('/stats', methods=['GET'])
@jwt_required
def all():
    db = app.config["db"]
    result = db.engine.execute(sql)
    return_obj = [{
        'timestamp': x.timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        'high': x.high,
        'low': x.low,
        'pulse': x.pulse,
        'gender': x.gender,
        'height': x.height,
        'age': int(x.age),
        'rythm_type': x.rythm_type,
        'erc': x.erc,
        'erc_fg': x.erc_fg,
        'asma': x.asma,
        'epoc': x.epoc,
        'dm': x.dm,
        'dislipemia': x.dislipemia,
        'isquemic_cardiopatia': x.isquemic_cardiopatia,
        'prev_insuf_cardiaca': x.prev_insuf_cardiaca,
        'latestWeight': x.weight,
        'lwTimestamp': x.wtimestamp.strftime("%Y-%m-%d %H:%M:%S")

    } for x in result]

    return jsonify({'result': 'success', 'data':return_obj})


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
        'age': x[1].getAge(x[0].timestamp)
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
        'age': x[1].getAge(x[0].timestamp)
    } for x in stat]

    return jsonify({'result': 'success', 'data': return_obj})
