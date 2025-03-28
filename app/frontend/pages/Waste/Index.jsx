import React from 'react';
import { usePage, Link } from '@inertiajs/react';

export default function Index() {
  const { props } = usePage();
  const { auth } = props;

  return (
    <div className="p-5">
      <h1 className="text-3xl font-bold mb-5 text-green-700">Green World - Waste Management</h1>
      
      <section className="mb-8">
        <p className="text-lg text-gray-700">
          Welcome to Green World! Upload a photo of waste to identify its type and get instructions on how to handle it properly.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">Identify Waste</h2>
        {auth?.user ? (
          <Link
            href="/wastes/identify"
            className="bg-green-600 text-white px-6 py-3 rounded-md hover:bg-green-700"
          >
            Start Identifying Waste
          </Link>
        ) : (
          <p className="text-gray-600">
            Please <Link href="/users/sign_in" className="text-green-600 hover:underline">log in</Link> to start identifying waste.
          </p>
        )}
      </section>

      <section className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-white p-4 rounded-md shadow">
          <h3 className="text-xl font-semibold text-green-600">Recyclable</h3>
          <p className="text-gray-600">Learn how to recycle plastic, paper, and more.</p>
        </div>
        <div className="bg-white p-4 rounded-md shadow">
          <h3 className="text-xl font-semibold text-green-600">Organic</h3>
          <p className="text-gray-600">Turn food waste into compost for your garden.</p>
        </div>
        <div className="bg-white p-4 rounded-md shadow">
          <h3 className="text-xl font-semibold text-green-600">Hazardous</h3>
          <p className="text-gray-600">Handle batteries and chemicals safely.</p>
        </div>
      </section>
    </div>
  );
}