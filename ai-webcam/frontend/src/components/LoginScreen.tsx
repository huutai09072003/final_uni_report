import React, { useState } from "react";
import axios from "axios";

interface LoginProps {
  onLoginSuccess: (user: { name: string }) => void;
  redirectTo?: string;
}

const LoginScreen: React.FC<LoginProps> = ({ onLoginSuccess, redirectTo }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);

  const handleManualLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    try {
      const response = await axios.post(
        "http://localhost:3000/users/sign_in",
        {
          user: { email, password },
          webcam: true,
        },
        {
          withCredentials: true, // ⚠️ QUAN TRỌNG
          headers: {
            Accept: "application/json",
          },
        }
      );

      const data = response.data;
      const user = data.user || { name: email.split("@")[0] };

      localStorage.setItem("user", JSON.stringify(user));
      onLoginSuccess(user);

      if (redirectTo) {
        window.location.href = redirectTo;
      }
    } catch (err) {
      console.error("Login error:", err);
      setError("Sai email hoặc mật khẩu");
    }
  };

  return (
    <div className="min-h-screen flex flex-col justify-center items-center bg-green-100 px-4">
      <h2 className="text-3xl font-bold mb-6 text-green-700">🪪 Đăng nhập</h2>
      <form
        onSubmit={handleManualLogin}
        className="bg-white p-6 rounded-xl shadow-lg w-full max-w-sm"
      >
        <div className="mb-4">
          <label htmlFor="email" className="block text-sm text-gray-700">
            Email
          </label>
          <input
            id="email"
            type="email"
            className="mt-1 w-full border p-2 rounded"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>

        <div className="mb-4">
          <label htmlFor="password" className="block text-sm text-gray-700">
            Mật khẩu
          </label>
          <input
            id="password"
            type="password"
            className="mt-1 w-full border p-2 rounded"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        {error && <p className="text-red-500 text-sm mb-4">{error}</p>}

        <button
          type="submit"
          className="bg-green-600 text-white px-4 py-2 rounded-full w-full hover:bg-green-700 font-semibold"
        >
          🔐 Đăng nhập
        </button>
      </form>
    </div>
  );
};

export default LoginScreen;
