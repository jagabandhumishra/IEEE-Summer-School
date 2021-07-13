from flask import Flask,request,jsonify

app = Flask(__name__)


parks = [
    {'id': 0,
     'park': 'Kaziranga',
     'location': 'Golaghat, Nagaon district and Karbi Anglong',
     'year': '1974',
     'area': '858.98 km2'},
    {'id': 1,
     'park': 'Manas',
     'location': 'Kokrajhar, Chirang, Baksa, Bajali',
     'year': '1990',
     'area': '500 km2'},
    {'id': 2,
     'park': 'Nameri',
     'location': 'Sonitpur',
     'year': '1998',
     'area': '200 km2'},
    {'id': 3,
     'park': 'Orang',
     'location': 'Darrang',
     'year': '1999',
     'area': '79.28 km2'},
    {'id': 4,
     'park': 'Dibru-Saikhowa',
     'location': 'Dibrugarh and Tinsukia',
     'year': '1999',
     'area': '340 km2'},
    {'id': 5,
     'park': 'Dehing Patkai',
     'location': 'Dibrugarh and Tinsuki',
     'year': '2021',
     'area': '234.26 km2'},
    {'id': 6,
     'park': 'Raimona',
     'location': 'Kokrajhar',
     'year': '2021',
     'area': '422 km2'}
]


@app.route('/', methods=['GET'])
def home():
    return '''<h1>Archive for Naional Parks of Assam</h1>
<p>Welcome!</p>'''


@app.route('/parks/all', methods=['GET'])
def api_all():
    return jsonify(parks)


@app.route('/parks', methods=['GET'])
def api_id():
    # Check if an ID was provided as part of the URL.
    # If ID is provided, assign it to a variable.
    # If no ID is provided, display an error in the browser.
    if 'id' in request.args:
        id = int(request.args['id'])
    else:
        return "Error: No id field provided. Please specify an id."

    # Create an empty list for our results
    results = []

    # Loop through the data and match results that fit the requested ID.
    # IDs are unique, but other fields might return many results
    for park in parks:
        if park['id'] == id:
            results.append(park)

    # Use the jsonify function from Flask to convert our list of
    # Python dictionaries to the JSON format.
    return jsonify(results)

app.run(debug=True)

