// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

import * as functions from "firebase-functions";
import {TwitterApi} from "twitter-api-v2";
import * as admin from "firebase-admin";

admin.initializeApp();

const dbref = admin.firestore().doc("tokens/auth");
const rtd = admin.database().ref();

const twitterClient = new TwitterApi({
  clientId: process.env.CLIENT_ID as string,
  clientSecret: process.env.CLIENT_SECRET as string,
});

const callbackURL = `${process.env.URL as string}/callback`;
const tweetURL = `${process.env.URL as string}/tweet`;

export const auth = functions.https.onRequest(async (request, response) => {
  const {url, codeVerifier, state} = twitterClient.
      generateOAuth2AuthLink(callbackURL, {scope: ["tweet.read",
        "tweet.write", "users.read", "offline.access"]});
  await dbref.set({codeVerifier, state});
  console.log(url);
  response.redirect(url);
});

export const callback = functions.https.onRequest(async (req, res) => {
  const {state} = req.query;
  const code = req.query.code as string;
  const snapshot = await dbref.get();
  const {codeVerifier, state: storedState} = snapshot.data()!;

  if (state != storedState) {
    res.status(400).send("Token Mismatch");
  }

  const {accessToken, refreshToken} = await
  twitterClient.loginWithOAuth2({code, codeVerifier, redirectUri: callbackURL});
  await dbref.set({accessToken, refreshToken});
  res.redirect(tweetURL);
});

export const tweet = functions.pubsub.schedule("0 * * * *").
    timeZone("Asia/Kolkata")
    .onRun( async (context) => {
      const {refreshToken} = (await dbref.get()).data()!;
      const {client: refreshedClient, accessToken,
        refreshToken: newRefreshToken} =
    await twitterClient.refreshOAuth2Token(refreshToken);
      await dbref.set({accessToken, refreshToken: newRefreshToken});
      const {aqi1,temp1,humidity1} =  (await rtd.child("station1").get()).val();
      const {aqi2,temp2,humidity2} =  (await rtd.child("station2").get()).val();
      
      const currentTime = new Date();
      const currentOffset = currentTime.getTimezoneOffset();
      const ISTOffset = 330; // IST offset UTC +5:30
      const ISTTime = new Date(currentTime.getTime() + 
      (ISTOffset + currentOffset)*60000);
      const {data} = await refreshedClient.v2.
      tweet(`Weather Station 1\nTemperature: ${temp1} °C\nHumidity: ${humidity1} %\nAQI: ${aqi1}\n\nWeather Station 2\nTemperature: ${temp2} °C\nHumidity: ${humidity2} %\nAQI: ${aqi2}\n



      \n\n\n\nUpdated on ${ISTTime.toLocaleDateString()} - ${ISTTime.toLocaleTimeString()}`);
      console.log(data);
    });