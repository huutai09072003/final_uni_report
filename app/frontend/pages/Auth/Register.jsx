import React from 'react';
import { useForm } from '@inertiajs/react';
import { usePage } from '@inertiajs/react';

export default function Register() {
  const { props } = usePage();
  const { flash } = props;

  const { data, setData, post, processing, errors } = useForm({
    user: {
      email: '',
      password: '',
      password_confirmation: '',
    },
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    post('/users');
  };

  return (
    <div className="max-w-md mx-auto mt-10">
      <h1 className="text-2xl font-bold mb-5">Register</h1>

      {flash?.notice && (
        <div className="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-5">
          {flash.notice}
        </div>
      )}
      {flash?.error && (
        <div className="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-5">
          {flash.error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            Email
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={data.user.email}
            onChange={(e) => setData('user', { ...data.user, email: e.target.value })}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            required
          />
          {errors['user.email'] && (
            <div className="text-red-500 text-sm mt-1">{errors['user.email']}</div>
          )}
        </div>

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-gray-700">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            value={data.user.password}
            onChange={(e) => setData('user', { ...data.user, password: e.target.value })}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            required
          />
          {errors['user.password'] && (
            <div className="text-red-500 text-sm mt-1">{errors['user.password']}</div>
          )}
        </div>

        <div>
          <label htmlFor="password_confirmation" className="block text-sm font-medium text-gray-700">
            Confirm Password
          </label>
          <input
            type="password"
            id="password_confirmation"
            name="password_confirmation"
            value={data.user.password_confirmation}
            onChange={(e) => setData('user', { ...data.user, password_confirmation: e.target.value })}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            required
          />
          {errors['user.password_confirmation'] && (
            <div className="text-red-500 text-sm mt-1">{errors['user.password_confirmation']}</div>
          )}
        </div>

        <button
          type="submit"
          disabled={processing}
          className="w-full bg-green-600 text-white p-2 rounded-md hover:bg-green-700 disabled:bg-gray-400"
        >
          Register
        </button>
      </form>
    </div>
  );
}