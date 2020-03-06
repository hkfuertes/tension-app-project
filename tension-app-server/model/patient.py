# coding=utf-8

from sqlalchemy import Column, String, Integer, Date, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from datetime import date

from model.db import db


class Patient(db.Model):
    __tablename__ = 'patients'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(20))
    lastName = Column(String(20))
    gender = Column(String(8))
    birthday = Column(Date)
    height = Column(Integer)

    measures = relationship('Pressure')
    weight = relationship('Weight')

    deleted = Column(Boolean, default=False)

    doctor_id = Column(Integer, ForeignKey('doctors.id'))

    def __init__(self, doctor, name, lastName, gender, birthday=None, height=None):
        self.doctor_id = doctor.id
        self.name = name
        self.lastName = lastName
        self.gender = gender
        self.birthday = birthday
        self.height = height
        self.deleted = False

    def toDict(self):
        return {
            'id': self.id,
            'name': self.name,
            'lastName': self.lastName,
            'height': self.height,
            'gender': self.gender,
            'birthday': self.birthday.strftime("%Y-%m-%d"),
            'deleted': self.deleted
        }

    def getAge(self):
        today = date.today()
        return today.year - self.birthday.year - ((today.month, today.day) < (self.birthday.month, self.birthday.day))
