import { common, red, orange } from "@mui/material/colors";
import { ThemeOptions } from "@mui/material";

export const APP_PRIMARY_COLOR = orange[500];
export const LIGHT_APP_TEXT_COLOR = common.black;
export const DARK_APP_TEXT_COLOR = common.white;

export const lightTheme: ThemeOptions = {
  palette: {
    mode: 'light',
    primary: {
      main: APP_PRIMARY_COLOR,
      dark: orange[900],
      light: orange[500],
      contrastText: LIGHT_APP_TEXT_COLOR,
    },
    secondary: {
      main: orange[500],
      dark: orange[900],
      light: orange[500],
      contrastText: LIGHT_APP_TEXT_COLOR,
    },
    error: {
      main: red[600],
      dark: red[900],
      light: red[500],
    },
  },
  transitions: {
    easing: {
      easeInOut: "cubic-bezier(0.4, 0, 0.2, 1)",
      easeOut: "cubic-bezier(0.0, 0, 0.2, 1)",
      easeIn: "cubic-bezier(0.4, 0, 1, 1)",
      sharp: "cubic-bezier(0.4, 0, 0.6, 1)",
    },
    duration: {
      shortest: 150,
      shorter: 200,
      short: 250,
      standard: 300,
      complex: 375,
      enteringScreen: 225,
      leavingScreen: 195,
    },
  },
};

export const darkTheme: ThemeOptions = {
  palette: {
    mode: 'dark',
    primary: {
      main: APP_PRIMARY_COLOR,
      dark: orange[900],
      light: orange[500],
      contrastText: DARK_APP_TEXT_COLOR,
    },
    secondary: {
      main: orange[500],
      dark: orange[900],
      light: orange[500],
      contrastText: DARK_APP_TEXT_COLOR,
    },
    error: {
      main: red[600],
      dark: red[900],
      light: red[500],
    },
  },
  transitions: {
    easing: {
      easeInOut: "cubic-bezier(0.4, 0, 0.2, 1)",
      easeOut: "cubic-bezier(0.0, 0, 0.2, 1)",
      easeIn: "cubic-bezier(0.4, 0, 1, 1)",
      sharp: "cubic-bezier(0.4, 0, 0.6, 1)",
    },
    duration: {
      shortest: 150,
      shorter: 200,
      short: 250,
      standard: 300,
      complex: 375,
      enteringScreen: 225,
      leavingScreen: 195,
    },
  },
};

export const themes: Record<'dark' | 'light', ThemeOptions> = {
  light: lightTheme,
  dark: darkTheme,
};