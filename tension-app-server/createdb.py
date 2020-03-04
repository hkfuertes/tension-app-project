from flask import Flask

from model import Patient, Doctor, Pressure, Weight
from model.db import db

from app import app

with app.test_request_context():
    db.init_app(app)
    db.create_all()

    doctor = Doctor(email="hkfuertes@gmail.com", password="gorilafeliz", name="Miguel", lastName="Fuertes")
    doctor.id = 1;
    patient = Patient(doctor=doctor, name='Javier', lastName='Fuertes', gender='male')
    patient.id = 1;
    pressure = Pressure(patient, None, 70, 120, 90)
    weight = Weight(patient, None, 120.6)

    db.session.add(doctor)
    db.session.add(patient)
    db.session.add(pressure)
    db.session.add(weight)
    db.session.commit()

