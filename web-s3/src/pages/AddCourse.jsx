import { useState } from "react";
import {
  Container,
  TextField,
  Button,
  Typography,
  MenuItem
} from "@mui/material";
import api from "../config/api";
import { useNavigate } from "react-router-dom";

function AddCourse() {
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

  const handleChange = (e) => {
    setCourse({ ...course, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    api
      .post("/courses", course)
      .then(() => navigate("/courses"))
      .catch((error) => console.error("Error adding course:", error));
  };

  return (
    <Container sx={{ mt: 4 }}>
      <Typography variant="h4">Add Course</Typography>
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
              min: 0.0,
              max: 100.0,
              step: 0.1
            }
          }}
        />
        <Button type="submit" variant="contained" color="primary" sx={{ mt: 2 }}>
          Submit
        </Button>
      </form>
    </Container>
  );
}

export default AddCourse;