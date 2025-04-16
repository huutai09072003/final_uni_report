import { useState } from 'react'

export default function Identify() {
  const [image, setImage] = useState(null)
  const [uploadedImageUrl, setUploadedImageUrl] = useState(null)
  const [detectedImageUrl, setDetectedImageUrl] = useState(null)
  const [result, setResult] = useState(null)
  const [processing, setProcessing] = useState(false)
  const [error, setError] = useState(null)

  const resizeImage = (file, maxWidth = 512) =>
    new Promise((resolve, reject) => {
      const reader = new FileReader()
      reader.readAsDataURL(file)
      reader.onload = () => {
        const img = new Image()
        img.src = reader.result
        img.onload = () => {
          const canvas = document.createElement('canvas')
          const scaleFactor = maxWidth / img.width
          canvas.width = maxWidth
          canvas.height = img.height * scaleFactor

          const ctx = canvas.getContext('2d')
          ctx.drawImage(img, 0, 0, canvas.width, canvas.height)

          const resizedBase64 = canvas.toDataURL('image/jpeg', 0.8)
          resolve(resizedBase64)
        }
        img.onerror = reject
      }
      reader.onerror = reject
    })

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!image) return

    setProcessing(true)
    setError(null)
    setResult(null)
    setDetectedImageUrl(null)

    try {
      const resizedBase64 = await resizeImage(image)

      const response = await fetch('http://localhost:8000/predict', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ image: resizedBase64 }),
      })

      if (!response.ok) {
        throw new Error(`FastAPI lỗi: ${response.status}`)
      }

      const data = await response.json()
      setResult(data.types?.[0] || 'Unknown')
      setDetectedImageUrl(data.image)
    } catch (err) {
      setError(err.message)
    } finally {
      setProcessing(false)
    }
  }

  const handleImageChange = (e) => {
    const file = e.target.files[0]
    setImage(file)

    if (file) {
      const reader = new FileReader()
      reader.onloadend = () => setUploadedImageUrl(reader.result)
      reader.readAsDataURL(file)
    } else {
      setUploadedImageUrl(null)
    }
  }

  return (
    <div className="max-w-md mx-auto px-4 py-6">
      <h1 className="text-xl font-bold text-center mb-4">📷 Waste Identifier</h1>
      <form onSubmit={handleSubmit} encType="multipart/form-data" className="space-y-4">
        <div>
          <label htmlFor="image" className="block text-sm font-medium text-gray-700 mb-1">
            Upload Image
          </label>
          <input
            type="file"
            id="image"
            name="image"
            onChange={handleImageChange}
            accept="image/*"
            className="block w-full text-sm p-2 border border-gray-300 rounded-lg file:mr-3 file:bg-green-600 file:text-white file:px-3 file:py-1 file:rounded-full file:border-none"
            required
          />
          {error && <div className="text-red-500 text-sm mt-1">{error}</div>}
        </div>

        <button
          type="submit"
          disabled={processing || !image}
          className="w-full bg-green-600 text-white py-2 rounded-md hover:bg-green-700 disabled:bg-gray-400"
        >
          {processing ? 'Identifying...' : 'Identify'}
        </button>
      </form>

      {uploadedImageUrl && (
        <div className="mt-6">
          <h2 className="text-base font-semibold mb-2 text-gray-800">🖼 Original Image</h2>
          <img src={uploadedImageUrl} alt="Uploaded" className="rounded-lg border w-full" />
        </div>
      )}

      {detectedImageUrl && (
        <div className="mt-6">
          <h2 className="text-base font-semibold mb-2 text-gray-800">✅ Detected Image</h2>
          <img src={detectedImageUrl} alt="Detected" className="rounded-lg border w-full" />
        </div>
      )}

      {result && (
        <div className="mt-6 p-4 rounded-lg bg-gray-100 border text-center">
          <h2 className="text-base font-semibold mb-1">♻️ Waste Type</h2>
          <p className="text-lg font-bold text-green-700">{result}</p>
        </div>
      )}
    </div>
  )
}
