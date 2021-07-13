# Instruction for installing Git and Flask

**What is Git?**
- [Git](https://git-scm.com/) is a distributed version control system. It facilates merging of different source codes from different developers. And codes are distributed among developers. Make a copy of the repository in your local machine and work offline, and then push your changes to the server.

**What is Flask?**
- [Flask](https://flask.palletsprojects.com/en/2.0.x/) is a web application framework written in Python. It gives all the functionality for implementing a web applications. You can use Flask to deploy a ML model into production.

## Git installaton
- Linux
```shell
sudo apt-get update
sudo apt-get install git
git --version (for checking Git version)
```
- Windows
  - Download Git installer from following link and install
  - https://gitforwindows.org/

### Please create an account in [Github](https://github.com)

## Flask installation
```shell
python3 --version
python3.x -m pip install flask
```
if your python version is ```3.7```, then type
```shell
python3.7 -m pip install flask
```

