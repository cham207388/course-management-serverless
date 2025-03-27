import React, { useEffect, useState } from "react";
import AuthContext from "./AuthContext";
import AuthService from "../services/AuthService";

const AuthProvider = ({ children }) => {
  const [auth, setAuth] = useState({ user: null, token: null, loading: true });

  useEffect(() => {
    AuthService.getSession()
      .then((session) => {
        setAuth({
          user: session.getIdToken().payload.email,
          token: session.getIdToken().getJwtToken(),
          loading: false,
        });
      })
      .catch(() => {
        setAuth({ user: null, token: null, loading: false });
      });
  }, []);

  const login = async (email, password) => {
    const { token, user } = await AuthService.signIn(email, password);
    setAuth({ user: user.getUsername(), token, loading: false });
  };

  const logout = () => {
    AuthService.signOut();
    setAuth({ user: null, token: null, loading: false });
  };

  return (
    <AuthContext.Provider value={{ ...auth, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export default AuthProvider;