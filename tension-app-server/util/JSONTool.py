from array import array

from sqlalchemy import inspect


def object_as_dict(obj):
    if hasattr(obj, 'toDict'):
        return obj.toDict()

    return {c.key: getattr(obj, c.key)
            for c in inspect(obj).mapper.column_attrs}


def list_as_dict(list):
    return [object_as_dict(x) for x in list]
