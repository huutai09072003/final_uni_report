import React from 'react';
import Form from './Form';

export default function Edit({ user }) {
  return (
    <div className="max-w-xl mx-auto mt-10 p-5">
      <h1 className="text-2xl font-bold mb-6 text-center">Edit Account</h1>
      <Form
        initialUser={user}
        endpoint={`/user`}
        method="put"
        isEdit={true}
      />
    </div>
  );
}
