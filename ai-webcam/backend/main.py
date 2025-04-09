from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import base64
import numpy as np
from io import BytesIO
from PIL import Image
import cv2

# ✅ Dùng YOLOv8 từ ultralytics
from ultralytics import YOLO

app = FastAPI()

# CORS setup
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

model = YOLO("best.pt")

NAMES = model.names if hasattr(model, "names") else ["Object"]

class ImageInput(BaseModel):
    image: str

@app.post("/predict")
def predict(input: ImageInput):
    # Decode ảnh
    base64_data = input.image.split(",")[1]
    image_data = base64.b64decode(base64_data)
    image = Image.open(BytesIO(image_data)).convert("RGB")
    img_array = np.array(image)

    # Detect
    results = model(img_array, imgsz=640)[0]
    img_annotated = results.plot()

    label = "Unknown"
    if results.boxes:
        cls_id = int(results.boxes.cls[0])
        label = NAMES[cls_id]

    # Encode ảnh trả về
    _, buffer = cv2.imencode(".jpg", img_annotated)
    encoded_img = base64.b64encode(buffer).decode("utf-8")
    data_url = f"data:image/jpeg;base64,{encoded_img}"

    return {
        "type": label,
        "image": data_url
    }
