import React, { useState } from "react";
import { router } from "@inertiajs/react";

export default function Login() {
  const [user, setUser] = useState({
    email: "",
    password: "",
  });

  const [errors, setErrors] = useState({});
  const [processing, setProcessing] = useState(false);

  const setData = (field, value) => {
    setUser({ ...user, [field]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setProcessing(true);
    setErrors({});
  
    try {
      const response = await fetch("/users/sign_in", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
        body: JSON.stringify({
          user: {
            email: user.email,
            password: user.password,
          }
        }),
        credentials: "include",
      });
  
      const data = await response.json();
  
      if (!response.ok || !data.success) {
        setErrors(data.errors || { base: data.message || "Đăng nhập thất bại" });
        return;
      }

      window.location.href = "/";
  
    } catch (error) {
      console.error(error);
      setErrors({ base: "Lỗi mạng hoặc server" });
    } finally {
      setProcessing(false);
    }
  };

  return (
    <div className="max-w-md mx-auto mt-10 bg-white p-6 rounded-lg shadow">
      <h1 className="text-2xl font-bold mb-5 text-center">Login</h1>

      <form onSubmit={handleSubmit} className="space-y-4">
        <Field
          label="Email"
          id="email"
          type="email"
          value={user.email}
          onChange={setData}
          error={errors.email}
          required
        />

        <Field
          label="Password"
          id="password"
          type="password"
          value={user.password}
          onChange={setData}
          error={errors.password}
          required
        />

        {errors.base && (
          <div className="text-red-600 text-sm">{errors.base}</div>
        )}

        <button
          type="submit"
          disabled={processing}
          className="w-full bg-green-600 text-white p-2 rounded-md hover:bg-green-700 disabled:bg-gray-400"
        >
          {processing ? "Logging in..." : "Login"}
        </button>
      </form>
    </div>
  );
}

function Field({
  label,
  id,
  value,
  onChange,
  type = "text",
  error,
  required = false,
}) {
  return (
    <div>
      <label htmlFor={id} className="block text-sm font-medium text-gray-700">
        {label}
      </label>
      <input
        type={type}
        id={id}
        value={value}
        onChange={(e) => onChange(id, e.target.value)}
        required={required}
        className={`mt-1 block w-full p-2 border rounded-md ${
          error ? "border-red-500" : "border-gray-300"
        }`}
      />
      {error && <div className="text-red-500 text-sm mt-1">{error}</div>}
    </div>
  );
}
