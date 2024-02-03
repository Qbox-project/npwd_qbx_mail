import { atom, selector, useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { Mail } from '../types/mail';
import { MockMail } from '../utils/constants';
import { isEnvBrowser } from '../utils/misc';
import fetchNui from '../utils/fetchNui';
import { ServerPromiseResp } from '../types/common';
import { recoilPersist } from 'recoil-persist';

const { persistAtom } = recoilPersist();

export const getMailItems = async () => {
  try {
    const resp = await fetchNui<ServerPromiseResp<Mail[]>>('npwd:qbx_mail:getMail');
    if (!resp.data) {
      console.log('no response data');
      return [];
    }
    return resp.data;
  } catch (e) {
    if (isEnvBrowser()) {
      return MockMail;
    }
    console.error(e);
    return [];
  }
}

export const mailStates = {
  mailItems: atom({
    key: 'mailItem',
    default: selector<Mail[]>({
      key: 'defaultMailItems',
      get: getMailItems,
    }),
    effects_UNSTABLE: [persistAtom],
  }),
  selectedMail: atom<Partial<Mail> | null>({
    key: 'selectedMail',
    default: null,
    effects_UNSTABLE: [persistAtom],
  }),
  modalVisibile: atom({
    key: 'mailModalVisible',
    default: false,
    effects_UNSTABLE: [persistAtom],
  }),
};

export const useMailsValue = () => useRecoilValue(mailStates.mailItems);
export const useSetMail = () => useSetRecoilState(mailStates.mailItems);

export const useSetModalVisible = () => useSetRecoilState(mailStates.modalVisibile);
export const useModalVisible = () => useRecoilState(mailStates.modalVisibile);

export const useSetSelectedMail = () => useSetRecoilState(mailStates.selectedMail);
export const useSelectedMail = () => useRecoilState(mailStates.selectedMail);