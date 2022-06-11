import numpy as np
from flask import Flask, jsonify, request
import pickle
import pandas as pd

app = Flask(__name__)
model = pickle.load(open('notebooks/finalized_model_2.pkl', 'rb'))

@app.route('/fireprediction')
def get_fire():
    soil = request.args.get('soil_temperature')
    wind = request.args.get("wind_speed")
    dew = request.args.get("dew_point")
    humidity = request.args.get("rel_humidity")
    temp = request.args.get("temperature")
    precip = request.args.get("precipitation")

    prediction = model.predict_proba(pd.DataFrame([[float(precip), float(temp), float(humidity), float(dew), float(wind), float(soil)]]))
    # jsonify(output)
    return str(prediction[0][1])

@app.route('/smokeprediction')
def get_smoke():
    return 1

if __name__ == '__main__':
    app.run()