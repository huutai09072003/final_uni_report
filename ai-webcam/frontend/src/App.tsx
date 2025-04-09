import React, { useEffect, useState, useRef } from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginScreen from "./components/LoginScreen";
import WebcamCapture from "./components/WebcamCapture";
import ResultDisplay from "./components/ResultDisplay";
import ResultModal from "./components/ResultModal";
import Webcam from "react-webcam";

const MainApp: React.FC = () => {
  const webcamRef = useRef<Webcam>(null);
  const [result, setResult] = useState<string | null>(null);
  const [detectedImage, setDetectedImage] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [showModal, setShowModal] = useState(false);

  const captureAndSend = async () => {
    if (!webcamRef.current) return;
    const imageSrc = webcamRef.current.getScreenshot();
    if (!imageSrc) return;

    setIsLoading(true);

    try {
      const res = await fetch("http://localhost:8000/predict", {
        method: "POST",
        body: JSON.stringify({ image: imageSrc }),
        headers: {
          "Content-Type": "application/json",
        },
      });
      const data = await res.json();

      setResult(data.type);
      setDetectedImage(data.image);
      setShowModal(true);
    } catch (err) {
      console.error("Lỗi khi nhận diện:", err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleLogout = async () => {
    try {
      await fetch("http://localhost:3000/users/sign_out", {
        method: "DELETE",
        credentials: "include",
        headers: { Accept: "application/json" },
      });
    } catch (e) {
      console.error(e);
    } finally {
      localStorage.removeItem("user");
      window.location.href = "/login";
    }
  };

  return (
    <div className="min-h-screen bg-green-50 py-10 flex flex-col items-center">
      <h1 className="text-3xl font-bold mb-6 text-green-700">
        ♻️ Ứng dụng nhận diện rác
      </h1>

      <WebcamCapture webcamRef={webcamRef} />

      <button
        onClick={captureAndSend}
        disabled={isLoading}
        className="mt-4 bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-full"
      >
        {isLoading ? "⏳ Đang xử lý..." : "📸 Nhận diện"}
      </button>

      <ResultDisplay result={result} detectedImage={detectedImage} />

      {showModal && (
        <ResultModal
          result={result}
          onClose={() => setShowModal(false)}
          onLogout={handleLogout}
        />
      )}
    </div>
  );
};

const App: React.FC = () => {
  const [user, setUser] = useState<{ name: string } | null>(null);

  useEffect(() => {
    const userData = localStorage.getItem("user");
    if (userData) {
      setUser(JSON.parse(userData));
    }
  }, []);

  const handleLoginSuccess = (user: { name: string }) => {
    setUser(user);
  };

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/login" />} />
        <Route
          path="/login"
          element={
            user ? (
              <Navigate to="/app" />
            ) : (
              <LoginScreen
                onLoginSuccess={handleLoginSuccess}
                redirectTo="/app"
              />
            )
          }
        />
        <Route
          path="/app"
          element={user ? <MainApp /> : <Navigate to="/login" />}
        />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
