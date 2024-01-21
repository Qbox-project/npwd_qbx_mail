import App from "./src/App";
import { MailIcon, NotificationIcon } from "./icon";

export const path = "/mail";
export default () => ({
  id: "mail",
  nameLocale: "Mail",
  color: "#fff",
  backgroundColor: "#333",
  path,
  icon: MailIcon,
  app: App,
  notificationIcon: NotificationIcon
});
