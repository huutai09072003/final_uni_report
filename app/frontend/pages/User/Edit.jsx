import React from 'react';
import { useForm, usePage } from '@inertiajs/react';
import { Link } from '@inertiajs/react';
import Form from './Form';

export default function Edit() {
  const { props } = usePage();
  const { user, errors } = props;

  const { data, setData, put, processing } = useForm({
    name: user.name || '',
    email: user.email || '',
    location: user.location || '',
    points: user.points || 0,
    role: user.role || 'user',
    recycling_goal: user.recycling_goal || 0,
    password: '',
    password_confirmation: '',
  });

  const handleSubmit = (submitData) => {
    put('/user', {
      data: submitData, // Gửi dữ liệu đã bọc từ Form.jsx
      onSuccess: () => console.log('Update successful'),
      onError: (errors) => console.log('Update failed', errors),
    });
  };

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-5">Edit Account</h1>
      <Form
        user={{ ...data, setData }}
        errors={errors}
        onSubmit={handleSubmit}
        isEdit={true}
        processing={processing}
      />
      <div className="mt-4">
        <Link
          href="/user"
          className="bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700"
        >
          Back
        </Link>
      </div>
    </div>
  );
}