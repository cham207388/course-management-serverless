import { useState } from "react";
import {
  Container, TextField, Button, Typography, Box
} from "@mui/material";
import AuthService from "../auth/AuthService";
import { useNavigate } from "react-router-dom";

const Signup = () => {
  const [form, setForm] = useState({ email: "", password: "" });
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
    setError("");
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await AuthService.signUp(form.email, form.password);
      navigate("/login"); // ✅ Redirect on success
    } catch (err) {
      setError("Signup failed. Maybe user already exists?");
      console.error(err);
    }
  };

  return (
    <Container maxWidth="sm" sx={{ mt: 5 }}>
      <Typography variant="h4" gutterBottom>Sign Up</Typography>
      <form onSubmit={handleSubmit}>
        <TextField
          label="Email"
          name="email"
          type="email"
          fullWidth
          required
          margin="normal"
          value={form.email}
          onChange={handleChange}
        />
        <TextField
          label="Password"
          name="password"
          type="password"
          fullWidth
          required
          margin="normal"
          value={form.password}
          onChange={handleChange}
        />
        {error && <Box color="error.main" mt={1}>{error}</Box>}
        <Button type="submit" variant="contained" color="primary" sx={{ mt: 2 }}>
          Sign Up
        </Button>
      </form>
    </Container>
  );
};

export default Signup;