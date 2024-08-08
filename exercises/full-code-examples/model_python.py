"""
This script creates a linear regression model
to predict the body mass of palmer penguins
given their sex, species, and bill length in mm

"""
import duckdb
from palmerpenguins import penguins
from pandas import get_dummies
from sklearn.linear_model import LinearRegression

con = duckdb.connect("my-db.duckdb")
df = penguins.load_penguins()
df = con.execute("SELECT * FROM df").fetchdf().dropna()
con.close()

df.head(3)

X = get_dummies(df[["bill_length_mm", "species", "sex"]], drop_first=True)
y = df["body_mass_g"]

model = LinearRegression().fit(X, y)

print(f"R^2 {model.score(X,y)}")
print(f"Intercept {model.intercept_}")
print(f"Columns {X.columns}")
print(f"Coefficients {model.coef_}")
