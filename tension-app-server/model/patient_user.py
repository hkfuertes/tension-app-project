# coding=utf-8

from sqlalchemy import Column, String, Integer, Date, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from datetime import date

from model.db import db


class PatientUser(db.Model):
    __tablename__ = 'patients'
    __table_args__ = (
        db.UniqueConstraint('email', name='patient_unique_email_constraint'),
    )

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(20))
    lastName = Column(String(20))
    email = Column(String(50))
    password = Column(String(100))

    deleted = Column(Boolean, default=False)

    def __init__(self, email, password, name, lastName, id=None):
        if(id):
            self.id = id
        self.name = name
        self.lastName = lastName
        self.deleted = False
        self.email = email
        self.password = password

    def toDict(self):
        return {
            'id': self.id,
            'name': self.name,
            'lastName': self.lastName,
            'email': self.email
        }
