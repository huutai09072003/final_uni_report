import React, { useRef, useState } from "react";
import WebcamCapture from "./components/WebcamCapture";
import ResultDisplay from "./components/ResultDisplay";
import Webcam from "react-webcam";

const App: React.FC = () => {
  const webcamRef = useRef<Webcam>(null);
  const [result, setResult] = useState<string | null>(null);
  const [detectedImage, setDetectedImage] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const captureAndSend = () => {
    if (!webcamRef.current) return;

    const imageSrc = webcamRef.current.getScreenshot();
    if (!imageSrc) return;

    setIsLoading(true);

    fetch("http://localhost:8000/predict", {
      method: "POST",
      body: JSON.stringify({ image: imageSrc }),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((data) => {
        setResult(data.type);
        setDetectedImage(data.image);
      })
      .catch((err) => {
        console.error("Lỗi khi gửi ảnh:", err);
      })
      .finally(() => setIsLoading(false));
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-green-100 to-green-50 flex flex-col items-center py-10">
      <div className="container max-w-3xl mx-auto px-6">
        <h1 className="text-4xl font-extrabold text-green-700 mb-10 text-center drop-shadow-md">
          📸 Nhận diện rác thủ công
        </h1>

        <WebcamCapture webcamRef={webcamRef} />

        <button
          onClick={captureAndSend}
          disabled={isLoading}
          className={`w-full max-w-md mx-auto block py-3 px-6 rounded-full shadow-lg text-lg font-semibold transition duration-300 transform ${
            isLoading
              ? "bg-gray-400 cursor-not-allowed"
              : "bg-green-500 hover:bg-green-600 text-white hover:scale-105"
          }`}
        >
          {isLoading ? (
            <span className="flex items-center justify-center gap-2">
              <svg
                className="animate-spin h-5 w-5 text-white"
                viewBox="0 0 24 24"
              >
                <circle
                  className="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="4"
                />
                <path
                  className="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8v8h8a8 8 0 01-8 8 8 8 0 01-8-8z"
                />
              </svg>
              Đang xử lý...
            </span>
          ) : (
            "✅ Gửi ảnh để nhận diện"
          )}
        </button>

        <ResultDisplay result={result} detectedImage={detectedImage} />
      </div>
    </div>
  );
};

export default App;