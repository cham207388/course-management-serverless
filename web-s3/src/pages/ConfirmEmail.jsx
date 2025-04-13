// pages/ConfirmEmail.jsx
import { useState } from "react";
import {
  Container, TextField, Button, Typography, Box
} from "@mui/material";
import AuthService from "../auth/AuthService";
import { useNavigate, useLocation } from "react-router-dom";

const ConfirmEmail = () => {
  const location = useLocation();
  const params = new URLSearchParams(location.search);
  const initialEmail = params.get("email") || "";
  const [email, setEmail] = useState(initialEmail);
  const [code, setCode] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleConfirm = async (e) => {
    e.preventDefault();
    try {
      await AuthService.confirmSignUp(email, code);
      navigate("/login");
    } catch (err) {
      setError("Confirmation failed. Invalid or expired code?");
      console.error(err);
    }
  };

  return (
    <Container maxWidth="sm" sx={{ mt: 5 }}>
      <Typography variant="h4">Confirm Your Email</Typography>
      <form onSubmit={handleConfirm}>
        <TextField
          label="Email"
          fullWidth
          margin="normal"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <TextField
          label="Verification Code"
          fullWidth
          margin="normal"
          required
          value={code}
          onChange={(e) => setCode(e.target.value)}
        />
        {error && <Box color="error.main">{error}</Box>}
        <Button type="submit" variant="contained" color="primary" sx={{ mt: 2 }}>
          Confirm Email
        </Button>
      </form>
    </Container>
  );
};

export default ConfirmEmail;
