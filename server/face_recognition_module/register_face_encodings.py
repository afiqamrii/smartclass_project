# register_face.py
import face_recognition
import cv2
import json
import sys

def encode_image(image_path):
    img = cv2.imread(image_path)
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    encodings = face_recognition.face_encodings(img_rgb)
    if len(encodings) == 0:
        return None
    return encodings[0].tolist()

if __name__ == "__main__":
    image_path = sys.argv[1]
    encoding = encode_image(image_path)
    if encoding is None:
        print("ERROR: No face detected")
    else:
        print(json.dumps(encoding))
