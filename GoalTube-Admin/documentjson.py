import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json

# Initialize Firebase credentials
cred = credentials.Certificate('firebase-private-key.json')
firebase_admin.initialize_app(cred)

# Initialize Firestore database
db = firestore.client()

# Set the document ID you want to fetch data from
doc_id = 'omjadhav963@gmail.com'

# Get the document data
doc_ref = db.collection('Users').document(doc_id)
doc = doc_ref.get().to_dict()

# Export the data to a JSON file
filename = 'output.json'
with open(filename, 'w') as file:
    json.dump(doc, file)

print('Successfully exported data to {filename}')
