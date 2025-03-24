import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import {
  Container,
  Typography,
  CircularProgress,
  Alert,
  Box
} from "@mui/material";
import api from "../config/api";
import dayjs from "dayjs";

function Course() {
  const { id } = useParams();
  const [course, setCourse] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    api.get(`/courses/${id}`)
      .then((response) => {
        setCourse(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error(error);
        setError("Course not found or an error occurred.");
        setLoading(false);
      });
  }, [id]);

  if (loading) return <CircularProgress sx={{ display: "block", margin: "20px auto" }} />;
  if (error) return <Alert severity="error">{error}</Alert>;

  return (
    <Container sx={{ mt: 4 }}>
      <Typography variant="h4" gutterBottom>Course Details</Typography>
      <Box sx={{ mt: 2 }}>
        <Typography variant="h6">Name: {course.name}</Typography>
        <Typography variant="h6">Domain: {course.domain}</Typography>
        <Typography variant="h6">Level: {course.level}</Typography>
        <Typography variant="h6">Price: ${course.price.toFixed(2)}</Typography>
        <Typography variant="h6">
          Start Date: {dayjs(course.startDate).format("YYYY-MM-DD HH:mm")}
        </Typography>
        <Typography variant="h6">
          End Date: {dayjs(course.endDate).format("YYYY-MM-DD HH:mm")}
        </Typography>
        {course.score != null && (
          <Typography variant="h6">Score: {course.score}</Typography>
        )}
      </Box>
    </Container>
  );
}

export default Course;