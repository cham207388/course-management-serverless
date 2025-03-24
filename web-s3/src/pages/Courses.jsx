import { useEffect, useState } from "react";
import {
  Container,
  Typography,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableBody,
  Button,
  Box
} from "@mui/material";
import api from "../config/api";
import { Link } from "react-router-dom";
import dayjs from "dayjs";

function Courses() {
  const [courses, setCourses] = useState([]);

  useEffect(() => {
    api.get("/courses")
      .then((response) => setCourses(response.data))
      .catch((error) => console.error("Error fetching courses:", error));
  }, []);

  const handleDelete = (id) => {
    api.delete(`/courses/${id}`)
      .then(() => setCourses(courses.filter(course => course.id !== id)))
      .catch(error => console.error("Error deleting course:", error));
  };

  return (
    <Container sx={{ mt: 4 }}>
      <Typography variant="h4" gutterBottom>Courses</Typography>
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Domain</TableCell>
            <TableCell>Level</TableCell>
            <TableCell>Price ($)</TableCell>
            <TableCell>Start Date</TableCell>
            <TableCell>End Date</TableCell>
            <TableCell>Score</TableCell>
            <TableCell align="right">Actions</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {courses.map((course) => (
            <TableRow key={course.id}>
              <TableCell>{course.name}</TableCell>
              <TableCell>{course.domain}</TableCell>
              <TableCell>{course.level}</TableCell>
              <TableCell>{course.price.toFixed(2)}</TableCell>
              <TableCell>{dayjs(course.startDate).format("YYYY-MM-DD HH:mm")}</TableCell>
              <TableCell>{dayjs(course.endDate).format("YYYY-MM-DD HH:mm")}</TableCell>
              <TableCell>{course.score != null ? course.score : "-"}</TableCell>
              <TableCell align="right">
                <Box display="flex" gap={1}>
                  <Button component={Link} to={`/courses/${course.id}`} size="small" variant="outlined">
                    View
                  </Button>
                  <Button component={Link} to={`/edit-course/${course.id}`} size="small" color="primary" variant="contained">
                    Edit
                  </Button>
                  <Button onClick={() => handleDelete(course.id)} size="small" color="error" variant="outlined">
                    Delete
                  </Button>
                </Box>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </Container>
  );
}

export default Courses;