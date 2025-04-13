// src/config/api.js
import axios from "axios";
import AuthService from "../auth/AuthService";

const API_BASE_URL = "https://coursebe.alhagiebaicham.com/api/v2";

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
  withCredentials: true
});

// Attach the JWT from AuthContext/AuthService
api.interceptors.request.use(async (config) => {
  try {
    const session = await AuthService.getSession();
    const token = session.getIdToken().getJwtToken();
    config.headers.Authorization = `Bearer ${token}`;
  } catch (err) {
    console.warn("No session found, sending request without token", err);
  }
  return config;
});

export default api;
