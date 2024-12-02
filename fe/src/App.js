import './App.css';
import Layout from './layout/layout';
import AppRoute from './route/appRoute';
import { Provider, useDispatch } from 'react-redux'
import { useNavigate } from 'react-router-dom';
import { login } from './redux/userSlice';
import { BACKEND_URL } from './const/default';
import { useEffect } from 'react';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

function App() {
  const email = localStorage.getItem('email');
  const password = localStorage.getItem('password')
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const SignIN = async () => {
    if (!email || !password) return;
    try {
      const res = await fetch(`${BACKEND_URL}/user/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json', // Specify JSON content type
        },
        body: JSON.stringify({
          Username: email, // Use consistent casing (e.g., "Username")
          Password: password,
        }),
      });
      if (res.status <= 204) {
        const data = await res.json();
        dispatch(login(data.data));
        // navigate('/');
      }
    }
    catch (err) {
      console.log(err);
    }
    finally {
      // setLoading(false);
    }
  }
  useEffect(() => {
    SignIN();
  }, []);
  return (
    <div className="App">
      <Layout>
        <AppRoute />
      </Layout>
      <ToastContainer
        position="bottom-right"
        autoClose={5000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="light"
      />
    </div>
  );
}

export default App;
