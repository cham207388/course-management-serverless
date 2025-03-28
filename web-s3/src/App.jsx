import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  Box,
  IconButton,
  Drawer,
  List,
  ListItem,
  ListItemButton,
  ListItemText,
  useTheme,
  useMediaQuery,
} from "@mui/material";
import { Outlet, Link, useNavigate } from "react-router-dom";
import MenuIcon from "@mui/icons-material/Menu";
import { useState } from "react";
import useAuth from "./context/useAuth"; // 🔐 Using new hook

function App() {
  const [mobileOpen, setMobileOpen] = useState(false);
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down("md"));
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  const drawer = (
    <Box sx={{ width: 250 }} onClick={handleDrawerToggle}>
      <List>
        <ListItem disablePadding>
          <ListItemButton component={Link} to="/">
            <ListItemText primary="Home" />
          </ListItemButton>
        </ListItem>
        <ListItem disablePadding>
          <ListItemButton component={Link} to="/courses">
            <ListItemText primary="Courses" />
          </ListItemButton>
        </ListItem>
        <ListItem disablePadding>
          <ListItemButton component={Link} to="/add-course">
            <ListItemText primary="Add Course" />
          </ListItemButton>
        </ListItem>

        {/* 🔐 Auth options (shown only if logged out) */}
        {!user && (
          <>
            <ListItem disablePadding>
              <ListItemButton component={Link} to="/login">
                <ListItemText primary="Login" />
              </ListItemButton>
            </ListItem>
            <ListItem disablePadding>
              <ListItemButton component={Link} to="/signup">
                <ListItemText primary="Sign Up" />
              </ListItemButton>
            </ListItem>
          </>
        )}
        {/* 🔓 Logout */}
        {user && (
          <ListItem disablePadding>
            <ListItemButton onClick={handleLogout}>
              <ListItemText primary="Logout" />
            </ListItemButton>
          </ListItem>
        )}
      </List>
    </Box>
  );

  return (
    <>
      <AppBar position="static">
        <Toolbar>
          {isMobile ? (
            <>
              <IconButton edge="start" color="inherit" aria-label="menu" onClick={handleDrawerToggle}>
                <MenuIcon />
              </IconButton>
              <Typography
                variant="h6"
                sx={{ flexGrow: 1 }}
                component={Link}
                to="/"
                style={{ textDecoration: "none", color: "inherit" }}
              >
                Course Management
              </Typography>
              <Drawer anchor="left" open={mobileOpen} onClose={handleDrawerToggle}>
                {drawer}
              </Drawer>
            </>
          ) : (
            <>
              <Typography
                variant="h6"
                sx={{ flexGrow: 1 }}
                component={Link}
                to="/"
                style={{ textDecoration: "none", color: "inherit" }}
              >
                Course Management
              </Typography>
              <Box>
                <Button color="inherit" component={Link} to="/courses">
                  Courses
                </Button>
                <Button color="inherit" component={Link} to="/add-course">
                  Add Course
                </Button>

                {!user ? (
                  <>
                    <Button color="inherit" component={Link} to="/login">
                      Login
                    </Button>
                    <Button color="inherit" component={Link} to="/signup">
                      Sign Up
                    </Button>
                  </>
                ) : (
                  <Button color="inherit" onClick={handleLogout}>
                    Logout
                  </Button>
                )}
              </Box>
            </>
          )}
        </Toolbar>
      </AppBar>
      <Outlet />
    </>
  );
}

export default App;