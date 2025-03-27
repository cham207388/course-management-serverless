import { useState } from "react";
import {
  TextField, Button, Typography, Box
} from "@mui/material";
import { useNavigate, Link } from "react-router-dom";
import  useAuth  from "../context/useAuth";

const Login = () => {
  const [form, setForm] = useState({ email: "", password: "" });
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
    setError("");
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await login(form.email, form.password);
      navigate("/courses");
    } catch (err) {
      setError("Login failed. Check credentials.");
      console.error(err);
    }
  };

  return (
    <Box sx={{ maxWidth: 400, mx: "auto", mt: 4 }}>
      <Typography variant="h4" gutterBottom>Login</Typography>
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
          Login
        </Button>
      </form>
      <Typography sx={{ mt: 2 }}>
        Don&apos;t have an account? <Link to="/signup">Sign Up</Link>
      </Typography>
    </Box>
  );
};

export default Login;