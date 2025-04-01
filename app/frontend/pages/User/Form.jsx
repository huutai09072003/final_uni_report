import React, { useState } from 'react';
import axios from 'axios';
import { router } from '@inertiajs/react';

export default function Form({ initialUser = {}, endpoint, method = 'post', isEdit = false }) {
  const [user, setUser] = useState({
    name: initialUser.name || '',
    email: initialUser.email || '',
    location: initialUser.location || '',
    recycling_goal: initialUser.recycling_goal || 0,
    role: initialUser.role || 'user',
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

    // Tạo object mới để loại bỏ password nếu để trống
    const filteredUser = { ...user };
    if (!user.password) {
      delete filteredUser.password;
      delete filteredUser.password_confirmation;
    }

    axios({
      method,
      url: endpoint,
      data: { user: filteredUser },
    })
      .then(() => {
        router.visit('/user');
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
    <form onSubmit={handleSubmit} className="bg-white p-6 rounded-lg shadow-md space-y-6 max-w-xl mx-auto">
      <h2 className="text-xl font-semibold">Account Info</h2>

      <Field label="Name" id="name" value={user.name} onChange={setData} error={errors.name} required />
      <Field label="Email" id="email" value={user.email} onChange={setData} error={errors.email} required />
      <Field label="Location" id="location" value={user.location} onChange={setData} error={errors.location} />
      <Field label="Recycling Goal (kg)" id="recycling_goal" type="number" value={user.recycling_goal} onChange={setData} error={errors.recycling_goal} />
      <div>
        <label htmlFor="role" className="block text-sm font-medium text-gray-700">Role</label>
        <select
          id="role"
          value={user.role}
          onChange={(e) => setData('role', e.target.value)}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
        >
          <option value="user">User</option>
          <option value="collector">Collector</option>
          <option value="admin">Admin</option>
        </select>
        {errors.role && <div className="text-red-500 text-sm mt-1">{errors.role}</div>}
      </div>

      {isEdit && (
        <div className="pt-6 mt-6 border-t border-gray-200 space-y-4">
          <h2 className="text-xl font-semibold">Change Password</h2>
          <Field
            label="New Password"
            id="password"
            type="password"
            value={user.password}
            onChange={setData}
            error={errors.password}
          />
          <Field
            label="Confirm New Password"
            id="password_confirmation"
            type="password"
            value={user.password_confirmation}
            onChange={setData}
            error={errors.password_confirmation}
          />
        </div>
      )}

      {!isEdit && (
        <>
          <Field
            label="Password"
            id="password"
            type="password"
            value={user.password}
            onChange={setData}
            error={errors.password}
            required
          />
          <Field
            label="Confirm Password"
            id="password_confirmation"
            type="password"
            value={user.password_confirmation}
            onChange={setData}
            error={errors.password_confirmation}
            required
          />
        </>
      )}

      <button
        type="submit"
        disabled={processing}
        className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 disabled:bg-gray-400 w-full"
      >
        {processing ? 'Saving...' : isEdit ? 'Save Changes' : 'Register'}
      </button>
    </form>
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
