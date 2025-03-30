import React from 'react';
import { usePage, Link } from '@inertiajs/react';

export default function Index() {
  const { props } = usePage();
  const { wastes, pagination } = props;

  const getStatusColor = (status) => {
    switch (status) {
      case 'pending':
        return 'yellow-600';
      case 'identified':
        return 'blue-600';
      case 'processed':
        return 'green-600';
      default:
        return 'gray-600';
    }
  };

  console.log(getStatusColor(wastes[0]?.status));

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-5">Waste History</h1>
      <div className="space-y-4">
        {wastes.map((waste) => (
          <div
            key={waste.id}
            className={`p-6 bg-white border-l-4 border-${getStatusColor(waste.status)} rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200`}
          >
            <div className="flex items-start space-x-4">
              {waste.image_url ? (
                <img
                  src={waste.image_url}
                  alt="Waste"
                  className="w-20 h-20 object-cover rounded-md mt-1"
                />
              ) : (
                <div className="w-20 h-20 flex items-center justify-center bg-gray-100 text-gray-500 rounded-md mt-1">
                  No Image
                </div>
              )}

              <div className="flex-1">
                <div className="text-lg font-semibold text-gray-800">
                  Type: <span className="text-green-600">{waste.waste_type || 'N/A'}</span>
                </div>
                <div className="text-md text-gray-600">
                  Status: <span className={`font-medium text-${getStatusColor(waste.status)}`}>{waste.status}</span>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-6 flex justify-between items-center">
        <div>
          Showing {wastes.length} of {pagination.total_count} wastes
        </div>
        <div className="flex space-x-2">
          {pagination.current_page > 1 && (
            <Link
              href={`/wastes?page=${pagination.current_page - 1}`}
              className="px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300"
            >
              Previous
            </Link>
          )}

          {pagination.current_page < pagination.total_pages && (
            <Link
              href={`/wastes?page=${pagination.current_page + 1}`}
              className="px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300"
            >
              Next
            </Link>
          )}
        </div>
      </div>

      <Link
        href="/wastes/identify"
        className="mt-4 inline-block bg-green-600 text-white p-2 rounded-md hover:bg-green-700"
      >
        Identify New Waste
      </Link>
    </div>
  );
}