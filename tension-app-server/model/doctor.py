# coding=utf-8

from sqlalchemy import Column, String, Integer, Date
from sqlalchemy.orm import relationship

from model.db import db


class Doctor(db.Model):
    __tablename__ = 'doctors'

    id = Column(Integer, primary_key=True, autoincrement=True)
    email = Column(String(255), unique=True)
    password = Column(String(255))
    refresh = Column(String(255))
    name = Column(String(20))
    lastName = Column(String(20))

    patients = relationship('Patient')

    def __init__(self, email, password, name, lastName, id=None):
        if(id):
            self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.lastName = lastName

    def toDict(self):
        return {
            'email': self.email,
            'name': self.name,
            'lastName': self.lastName
        }
