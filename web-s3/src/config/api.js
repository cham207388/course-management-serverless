import axios from "axios";
import { Auth } from "aws-amplify";

const API_BASE_URL = "https://coursebe.alhagiebaicham.com/api/v2"; //http://localhost:8000

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

api.interceptors.request.use(async (config) => {
  const session = await Auth.currentSession(); // or from localStorage
  const token = session.getIdToken().getJwtToken();
  config.headers.Authorization = `Bearer ${token}`;
  return config;
});
export default api;
