const functions = require('firebase-functions');
const axios = require('axios');
const cors = require('cors');

const express = require('express');
const PORT = 3000;
const app = express();

//app.use(cors());
app.set('view engine', 'ejs')
app.set('views', './views')

app.get('/hello', (req, res) => {
    console.log('hmhm hello');
    res.send('hello world');
});

app.get('/:pin', (req, res) => {
  var pin = req.params.pin
  res.render('ogmeta', {data: pin})
});

app.post('/v1/users/issueAccessToken', (req, res) => {
    console.log(`hmhmhm post`);
    console.log(`hmhm ${req.query.code}`);
    let code = req.query.code;

    const params = {
        grant_type: 'authorization_code',
        //client_id: 'dk7xqov7w1',
        client_id: 'xxxxj',
        redirect_uri: 'http://localhost:8888/accesstoken',
        code: code,
        client_secret: 'xxxxx'
    };
    
    const data = Object.keys(params)
      .map((key) => `${key}=${encodeURIComponent(params[key])}`)
      .join('&');
    
    console.log('hmhm--2-2');
    console.log(`hmhm data ${data}`);
    
    axios({
      method:"POST",
      url:'https://api.account.samsung.com/auth/oauth2/v2/token',
      headers: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data,
    })
    .then(function (response) {
      console.log(`hmhm response ${response.data}`);
      res.header("Access-Control-Allow-Origin", "*");
      res.json(response.data);
    })
    .catch(error => {console.log('hmhm error : ',error.response)});
});

app.post('/v1/users/refreshToken', (req, res) => {
    console.log(`hmhmhm post2`);
    let refresh_token = req.query.refresh_token;
    console.log(`hmhm ref tok${refresh_token}`);

    const params = {
        grant_type: 'refresh_token',
        //client_id: 'dk7xqov7w1',
        client_id: 'xxxxx',
        refresh_token: refresh_token,
        client_secret: 'xxxx'
    };
    
    const data = Object.keys(params)
      .map((key) => `${key}=${encodeURIComponent(params[key])}`)
      .join('&');
    
    console.log('hmhm--2-2');
    console.log(`hmhm data ${data}`);
    
    axios({
      method:"POST",
      url:'https://api.account.samsung.com/auth/oauth2/v2/token',
      headers: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data,
    })
    .then(function (response) {
      console.log(`hmhm response ${response.data}`);
      res.header("Access-Control-Allow-Origin", "*");
      res.json(response.data);
    })
    .catch(error => {
        console.log('hmhm error : ',error.response)
        res.header("Access-Control-Allow-Origin", "*");
        res.json(error.response.data);
    });
});

app.get("/sign_in", async (req, res) => {
    const state = req.query.state;
    console.log(state)
    // if state is android or ios, it should deeplink (webauthcallback)
    // if state is web, it should web client url
    if (state == 'web') {
        const redirect = `http://localhost:8888/accesstoken?${new URLSearchParams(req.query).toString()}`
        res.redirect(307, redirect);
    } else {
        const redirect = `webauthcallback://success?${new URLSearchParams(req.query).toString()}`
        res.redirect(307, redirect);
    }
    console.log(redirect);
});


// app.listen(PORT, () => {
//     console.log('server is runngin on port', PORT);
// });

const api1  = functions.https.onRequest(app);
module.exports = {
  api1
}
