# coding=utf-8

from sqlalchemy import Column, Integer, ForeignKey, DateTime, JSON
from sqlalchemy.orm import relationship
from model.db import db
from datetime import datetime


class Pressure(db.Model):
    __tablename__ = 'pressures'

    timestamp = Column(DateTime, primary_key=True, default=datetime.now())
    patient_id = Column(Integer, ForeignKey('patients_info.id'), primary_key=True)
    # This are going to be AVG
    high = Column(Integer)
    low = Column(Integer)
    pulse = Column(Integer)

    def __init__(self, patient, timestamp, pulse, high=None, low=None):
        self.timestamp = timestamp or datetime.now()
        if(isinstance(patient, int)):
            self.patient_id = patient
        else:
            self.patient_id = patient.id
        self.high = high
        self.low = low
        self.pulse = pulse

    def toDict(self):
        return {
            'timestamp': self.timestamp.strftime("%Y-%m-%d %H:%M:%S"),
            'high': self.high,
            'low': self.low,
            'pulse': self.pulse
        }

    def toInsertSql(self):
        return 'INSERT INTO pressures (timestamp, patient_id, high, low, pulse) VALUES ("'+self.timestamp.strftime('%Y-%m-%d 00:00:00')+'",'+str(self.patient_id)+','+str(self.high)+','+str(self.low)+','+str(self.pulse)+');'

