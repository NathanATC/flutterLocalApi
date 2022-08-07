#API to manage the names and descriptions of drinks
#Using POST and DELETE requests to do so
#Retrieval of database data to json format for use on a site
#Uses SQLalchemy for db interaction

from flask import Flask, request
from flask_cors import CORS, cross_origin
app = Flask(__name__)
from flask_sqlalchemy import SQLAlchemy
app.config['CORS_HEADERS'] = 'Content-Type'

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
db = SQLAlchemy(app)

class Drink(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    desc = db.Column(db.String(120))
    
    def __repr__(self):
        return f"{self.name} - {self.desc}"

@app.route('/')
def index():
    return 'yes'

#Provides all data in db Drinks
@app.route('/drinks')
@cross_origin()
def get_drinks():
    drinks = Drink.query.all()
    
    output = []
    
    for drink in drinks:
        drink_data = {'name': drink.name, 'desc':drink.desc}
        output.append(drink_data)
        
    return{"drinks": output}

#Able to pull specific parts of the drinks route
@app.route('/drinks/<id>')
def get_drink(id):
    drink = Drink.query.get_or_404(id)
    return {"name": drink.name, "desc": drink.desc}

#POST a new drink
@app.route('/drinks', methods=['POST'])
def add_drink():
    drink = Drink(name=request.json['name'], desc=request.json['desc'])
    db.session.add(drink)
    db.session.commit()
    return {'id': drink.id}

#DELETE drinks
@app.route('/drinks/<id>', methods=['DELETE'])
def delete_drink(id):
    drink = Drink.query.get(id)
    if drink is None:
        return {"error": "DNE"}
    db.session.delete(drink)
    db.session.commit()
    return {"msg":"Delete Successful!"}