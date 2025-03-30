import { Link, usePage } from '@inertiajs/react';
import React from 'react';

const AppMenu = () => {
  const { props } = usePage();
  const { auth } = props;
  const currentPath = window.location.pathname;

  const handleClick = (e, path) => {
    if (currentPath === path) {
      e.preventDefault();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  return (
    <div className="fixed bottom-0 left-0 w-full h-12 bg-green-600 flex items-center justify-around rounded-t-lg shadow-md">
      {auth?.user ? (
        <>
          {/* Home */}
          <Link
            href="/"
            onClick={(e) => handleClick(e, '/')}
            className={`flex flex-col items-center justify-center text-white w-10 h-10 rounded-full hover:bg-green-700 transition-colors duration-200 ${
              currentPath === '/' ? 'bg-green-700' : ''
            }`}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M3 12l9-9 9 9M5 10v10a1 1 0 001 1h3a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1h3a1 1 0 001-1V10"
              />
            </svg>
            <span className="text-xs mt-0.5">Home</span>
          </Link>

          {/* Notifications */}
          <Link
            href="/notifications"
            onClick={(e) => handleClick(e, '/notifications')}
            className={`flex flex-col items-center justify-center text-white w-10 h-10 rounded-full hover:bg-green-700 transition-colors duration-200 ${
              currentPath === '/notifications' ? 'bg-green-700' : ''
            }`}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
              />
            </svg>
            <span className="text-xs mt-0.5">Notifications</span>
          </Link>

          {/* Account */}
          <Link
            href="/user"
            onClick={(e) => handleClick(e, '/user')}
            className={`flex flex-col items-center justify-center text-white w-10 h-10 rounded-full hover:bg-green-700 transition-colors duration-200 ${
              currentPath.startsWith('/user') ? 'bg-green-700' : ''
            }`}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
              />
            </svg>
            <span className="text-xs mt-0.5">Account</span>
          </Link>
        </>
      ) : (
        <div className="flex space-x-6">
          {window.location.pathname === 'auth/login' ? (
            <Link
              href="auth/login"
              onClick={(e) => handleClick(e, 'auth/login')}
              className={`flex flex-col items-center justify-center text-white w-10 h-10 rounded-full hover:bg-green-700 transition-colors duration-200 ${
                currentPath === 'auth/login' ? 'bg-green-700' : ''
              }`}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-5 w-5"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"
                />
              </svg>
              <span className="text-xs mt-0.5">Login</span>
            </Link>
          ) : (
            <Link
              href="/users/sign_up"
              onClick={(e) => handleClick(e, '/users/sign_up')}
              className={`flex flex-col items-center justify-center text-white w-10 h-10 rounded-full hover:bg-green-700 transition-colors duration-200 ${
                currentPath === '/users/sign_up' ? 'bg-green-700' : ''
              }`}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-5 w-5"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"
                />
              </svg>
              <span className="text-xs mt-0.5">Register</span>
            </Link>
          )}
        </div>
      )}
    </div>
  );
};

export default AppMenu;