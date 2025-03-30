import React from 'react';
import Form from './Form';

export default function Show({ user }) {
  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-5">Account Details</h1>
      <Form
        user={{
          name: user.name,
          email: user.email,
          location: user.location,
          points: user.points,
          role: user.role,
          recycling_goal: user.recycling_goal,
          setData: () => {},
        }}
        isEdit={false}
      />
    </div>
  );
}