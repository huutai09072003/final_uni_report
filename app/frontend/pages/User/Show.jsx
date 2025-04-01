import React from 'react';
import { router } from '@inertiajs/react';

export default function Show({ user }) {
  const handleEdit = () => {
    router.visit(`/user/edit`);
  };

  return (
    <div className="p-5 max-w-xl mx-auto bg-white rounded-lg shadow">
      <h1 className="text-2xl font-bold mb-5 text-center">Account Details</h1>

      <div className="space-y-4 text-sm text-gray-700">
        <Item label="Name" value={user.name} />
        <Item label="Email" value={user.email} />
        <Item label="Location" value={user.location || '—'} />
        <Item label="Points" value={user.points} />
        <Item label="Role" value={user.role} />
        <Item label="Recycling Goal" value={user.recycling_goal || '—'} />
      </div>

      <div className="mt-8 flex justify-between">
        <button
          onClick={handleEdit}
          className="bg-blue-600 hover:bg-blue-700 text-white py-2 px-4 rounded-md"
        >
          Edit Account
        </button>

        <button
          onClick={handleEdit}
          className="bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-md"
        >
          Settings
        </button>
      </div>
    </div>
  );
}

function Item({ label, value }) {
  return (
    <div className="flex justify-between border-b pb-2">
      <span className="font-medium">{label}</span>
      <span className="text-right text-gray-900">{value}</span>
    </div>
  );
}
