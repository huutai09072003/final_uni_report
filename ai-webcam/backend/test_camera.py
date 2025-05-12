from ultralytics import YOLO
import cv2

# Load model từ file YOLOv11n (custom hoặc official)
model = YOLO("type_newest_ver.pt")  # model YOLOv11n

# Mở webcam
cap = cv2.VideoCapture(0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # Chạy detection
    results = model(frame)

    # Hiển thị kết quả
    annotated_frame = results[0].plot()
    cv2.imshow("YOLOv11n Webcam Detection", annotated_frame)

    if cv2.waitKey(1) == 27:  # ESC
        break

cap.release()
cv2.destroyAllWindows()
