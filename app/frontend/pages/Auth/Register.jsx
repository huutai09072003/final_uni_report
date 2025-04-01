import React from 'react';
import Form from '../User/Form';

export default function Register() {
  return (
    <div className="max-w-xl mx-auto mt-10 p-5">
      <h1 className="text-2xl font-bold mb-6 text-center">Create Account</h1>
      <Form
        endpoint="/users"
        method="post"
        isEdit={false}
      />
    </div>
  );
}
