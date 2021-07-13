# Flask tutorial | [IEEE SPS Summer School 2021](https://sites.google.com/iitdh.ac.in/vssasr2021) on ASR

## What is Flask?

- Flask is a web application framework written in Python. 
- It Manages HTTP requests and rendering HTML templates. 
- It gives all the functionality for implementing a web applications. 
- You can use Flask to deploy a ML model into production.
- It has Jinja template engine to dynamically build HTML pages using familiar Python concepts such as variables, loops, lists, and so on. 

## What is a web application?
A web application (or web app) is application software that runs on a web server.
It allows for information or functionality to be manipulated by other programs via the internet.

## Basic terminology:
- HTTP (Hypertext Transfer Protocol) is the primary means of communicating data on the web. 
  - Methods: ```GET```, which pulls data from a server, and ```POST```, which pushes new data to a server.
  - URL (Uniform Resource Locator) - An address for a resource on the web, such as ```https://realpython.com/python-web-applications/```. 
  - A URL consists of a protocol (```https://```), domain (```realpython.com```), and optional path (```/python-web-applications/```).
  - This is my request - ```https://realpython.com/python-web-applications/``` [base URL + path]
- If we want search for a query/data - 
  - ```https://www.youtube.com/watch?v=8yFVBuGcOe8```
  - The query parameters follow the ```?``` in the request

## Installation
```python
python --version
pip --version
python3.x -m pip install flask
```


Resources:
- https://flask.palletsprojects.com/en/2.0.x/
- https://programminghistorian.org/en/lessons/creating-apis-with-python-and-flask
- https://coddyschool.com/upload/Flask_Web_Development_Developing.pdf
- https://riptutorial.com/Download/flask.pdf
- https://www.fullstackpython.com/flask.html
