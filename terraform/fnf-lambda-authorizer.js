const crypto = require("crypto");
const AWS = require("aws-sdk");

exports.handler = async (event) => {
    
    // obtencao de payload
    const requestBody = JSON.parse(event.body);
    const client_id = requestBody.client_id;
    const client_secret = requestBody.client_secret;

    const username = process.env.COGNITO_FNF_USER_NAME
    const password = process.env.COGNITO_FNF_USER_PASSWORD
    
    const secretHash = crypto.createHmac('SHA256', client_secret)
                        .update(username + client_id)
                        .digest('base64')
  
    const params = {
        AuthFlow: "USER_PASSWORD_AUTH",
        ClientId: client_id,
        AuthParameters: {
            USERNAME: username,
            PASSWORD: password,
            SECRET_HASH: secretHash
        }
    };

    const cognito = new AWS.CognitoIdentityServiceProvider({ region: "us-east-1" }); 

    try {
        const response = await cognito.initiateAuth(params).promise();

        return {
            statusCode: 200,
            body: JSON.stringify({id_token: response.AuthenticationResult.IdToken})
        };
    } catch (error) {
        console.error(error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: "Erro na autenticação" })
        };
    }
};
