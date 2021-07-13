# Import Flask library
from flask import Flask, request

# Initialize the Flask application object, which contains data about the application and also methods, such as run().
app = Flask(__name__)

# Flask will map the HTTP requests [GET or POST] to Python functions. 

# In this case, we’ve mapped one URL path (‘/’) to one function - home. 

# When we connect to the Flask server at http://127.0.0.1:6060/, Flask checks if there is a match between the path provided and a defined function. 

# If the were deployed on a server associated with the www.xxx.com domain name, then navigating to http://www.xxx.com on your browser would trigger home() to run on the server.

# home, should be mapped to the path /, Flask runs the code in the home function and displays the returned result in the browser. 

# You can render HTML pages too.

# The process of mapping URLs to functions is called routing.

# GET requests : to send data from the application to the user
# POST requests : to receive data from a user
@app.route("/", methods=["GET", "POST"])
def home():

    return "hello"


@app.route("/about", methods=["GET", "POST"])
def about():

    return "About me"

@app.route('/<name>')
def user(name):
    return '<h1>Hello, %s!</h1>' % name

@app.route("/echo", methods=["GET"])
def echo():     
	to_echo = request.args.get("echo", "") 
	response = "{}".format(to_echo)     
	return response 

if __name__ == "__main__":
# app.run(); is a method to run the app. If debug=True we can see the exact error, if the code is malformed.
    app.run(debug=True, port=6060)

#http://127.0.0.1:6060/
