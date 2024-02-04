import { useCallback } from 'react';
import { useSnackbar } from '../snackbar/useSnackbar';
import { useMailActions } from './useMailActions';
import { ServerPromiseResp } from '../types/common';
import fetchNui from '../utils/fetchNui';
import { ButtonContent } from '../types/mail';

interface UpdateMailButtonParams {
  mailid: number;
  button: ButtonContent;
}

interface MailAPIValue {
  updateRead: (mailid: number) => Promise<void>;
  deleteMail: (mailid: number) => Promise<void>;
  updateMailButton: (data: UpdateMailButtonParams) => Promise<void>;
}

export const useMailAPI = (): MailAPIValue => {
  const { addAlert } = useSnackbar();
  const { updateReadState, deleteLocalMail, updateLocalButton } = useMailActions();

  const updateRead = useCallback(
    async (mailid: number) => {
      await fetchNui<ServerPromiseResp>('npwd:qbx_mail:updateRead', mailid);
      updateReadState(mailid);
    },
    [updateReadState]
  );

  const deleteMail = useCallback(
    async (mailid: number) => {
      const resp = await fetchNui<ServerPromiseResp>('npwd:qbx_mail:deleteMail', mailid);

      if (resp.status !== 'ok') {
        return addAlert({
          message: 'Failed to delete mail',
          type: 'error',
        });
      }

      deleteLocalMail(mailid);

      addAlert({
        message: 'Successfully deleted mail',
        type: 'success',
      });
    },
    [addAlert, deleteLocalMail]
  );

  const updateMailButton = useCallback(
    async ({ mailid, button }: UpdateMailButtonParams) => {
      const resp = await fetchNui<ServerPromiseResp>('npwd:qbx_mail:updateButton', {
          mailid,
          button,
        });
      if (resp.status !== 'ok') {
        return addAlert({
          message: 'Failed to accept mail',
          type: 'error',
        });
      }
      updateLocalButton(mailid);

      addAlert({
        message: 'Successfully accepted mail',
        type: 'success',
      });
    },
    [addAlert, updateLocalButton]
  );

  return { updateRead, deleteMail, updateMailButton };
};
