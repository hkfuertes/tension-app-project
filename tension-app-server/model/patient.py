# coding=utf-8

from sqlalchemy import Column, String, Integer, Date, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from datetime import date

from model.db import db


class Patient(db.Model):
    __tablename__ = 'patients_info'

    RITMO_SINUSAL = 1
    FA_PAROXISTICA = 2
    FA_PERMANENTE = 3
    ALETEO_AURICULAR = 4

    id = Column(Integer, primary_key=True)
    gender = Column(String(8))
    birthday = Column(Date)
    height = Column(Integer)

    treatment = Column(Text)
    history = Column(Text)
    limit_systolic = Column(Integer)
    limit_diastolic = Column(Integer)
    limit_pulse = Column(Integer)
    rythm_type = Column(Integer)

    erc = Column(Boolean)
    erc_fg = Column(Integer)
    asma = Column(Boolean)
    epoc = Column(Boolean)
    dm = Column(Boolean)
    dislipemia = Column(Boolean)
    isquemic_cardiopatia = Column(Boolean)
    prev_insuf_cardiaca = Column(Boolean)

    measures = relationship('Pressure')
    weight = relationship('Weight')

    doctor_id = Column(Integer, ForeignKey('doctors.id'))

    def __init__(self, id, doctor,  gender, birthday=None, height=None):
        self.id = id
        self.gender = gender
        self.birthday = birthday
        self.height = height
        self.deleted = False
        self.doctor_id = doctor.id
        self.rythm_type = 0

    def toDict(self):
        return {
            'id': self.id,
            'height': self.height,
            'gender': self.gender,
            'treatment': self.treatment,
            'limit_systolic': self.limit_systolic,
            'limit_diastolic': self.limit_diastolic,
            'rythm_type': self.rythm_type,
            'birthday': self.birthday.strftime("%Y-%m-%d"),
            'history': self.history,
            'erc': self.erc,
            'erc_fg': self.erc_fg,
            'asma': self.asma,
            'epoc': self.epoc,
            'dm': self.dm,
            'dislipemia': self.dislipemia,
            'isquemic_cardiopatia': self.isquemic_cardiopatia,
            'prev_insuf_cardiaca': self.prev_insuf_cardiaca
        }

    def getAge(self, datetime=None):
        today = datetime or date.today()
        return today.year - self.birthday.year - ((today.month, today.day) < (self.birthday.month, self.birthday.day))
