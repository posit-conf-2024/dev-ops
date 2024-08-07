from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd

# Load the model
model = joblib.load('penguin_model.joblib')

# Initialize FastAPI app
app = FastAPI()

# Define the request body
class PenguinFeatures(BaseModel):
    species: str
    sex: str
    bill_length_mm: float

# Define the endpoint for prediction
@app.post("/predict")
def predict(features: PenguinFeatures):
    # Map species and sex to the appropriate format used in training
    species_map = {"Adelie": 0, "Chinstrap": 1, "Gentoo": 2}
    sex_map = {"male": 0, "female": 1}

    try:
        species = species_map[features.species]
        sex = sex_map[features.sex]
    except KeyError:
        raise HTTPException(status_code=400, detail="Invalid species or sex")

    # Prepare the input data for the model
    input_data = pd.DataFrame([{
        "bill_length_mm": features.bill_length_mm,
        "species_Chinstrap": 1 if features.species == "Chinstrap" else 0,
        "species_Gentoo": 1 if features.species == "Gentoo" else 0,
        "sex_male": 1 if features.sex == "male" else 0,
    }])

    # Make prediction
    prediction = model.predict(input_data)[0]

    # Return the prediction
    return {"body_mass_g": prediction}