// src/config/api.js
import axios from "axios";
import AuthService from "../auth/AuthService";

const API_BASE_URL = "https://api.alhagiebaicham.com";

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
    "Accept": "application/json"
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

// Add response interceptor to handle CORS errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      console.error("API Error:", error.response.data);
      console.error("Status:", error.response.status);
      console.error("Headers:", error.response.headers);
    } else if (error.request) {
      console.error("No response received:", error.request);
    } else {
      console.error("Error setting up request:", error.message);
    }
    return Promise.reject(error);
  }
);

export default api;
