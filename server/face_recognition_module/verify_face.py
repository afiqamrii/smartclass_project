# verify_face.py

import face_recognition
import cv2
import numpy as np
import json
import sys

def encode_image(image_path):
    img = cv2.imread(image_path)
    if img is None:
        print("[DEBUG] Error reading image at:", image_path, flush=True)
        print("ERROR: Could not read image", flush=True)
        sys.exit(1)

    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    encodings = face_recognition.face_encodings(img_rgb)
    if len(encodings) == 0:
        print("[DEBUG] No face detected in image.", flush=True)
        print("ERROR: No face detected", flush=True)
        sys.exit(1)
    return encodings[0]

def compare_embeddings(known_encoding, current_encoding, threshold=0.5):
    distance = face_recognition.face_distance([known_encoding], current_encoding)[0]
    return distance < threshold, distance

if __name__ == "__main__":
    try:
        encoding_json = sys.argv[1]  # From DB
        image_path = sys.argv[2]     # Uploaded image path

        print(f"[DEBUG] Received encoding_json (truncated): {encoding_json[:60]}", flush=True)
        print(f"[DEBUG] Received image_path: {image_path}", flush=True)

        known_encoding = np.array(json.loads(encoding_json))
        print(f"[DEBUG] Loaded known_encoding shape: {known_encoding.shape}", flush=True)

        current_encoding = encode_image(image_path)
        print(f"[DEBUG] Generated encoding for uploaded image.", flush=True)

        is_match, distance = compare_embeddings(known_encoding, current_encoding)
        print(f"[DEBUG] Comparison result - Match: {is_match}, Distance: {distance}", flush=True)

        if is_match:
            print(f"match:{distance}", flush=True)
        else:
            print(f"not_match:{distance}", flush=True)

    except Exception as e:
        print(f"[DEBUG] Exception occurred: {str(e)}", flush=True)
        print("ERROR: Exception during processing", flush=True)
        sys.exit(1)
