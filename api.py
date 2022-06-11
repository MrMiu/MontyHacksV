import numpy as np
from flask import Flask, jsonify, request
import pickle

app = Flask(__name__)
model = pickle.load(open('notebooks/finalized_model_1.pkl', 'rb'))

buses = [
    {
        "number_plate": "NAX 123",
        "manufacturer": "Toyota",
        "model": "Hiace",
        "year": "2009",
        "capcity": 18
    },
    {
        "number_plate": "LX Z19",
        "manufacturer": "Ford",
        "model": "FordX",
        "year": "2010",
        "capcity": 45
    } 
]

@app.route('/fireprediction')
def get_fire():
    soil = request.args.get('soil_temperature')
    wind = request.args.get("wind_speed")
    dew = request.args.get("dew_point")
    humidity = request.args.get("rel_humidity")
    temp = request.args.get("temperature")
    precip = request.args.get("precipitation")

    prediction = model.predict(soil, wind, dew, humidity, temp, precip)
    output = prediction
    return jsonify(output)

@app.route('/smokeprediction')
#def get_smoke():

@app.route('/buses/<int:index>')
def get_bus(index):
    bus = buses[index]
    return jsonify(bus)

@app.route('/buses', methods=['POST'])
def add_bus():
    bus = request.get_json()
    buses.append(bus)
    return bus

@app.route('/buses/<int:index>', methods=['PUT'])
def update_bus(index):
    bus_to_update = request.get_json()
    buses[index] = bus_to_update
    return jsonify(buses[index])

@app.route('/buses/<int:index>', methods=['DELETE'])
def delete_bus(index):
    deleted = buses.pop(index)
    return jsonify(deleted), 200

if __name__ == '__main__':
    app.run()