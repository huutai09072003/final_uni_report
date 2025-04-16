import { usePage, router } from '@inertiajs/react'
import { useState } from 'react'
import useNotificationCable from '../hooks/useNotificationCable'

export default function Index() {
  const { notifications: initialNotifications, auth } = usePage().props
  const [notifications, setNotifications] = useState(initialNotifications)

  useNotificationCable(auth.user.id, (newNotification) => {
    setNotifications((prev) => [newNotification, ...prev])
  })

  const markAsRead = (id) => {
    router.put(`/notifications/${id}`, { read: true }, {
      onSuccess: () => {
        setNotifications((prev) =>
          prev.map((n) => (n.id === id ? { ...n, read: true } : n))
        )
        window.dispatchEvent(
          new CustomEvent('notification:markAsRead', { detail: { notificationId: id } })
        )
      },
    })
  }

  return (
    <div className="p-5">
      <h1 className="text-2xl font-bold mb-4">Thông báo của bạn</h1>

      <div className="space-y-4">
        {notifications.length === 0 && (
          <p className="text-gray-600">Không có thông báo nào.</p>
        )}
        {notifications.map((n) => (
          <div
            key={n.id}
            className={`p-4 rounded border ${n.read ? 'bg-gray-100' : 'bg-white border-blue-400'}`}
          >
            <div className="font-semibold">{n.title}</div>
            <div className="text-gray-600">{n.body}</div>
            <div className="text-gray-500 text-sm">{n.created_at}</div>
            {!n.read && (
              <button
                onClick={() => markAsRead(n.id)}
                className="mt-2 px-3 py-1 bg-blue-600 text-white text-sm rounded"
              >
                Đánh dấu đã đọc
              </button>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}