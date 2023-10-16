const axios = require("axios");

exports.handler = async(event) => {

    const apiGatewayUrl = process.env.API_GATEWAY_URL;
    const token_endpoint = `${process.env.API_COGNITO_URL}oauth2/token`;

    // Se client_id ou client_secret estão ausentes, retorne uma resposta 401
    if (!event.body) {
        return {
            statusCode: 401,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ error: 'Credenciais inválidas.' })
        };
    }
    
    const requestBody = JSON.parse(event.body);
    const client_id = requestBody.client_id;
    const client_secret = requestBody.client_secret;
    
    try {
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
        
        const responseIdentifica = await axios.post(`${apiGatewayUrl}v1/cliente/identifica?cpf=${event.queryStringParameters?.cpf}`, null, {
            headers: {
                'Authorization': `Bearer ${token}`
            },
        });
        
        
        return {
            statusCode: 200,
            headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Credentials': true,
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(responseIdentifica.data)
            
        };
    } catch (error) {
        console.error(error);
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ error: 'Erro na autenticação' })
        };
    }
};
