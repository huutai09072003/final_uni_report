import React from 'react';
import { Link } from '@inertiajs/react';

export default function Form({ user, errors = {}, onSubmit, isEdit = false, processing = false }) {
  const handleSubmit = (e) => {
    e.preventDefault();
    if (isEdit && onSubmit) {
      const submitData = {
        user: {
          name: user.name || '',
          email: user.email || '',
          location: user.location || '',
          points: user.points || 0,
          role: user.role || 'user',
          recycling_goal: user.recycling_goal || 0,
          password: user.password || '',
          password_confirmation: user.password_confirmation || '',
        },
      };
      onSubmit(submitData);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bg-white p-6 rounded-lg shadow-md space-y-6">
      <div>
        <label htmlFor="name" className="block text-sm font-medium text-gray-700">Name</label>
        <input
          type="text"
          id="name"
          value={user.name || ''}
          onChange={(e) => isEdit && user.setData('name', e.target.value)}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
          disabled={!isEdit}
          required
        />
        {errors.name && <div className="text-red-500 text-sm mt-1">{errors.name}</div>}
      </div>

      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700">Email</label>
        <input
          type="email"
          id="email"
          value={user.email}
          onChange={(e) => isEdit && user.setData('email', e.target.value)}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
          disabled={!isEdit}
          required
        />
        {errors.email && <div className="text-red-500 text-sm mt-1">{errors.email}</div>}
      </div>

      <div>
        <label htmlFor="location" className="block text-sm font-medium text-gray-700">Location</label>
        <input
          type="text"
          id="location"
          value={user.location || ''}
          onChange={(e) => isEdit && user.setData('location', e.target.value)}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
          disabled={!isEdit}
        />
        {errors.location && <div className="text-red-500 text-sm mt-1">{errors.location}</div>}
      </div>

      <div>
        <label htmlFor="points" className="block text-sm font-medium text-gray-700">Points</label>
        <input
          type="number"
          id="points"
          value={user.points || 0}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
          disabled
        />
      </div>

      <div>
        <label htmlFor="role" className="block text-sm font-medium text-gray-700">Role</label>
        <input
          type="text"
          id="role"
          value={user.role || 'user'}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
          disabled
        />
      </div>

      <div>
        <label htmlFor="recycling_goal" className="block text-sm font-medium text-gray-700">Recycling Goal (kg)</label>
        <input
          type="number"
          id="recycling_goal"
          value={user.recycling_goal || 0}
          onChange={(e) => isEdit && user.setData('recycling_goal', e.target.value)}
          className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
          disabled={!isEdit}
        />
        {errors.recycling_goal && <div className="text-red-500 text-sm mt-1">{errors.recycling_goal}</div>}
      </div>

      {isEdit && (
        <>
          <div>
            <label htmlFor="password" className="block text-sm font-medium text-gray-700">New Password (optional)</label>
            <input
              type="password"
              id="password"
              value={user.password || ''}
              onChange={(e) => user.setData('password', e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            />
            {errors.password && <div className="text-red-500 text-sm mt-1">{errors.password}</div>}
          </div>

          <div>
            <label htmlFor="password_confirmation" className="block text-sm font-medium text-gray-700">Confirm New Password</label>
            <input
              type="password"
              id="password_confirmation"
              value={user.password_confirmation || ''}
              onChange={(e) => user.setData('password_confirmation', e.target.value)}
              className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            />
            {errors.password_confirmation && <div className="text-red-500 text-sm mt-1">{errors.password_confirmation}</div>}
          </div>
        </>
      )}

      <div className="flex space-x-4">
        {isEdit ? (
          <button
            type="submit"
            disabled={processing}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 disabled:bg-gray-400"
          >
            {processing ? 'Saving...' : 'Save'}
          </button>
        ) : (
          <>
            <Link
              href="/user/edit"
              className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
            >
              Edit
            </Link>
            <Link
              href="/users/sign_out"
              method="delete"
              as="button"
              className="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700"
            >
              Logout
            </Link>
          </>
        )}
      </div>
    </form>
  );
}