import React from 'react';
import { usePage, Link } from '@inertiajs/react';

export default function Index() {
  const { props } = usePage();
  const { auth } = props;

  return (
    <div className="min-h-screen bg-gradient-to-b from-green-50 to-white p-2 rounded-lg">
      {/* Header */}
      <header className="text-center mb-10">
        <h1 className="text-4xl font-extrabold text-green-800 drop-shadow-md">
          Green World - Waste Management
        </h1>
        <p className="mt-2 text-lg text-gray-600 max-w-2xl mx-auto">
          Welcome to Green World! Upload a photo of waste to identify its type and get instructions on how to handle it properly.
        </p>
      </header>

      <main className="max-w-6xl mx-auto">
        <section className="mb-12 bg-white p-6 rounded-xl shadow-lg border border-green-100">
          <h2 className="text-2xl font-semibold text-green-700 mb-4">Identify Waste</h2>
          {auth?.user ? (
            <div className="flex flex-col sm:flex-row gap-4">
              <Link
                href="/wastes/identify"
                className="bg-green-600 text-white px-6 py-3 rounded-md hover:bg-green-700 transition-colors duration-200 font-medium"
              >
                Start Identifying Waste
              </Link>
              <Link
                href="/wastes/"
                className="bg-teal-600 text-white px-6 py-3 rounded-md hover:bg-teal-700 transition-colors duration-200 font-medium"
              >
                View Waste History
              </Link>
            </div>
          ) : (
            <p className="text-gray-600">
              Please{' '}
              <Link href="auth/login" className="text-green-600 hover:underline font-medium">
                log in
              </Link>{' '}
              to start identifying waste or view your history.
            </p>
          )}
        </section>

        <section className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
          <div className="bg-white p-5 rounded-xl shadow-md hover:shadow-lg transition-shadow duration-200 border-t-4 border-green-500">
            <h3 className="text-xl font-semibold text-green-600 mb-2">Recyclable</h3>
            <p className="text-gray-600">Learn how to recycle plastic, paper, and more.</p>
          </div>
          <div className="bg-white p-5 rounded-xl shadow-md hover:shadow-lg transition-shadow duration-200 border-t-4 border-yellow-500">
            <h3 className="text-xl font-semibold text-yellow-600 mb-2">Organic</h3>
            <p className="text-gray-600">Turn food waste into compost for your garden.</p>
          </div>
          <div className="bg-white p-5 rounded-xl shadow-md hover:shadow-lg transition-shadow duration-200 border-t-4 border-red-500">
            <h3 className="text-xl font-semibold text-red-600 mb-2">Hazardous</h3>
            <p className="text-gray-600">Handle batteries and chemicals safely.</p>
          </div>
        </section>
      </main>
    </div>
  );
}