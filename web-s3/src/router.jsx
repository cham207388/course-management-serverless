import { createBrowserRouter } from "react-router-dom";
import App from "./App";
import Home from "./pages/Home";
import Courses from "./pages/Courses";
import Course from "./pages/Course";
import AddCourse from "./pages/AddCourse";
import EditCourse from "./pages/EditCourse";

const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      { index: true, element: <Home /> }, // ✅ Home as the default route
      { path: 'courses', element: <Courses /> },
      { path: 'courses/:id', element: <Course /> }, 
      { path: 'add-course', element: <AddCourse /> },
      { path: 'edit-course/:id', element: <EditCourse /> },
    ],
  },
]);

export default router;