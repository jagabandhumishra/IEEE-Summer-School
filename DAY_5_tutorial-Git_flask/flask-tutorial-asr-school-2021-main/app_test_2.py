from flask import Flask,render_template,url_for,request

app = Flask(__name__)

@app.route('/', methods=['GET'])
def home():
	return render_template('home_simple.html')

@app.route("/about", methods=["GET", "POST"])
def about():
    return render_template('about_me.html')

if __name__ == '__main__':
	app.run(debug=True)
