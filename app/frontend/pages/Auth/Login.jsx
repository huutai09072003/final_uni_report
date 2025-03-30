import { useForm } from '@inertiajs/react';

export default function Login() {

  const { data, setData, post, processing, errors } = useForm({
    user: {
      email: '',
      password: '',
    },
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    post('https://picture-it.ngrok.io/users/sign_in');
  };

  return (
    <div className="max-w-md mx-auto mt-10">
      <h1 className="text-2xl font-bold mb-5">Login</h1>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            Email
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={data.user.email}
            onChange={(e) => setData('user', { ...data.user, email: e.target.value })}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            required
          />
          {errors['user.email'] && (
            <div className="text-red-500 text-sm mt-1">{errors['user.email']}</div>
          )}
        </div>

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-gray-700">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            value={data.user.password}
            onChange={(e) => setData('user', { ...data.user, password: e.target.value })}
            className="mt-1 block w-full p-2 border border-gray-300 rounded-md"
            required
          />
          {errors['user.password'] && (
            <div className="text-red-500 text-sm mt-1">{errors['user.password']}</div>
          )}
        </div>

        <button
          type="submit"
          disabled={processing}
          className="w-full bg-green-600 text-white p-2 rounded-md hover:bg-green-700 disabled:bg-gray-400"
        >
          Login
        </button>
      </form>
    </div>
  );
}