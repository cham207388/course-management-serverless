import { useEffect, useState } from "react";
import {
  Container,
  TextField,
  Button,
  Typography,
  MenuItem
} from "@mui/material";
import api from "../config/api";
import { useNavigate, useParams } from "react-router-dom";
import dayjs from "dayjs";

function EditCourse() {
  const { id } = useParams();
  const [course, setCourse] = useState({
    name: "",
    domain: "",
    level: "",
    price: "",
    startDate: "",
    endDate: "",
    score: ""
  });

  const navigate = useNavigate();

  useEffect(() => {
    api.get(`/courses/${id}`)
      .then((response) => {
        const data = response.data;
        setCourse({
          ...data,
          startDate: dayjs(data.startDate).format("YYYY-MM-DDTHH:mm"),
          endDate: dayjs(data.endDate).format("YYYY-MM-DDTHH:mm")
        });
      })
      .catch((error) => console.error("Error fetching course:", error));
  }, [id]);

  const handleChange = (e) => {
    setCourse({ ...course, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    api.put(`/courses/${id}`, course)
      .then(() => navigate("/courses"))
      .catch(error => console.error("Error updating course:", error));
  };

  return (
    <Container sx={{ mt: 4 }}>
      <Typography variant="h4">Edit Course</Typography>
      <form onSubmit={handleSubmit}>
        <TextField
          label="Name"
          name="name"
          fullWidth
          margin="normal"
          value={course.name}
          onChange={handleChange}
          required
        />
        <TextField
          label="Domain"
          name="domain"
          fullWidth
          margin="normal"
          value={course.domain}
          onChange={handleChange}
          required
        />
        <TextField
          label="Level"
          name="level"
          select
          fullWidth
          margin="normal"
          value={course.level}
          onChange={handleChange}
          required
        >
          <MenuItem value="BEGINNER">BEGINNER</MenuItem>
          <MenuItem value="INTERMEDIATE">INTERMEDIATE</MenuItem>
          <MenuItem value="ADVANCE">ADVANCE</MenuItem>
        </TextField>
        <TextField
          label="Price"
          name="price"
          type="number"
          fullWidth
          margin="normal"
          value={course.price}
          onChange={handleChange}
          required
          slotProps={{
            input: {
              min: 0.01,
              step: 0.01,
            }
          }}
        />
        <TextField
          label="Start Date"
          name="startDate"
          type="datetime-local"
          fullWidth
          margin="normal"
          value={course.startDate}
          onChange={handleChange}
          required
          slotProps={{
            textField: {
              InputLabelProps: { shrink: true }
            }
          }}
        />
        <TextField
          label="End Date"
          name="endDate"
          type="datetime-local"
          fullWidth
          margin="normal"
          value={course.endDate}
          onChange={handleChange}
          required
          slotProps={{
            textField: {
              InputLabelProps: { shrink: true }
            }
          }}
        />
        <TextField
          label="Score"
          name="score"
          type="number"
          fullWidth
          margin="normal"
          value={course.score}
          onChange={handleChange}
          slotProps={{
            input: {
              min: 0,
              max: 100,
              step: 0.1
            }
          }}
        />
        <Button type="submit" variant="contained" color="primary" sx={{ mt: 2 }}>
          Update
        </Button>
      </form>
    </Container>
  );
}

export default EditCourse;