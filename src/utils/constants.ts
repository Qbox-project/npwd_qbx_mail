import { Mail } from '../types/mail';

export const MockMail: Mail[] = [
  {
    mailid: 2,
    sender: 'Eduardo',
    subject: 'Delivery Location',
    message:
      'Here is all info about the delivery, <br><br>Items: <br> 1x Weed Brick<br><br> Be on time!!<br><br>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.<br><br>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.<br><br>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.<br><br>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<br><br>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.<br><br>Eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.<br><br>Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos.<br><br>Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius.<br><br>Modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum.<br><br>Exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure.',
    read: 0,
    date: 1660745412000,
    button: {
      buttonEvent: 'qb-drugs:client:setLocation',
      enabled: true,
      buttonData: {
        dealer: 'Eduardo',
        itemData: {
          minrep: 0,
          item: 'weed_brick',
        },
        amount: 2,
        locationLabel: 'DR Kush',
        coords: {
          x: -1151.9300537109375,
          y: -1447.5899658203125,
          z: 4.71000003814697,
        },
      },
    },
  },
  {
    mailid: 1,
    sender: 'Billing Department',
    subject: 'Invoice Paid',
    message: 'Invoice Has Been Paid From Sienna Dunlap In The Amount Of $425',
    read: 1,
    date: 1660653186000.0,
  },
];
