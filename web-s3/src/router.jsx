import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import Home from "./pages/Home";
import Courses from "./pages/Courses";
import Course from "./pages/Course";
import AddCourse from "./pages/AddCourse";
import EditCourse from "./pages/EditCourse";
import Login from "./pages/Login";
import SignUp from "./pages/SignUp";
import PrivateRoute from "./components/PrivateRoute";

const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      { index: true, element: <Home /> },
      { path: 'login', element: <Login /> },
      { path: 'signup', element: <SignUp /> },

      {
        path: 'courses',
        element: (
          <PrivateRoute>
            <Courses />
          </PrivateRoute>
        ),
      },
      {
        path: 'courses/:id',
        element: (
          <PrivateRoute>
            <Course />
          </PrivateRoute>
        ),
      },
      {
        path: 'add-course',
        element: (
          <PrivateRoute>
            <AddCourse />
          </PrivateRoute>
        ),
      },
      {
        path: 'edit-course/:id',
        element: (
          <PrivateRoute>
            <EditCourse />
          </PrivateRoute>
        ),
      },
    ],
  },
]);

export default router;