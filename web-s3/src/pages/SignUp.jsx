import { useState } from "react";
import {
  TextField, Button, Typography, Box
} from "@mui/material";
import AuthService from "../auth/AuthService";
import { useNavigate, Link } from "react-router-dom";

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
    <Box sx={{ maxWidth: 400, mx: 'auto', mt: 4 }}>
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
      <Typography sx={{ mt: 2 }}>
        Already have an account? <Link to="/login">Sign In</Link>
      </Typography>
    </Box>
  );
};

export default Signup;