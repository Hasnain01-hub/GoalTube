import firebase_admin
from firebase_admin import credentials, firestore
import datetime
import re

# Initialize Firestore DB
cred = credentials.Certificate('firebase-private-key.json')
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()

def fetchUsers():
    users_ref = db.collection("Users")
    usersStream = users_ref.stream()
    usersData = []
    for user in usersStream:
        usersData.append(user.to_dict())
    return usersData


def fetchUser(id):
    user_ref = db.collection("Users").document(id).get()
    user = user_ref.to_dict()
    user["id"] = user_ref.id
    return user


def approveCourse(email, index, value):
    user = fetchUser(email)
    user['courses'][int(index)]['isApproved'] = bool(int(value))
    updatedArray = user['courses']
    db.collection("Users").document(email).update({
        "courses": updatedArray
    })
    if(value == '1'):
        db.collection("ApprovedCourses").document("allCourses").update({
            "courses": firestore.ArrayUnion([user['courses'][int(index)]])
        })

def fetchContacts():
    contacts_ref = db.collection("ContactUs")
    contactsStream = contacts_ref.stream()
    contacts = []
    for contact in contactsStream:
        item = contact.to_dict()
        item["id"] = contact.id
        item["date"] = datetime.datetime.fromisoformat(
            str(item["date"])).strftime("%d %b %Y %H:%M:%S")
        contacts.append(item)
    return contacts

def deleteContactFromFirebase(id):
    db.collection("ContactUs").document(id).delete()

