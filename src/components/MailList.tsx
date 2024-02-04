import React, { useEffect } from 'react';
import { Box, List, ListItemButton, Typography, useTheme } from '@mui/material';
import { useMailsValue, useSetSelectedMail, useSetModalVisible, useSetMail, getMailItems } from '../atoms/mail-atoms';
import { Mail } from '../types/mail';
import { useMailAPI } from '../hooks/useMailAPI';
import { useMailActions } from '../hooks/useMailActions';
import { useNuiEvent } from '../hooks/useNuiEvent';

const MailList = () => {
  const mails = useMailsValue();
  const theme = useTheme();
  const isDarkMode = theme.palette.mode === 'dark';
  const setMails = useSetMail();
  const setMail = useSetSelectedMail();
  const setModalVisible = useSetModalVisible();
  const { updateRead } = useMailAPI();
  const { newMail } = useMailActions();

  useEffect(() => {
    getMailItems()
      .then(val => setMails(val))
      .catch(console.error);
  });

  useNuiEvent<Mail[]>('npwd_qbx_mail', 'newMail', (data) => {
    if (!data) return;

    newMail(data[0]);
  });

  const handleMailModal = (mail: Mail) => {
    if (!mail.read) {
      updateRead(mail.mailid);
    }

    setMail(mail);
    setModalVisible(true);
  };

  const mailDate = (dateData: number) => {
    const date = new Date(dateData);
    return (
      ('0' + date.getDate()).slice(-2) +
      '/' +
      ('0' + (date.getMonth() + 1)).slice(-2) +
      '/' +
      date.getFullYear()
    );
  };

  if (!mails || mails.length === 0) {
    return (
      <Box
        display='flex'
        justifyContent='center'
        alignItems='center'
        flexDirection='column'
        height='100%'
      >
        <Typography variant='h6' style={{ fontWeight: 300, color: theme.palette.primary.contrastText }}>
          You have no mail
        </Typography>
      </Box>
    );
  }

  return (
    <List disablePadding>
      {mails.map((mail: Mail) => (
        <ListItemButton
          key={mail.mailid}
          divider
          onClick={() => handleMailModal(mail)}
        >
          {mail.read === 0 ? (
            <Box
              sx={{
                bgcolor: '#4260f5',
                borderRadius: '10px',
                minWidth: '8px',
                minHeight: '8px',
                marginRight: '10px',
              }}
            />
          ) : (
            <Box
              sx={{
                borderRadius: '10px',
                minWidth: '8px',
                minHeight: '8px',
                marginRight: '10px',
              }}
            />
          )}

          <Box sx={{ display: 'flex', flexDirection: 'column', width: '100%' }}>
            <Box
              sx={{
                display: 'flex',
                flexDirection: 'row',
                width: '100%',
                justifyContent: 'space-between',
              }}
            >
              <Typography
                sx={{ fontWeight: '500', color: isDarkMode ? '#fff' : '#000' }}
              >
                {mail.sender}
              </Typography>
              <Box sx={{ display: 'flex', flexDirection: 'column' }}>
                <Typography
                  sx={{
                    color: isDarkMode ? '#dedede' : '#424242',
                    fontSize: '13px',
                  }}
                >
                  {mailDate(mail.date)}
                </Typography>
              </Box>
            </Box>
            <Typography sx={{ color: isDarkMode ? '#fff' : '#000' }}>
              {mail.subject}
            </Typography>
          </Box>
        </ListItemButton>
      ))}
    </List>
  );
};

export default MailList;