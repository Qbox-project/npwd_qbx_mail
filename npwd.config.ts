import App from "./src/App";
import { MailIcon, NotificationIcon } from "./icon";

export const path = "/npwd_qbx_mail";
export default () => ({
  id: "npwd_qbx_mail",
  nameLocale: "Mail",
  color: "#fff",
  backgroundColor: "#333",
  path,
  icon: MailIcon,
  app: App,
  notificationIcon: NotificationIcon
});
