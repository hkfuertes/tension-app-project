# coding=utf-8

from sqlalchemy import Column, Integer, ForeignKey, DateTime, JSON, Float
from sqlalchemy.orm import relationship
from model.db import db
from datetime import datetime


class Weight(db.Model):
    __tablename__ = 'weights'

    timestamp = Column(DateTime, primary_key=True, default=datetime.now())
    patient_id = Column(Integer, ForeignKey('patients_info.id'), primary_key=True)
    weight = Column(Float)

    def __init__(self, patient, timestamp, weight):
        if(isinstance(patient, int)):
            self.patient_id = patient
        else:
            self.patient_id = patient.id
        self.timestamp = timestamp or datetime.now()
        self.weight = weight

    def toDict(self):
        return {
            'timestamp': self.timestamp.strftime("%Y-%m-%d %H:%M:%S"),
            'weight': self.weight,
        }

    def toInsertSql(self):
        return 'INSERT INTO weights (timestamp, patient_id, weight) VALUES ("' + self.timestamp.strftime('%Y-%m-%d 00:00:00') + '",' + str(self.patient_id) + ',' + str(self.weight) + ');'
