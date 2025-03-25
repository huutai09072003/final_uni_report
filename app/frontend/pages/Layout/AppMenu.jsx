import { Link } from '@inertiajs/react';
import React from 'react';

const AppMenu = () => {
  return (
<div className="fixed bottom-0 left-0 w-full h-12 bg-green-600 flex items-center justify-around">
      <Link href="/" className="text-white text-sm hover:underline">
        Trang chủ
      </Link>
      <Link href="/news" className="text-white text-sm hover:underline">
        Tin tức
      </Link>
      <Link href="/notifications" className="text-white text-sm hover:underline">
        Thông báo
      </Link>
      <Link href="/account" className="text-white text-sm hover:underline">
        Tài khoản
      </Link>
    </div>
  );
};

export default AppMenu;