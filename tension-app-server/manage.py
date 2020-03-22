# manage.py
import os

from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand

from app import app, db
from model import Doctor, Patient, Pressure, Weight


migrate = Migrate(app, db)
manager = Manager(app)

# migrations
manager.add_command('db', MigrateCommand)


@manager.command
def create_db():
    """Creates the db tables."""
    db.create_all()


@manager.command
def drop_db():
    """Drops the db tables."""
    db.drop_all()


@manager.command
def create_dummy():
    """Creates dummy data."""
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


if __name__ == '__main__':
    manager.run()
