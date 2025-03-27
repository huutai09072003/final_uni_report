import { Link, usePage } from '@inertiajs/react';
import React from 'react';

const AppMenu = () => {
  const { props } = usePage();
  const { auth } = props;
  return (
    <div className="fixed bottom-0 left-0 w-full h-12 bg-green-600 flex items-center justify-around rounded-t-lg shadow-md">
      {auth?.user ? (
        <>
        <Link href="/" className="text-white text-sm hover:underline">
          Trang chủ
        </Link>
        <Link href="/notifications" className="text-white text-sm hover:underline">
          Thông báo
        </Link>
        <Link href="/account" className="text-white text-sm hover:underline">
          Tài khoản
        </Link>
        </>
      ) : (
        <div className="flex space-x-4">
          {window.location.pathname === '/users/sign_in' ? (
            <>
              <div className="text-white text-lg hover:underline">
                Login
              </div>
            </>
          ) : (
            <>
              <div className="text-white text-lg hover:underline">
                Register
              </div>
            </>
          )}
        </div>
      )}
    </div>
  );
};

export default AppMenu;