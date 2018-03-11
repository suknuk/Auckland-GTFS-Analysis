/* eslint-disable no-console */
const RTM = require('satori-rtm-sdk');
const msgProcessor = require('./message');

const satoriEndpoint = 'wss://open-data.api.satori.com';// process.env.SATORI_ENDPOINT;
const satoriAppkey = 'C2593E9d1CCeeb8AdFDaF51Eb8f9b509';// process.env.SATORI_APPKEY;
const satoriChannel = 'new-zealand';

const client = new RTM(satoriEndpoint, satoriAppkey);
const subscription = client.subscribe(satoriChannel, RTM.SubscriptionMode.SIMPLE);

// Hook up to client connectivity state transitions
client.on('enter-connected', () => {
  console.info('Connected to Satori RTM!');
});
client.on('leave-connected', () => {
  console.warn('Disconnected from Satori RTM');
});
client.on('error', (error) => {
  let reason;
  if (error.body) {
    reason = `${error.body.error} - ${error.body.reason}`;
  } else {
    reason = 'unknown reason';
  }
  console.error(`RTM client failed: ${reason}`);
});

subscription.on('enter-subscribed', () => {
  // When subscription is established (confirmed by Satori RTM).
  console.info(`Subscribed to the channel: ${satoriChannel}`);
});
subscription.on('rtm/subscribe/error', (pdu) => {
  // When a subscribe error occurs.
  console.error(`Failed to subscribe: ${pdu.body.error} - ${pdu.body.reason}`);
});
subscription.on('rtm/subscription/data', (pdu) => {
  pdu.body.messages.forEach((msg) => {
    msgProcessor.processGTFS(msg);
  });
});

client.start();
