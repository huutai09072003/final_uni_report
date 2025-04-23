#!/bin/bash

echo "▶️ Starting FastAPI backend (ai-webcam)..."
cd ai-webcam/backend
uvicorn main:app --host=0.0.0.0 --port=8000 &

echo "▶️ Starting Rails app with Puma..."
cd ../..  # quay về root
bundle exec puma -C config/puma.rb
