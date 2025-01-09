import './App.css';
import Layout from './layout/layout';
import AppRoute from './route/appRoute';
import { Provider, useDispatch, useSelector } from 'react-redux'
import { useNavigate } from 'react-router-dom';
import { login } from './redux/userSlice';
import { BACKEND_URL } from './const/default';
import { useEffect } from 'react';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { initSA } from './redux/saSlice';

function App() {
  const email = localStorage.getItem('email');
  const password = localStorage.getItem('password');
  const user = useSelector(state => state.user);
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
  const getPaper = async () => {
    try {
      const backendUrl = process.env.REACT_APP_BACKEND_URL || "http://localhost:8080/api/v1";
      const response = await fetch(`${backendUrl}/science_article/${user.id}`, {
        method: "GET",
      });

      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }

      const data = await response.json();
      const info = data.data.filter(item => !item.deleteAt);
      dispatch(initSA(info));
    } catch (error) {
      console.error("Error fetching papers:", error.message);
    }
  };
  useEffect(() => {
    SignIN();
    // getPaper();
  }, [user]);
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
