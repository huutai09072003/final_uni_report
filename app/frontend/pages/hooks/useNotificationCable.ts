import { useEffect, useRef } from 'react'

interface Notification {
  id: number
  title: string
  body: string
  read: boolean
  created_at: string
}

interface CableMessage {
  type?: string
  message?: Notification
}

export default function useNotificationCable(
  userId: number | undefined,
  onNewNotification: (n: Notification) => void
) {
  const wsRef = useRef<WebSocket | null>(null)

  useEffect(() => {
    if (!userId) return

    const ws = new WebSocket('ws://localhost:3000/cable')

    const subscribeMsg = {
      command: 'subscribe',
      identifier: JSON.stringify({ channel: 'NotificationChannel', user_id: userId }),
    }

    ws.onopen = () => {
      ws.send(JSON.stringify(subscribeMsg))
      console.log('🟢 Connected to NotificationChannel')
    }

    ws.onmessage = (event: MessageEvent) => {
      const response: CableMessage = JSON.parse(event.data)
      if (response.type === 'ping' || response.type === 'confirm_subscription') return

      const message = response.message
      console.log('📬 Received notification', message)

      if (message && 'title' in message && 'body' in message) {
        onNewNotification(message as Notification)
      }
    }

    ws.onclose = () => console.warn('🔌 Disconnected from NotificationChannel')
    ws.onerror = (err) => console.error('🚨 WebSocket error', err)

    wsRef.current = ws

    return () => {
      ws.close()
    }
  }, [userId, onNewNotification])
}