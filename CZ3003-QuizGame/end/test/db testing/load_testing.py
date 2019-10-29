import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import time
import concurrent.futures


def connection():
    cred = credentials.Certificate(
        './CZ3003-QuizGame/end/test/db testing/ServiceAccountKey.json')

    if not len(firebase_admin._apps):
        firebase_admin.initialize_app(cred, {
            'projectid': 'ssadquiz'
        })
    else:
        firebase_admin.get_app()

    return firestore.client()


""" Load testing code
def insertion(db, no_of_times):
    doc_ref = db.collection(u'users').document(u'testing')
    doc_ref.set({
        f'test{no_of_times}': u'haha'
    }, merge=True)
    return "Done inserting to db


t1 = time.perf_counter()

with concurrent.futures.ThreadPoolExecutor() as executor:
    db = connection()
    test = range(0, 1000)
    results = [executor.submit(insertion(db, i)) for i in test]

t2 = time.perf_counter()

print(f"done in {t2-t1}(s)")"
"""


def get_from_db(target):
    db = connection()
    doc_ref = db.collection(u'users').document(target)
    result = doc_ref.get()
    return result.to_dict()


def insert_to_db(document_name, value):
    try:
        db = connection()
        doc_ref = db.collection(u'users').document(document_name)
        doc_ref.set(value, merge=True)
        return f"Done inserting to db"
    except Exception as e:
        print(e)
        return


def delete_from_db(document_name):
    try:
        db = connection()
        db.collection(u'users').document(document_name).delete()
        return "Document deleted"
    except Exception as e:
        print(e)
        return
