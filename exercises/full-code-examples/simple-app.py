from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/say_hello/{name}")
def say_hello(name):
    return {"Hello from Seattle": name}
  
