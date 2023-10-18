const axios = require("axios");

exports.handler = async(event) => {

    const token_endpoint = `${process.env.API_COGNITO_URL}oauth2/token`;
    const apiGatewayUrl = process.env.API_GATEWAY_URL;
    
    // obtncao de payload
    const requestBody = JSON.parse(event.body);
    const client_id = requestBody.client_id;
    const client_secret = requestBody.client_secret;
    
    // obtencao de token via cognito
    const response = await axios.post(token_endpoint, null, {
        params: {
            grant_type: 'client_credentials'
        },
        auth: {
            username: client_id,
            password: client_secret
        }
    });
    
    const token = response.data.access_token;
    
    // identificacao de usuario no sistema fast-n-foodious
    const responseIdentifica = await axios.post(`${apiGatewayUrl}v1/cliente/identifica?cpf=${event?.queryStringParameters?.cpf}`, null, {
        headers: {
            'Authorization': `Bearer ${token}`
        },
    });
     

    event.response = {
      claimsOverrideDetails: {
        claimsToAddOrOverride: {
          ...(responseIdentifica.data.cpf ? { cpf: responseIdentifica.data.cpf } : { anonimo: responseIdentifica.data.anonimo })
        }
      }
    };

  return event;
};