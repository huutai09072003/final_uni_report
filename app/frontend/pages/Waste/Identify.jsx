import React from 'react';
import { useForm } from '@inertiajs/react';

export default function Identify() {
  const { data, setData, post, processing, errors } = useForm({
    waste: {
      image: null,
    },
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    post('/waste');
  };

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-5">Identify Waste</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="image" className="block text-sm font-medium text-gray-700">
            Upload Waste Image
          </label>
          <input
            type="file"
            id="image"
            name="image"
            onChange={(e) => setData('waste', { ...data.waste, image: e.target.files[0] })}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            accept="image/*"
            required
          />
          {errors['waste.image'] && (
            <div className="text-red-500 text-sm mt-1">{errors['waste.image']}</div>
          )}
        </div>
        <button
          type="submit"
          disabled={processing}
          className="bg-green-600 text-white px-6 py-3 rounded-md hover:bg-green-700"
        >
          Identify
        </button>
      </form>
    </div>
  );
}