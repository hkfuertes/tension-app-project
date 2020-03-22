from flask import Flask

from model import Patient, Doctor, Pressure, Weight, PatientUser, db

from app import app

with app.test_request_context():
    db.init_app(app)
    db.create_all()

