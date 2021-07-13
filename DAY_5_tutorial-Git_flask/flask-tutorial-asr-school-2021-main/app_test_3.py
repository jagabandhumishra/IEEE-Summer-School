from flask import Flask,request,jsonify

app = Flask(__name__)


books = [
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


@app.route('/parks', methods=['GET'])
def api_all():
    return jsonify(books)

app.run(debug=True)

