import React from 'react';
import { Typography, Box, useTheme } from '@mui/material';

const Header = () => {
  const theme = useTheme();

  return (
    <Box
      px={2}
      pt={2}
      sx={{ width: '100%', textAlign: 'left', backgroundColor: theme.palette.primary.main }}
    >
      <Typography sx={{ color: theme.palette.primary.contrastText }} paragraph variant={'h5'}>
        Mail
      </Typography>
    </Box>
  );
};

export default Header;