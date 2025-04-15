import React, { useState } from 'react';
import axios from 'axios';
import { router } from '@inertiajs/react';

export default function Register() {
  const [user, setUser] = useState({
    name: '',
    email: '',
    location: '',
    recycling_goal: 0,
    password: '',
    password_confirmation: '',
  });

  const [errors, setErrors] = useState({});
  const [processing, setProcessing] = useState(false);

  const setData = (field, value) => {
    setUser({ ...user, [field]: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setProcessing(true);
    setErrors({});

    axios.post('/users', { user })
      .then(() => {
        // 👉 Redirect về login page nếu thành công
        router.visit('/auth/login');
      })
      .catch((error) => {
        if (error.response?.data?.errors) {
          setErrors(error.response.data.errors);
        } else {
          console.error(error);
        }
      })
      .finally(() => {
        setProcessing(false);
      });
  };

  return (
    <div className="max-w-xl mx-auto mt-10 p-5">
      <h1 className="text-2xl font-bold mb-6 text-center">Create Account</h1>
      <form onSubmit={handleSubmit} className="bg-white p-6 rounded-lg shadow-md space-y-6 max-w-xl mx-auto">
        <Field label="Name" id="name" value={user.name} onChange={setData} error={errors.name} required />
        <Field label="Email" id="email" value={user.email} onChange={setData} error={errors.email} required />
        <Field label="Location" id="location" value={user.location} onChange={setData} error={errors.location} />
        <Field label="Recycling Goal (kg)" id="recycling_goal" type="number" value={user.recycling_goal} onChange={setData} error={errors.recycling_goal} />
        <Field label="Password" id="password" type="password" value={user.password} onChange={setData} error={errors.password} required />
        <Field label="Confirm Password" id="password_confirmation" type="password" value={user.password_confirmation} onChange={setData} error={errors.password_confirmation} required />

        <button
          type="submit"
          disabled={processing}
          className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 disabled:bg-gray-400 w-full"
        >
          {processing ? 'Registering...' : 'Register'}
        </button>
      </form>
    </div>
  );
}

function Field({ label, id, value, onChange, type = 'text', error, required = false }) {
  return (
    <div>
      <label htmlFor={id} className="block text-sm font-medium text-gray-700">{label}</label>
      <input
        type={type}
        id={id}
        value={value}
        onChange={(e) => onChange(id, e.target.value)}
        className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
        required={required}
      />
      {error && <div className="text-red-500 text-sm mt-1">{error}</div>}
    </div>
  );
}
