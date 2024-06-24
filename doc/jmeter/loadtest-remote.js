import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 1, // Number of virtual users
    duration: '1s', // Duration of the test
};

export default function () {
    const headers = {
        'Authorization': `Bearer ${getAccessToken()}`,
    };

    const requestOptions = {
        headers: headers,
        redirects: 0, // Disable automatic following of redirects
    };

    checkResponse(http.get("https://v2202402203466256255.megasrv.de/core/patients/findByGivenName?givenName=S", requestOptions));
    checkResponse(http.get("https://v2202402203466256255.megasrv.de/catalog/insurances/findByDisplay?display=a", requestOptions));
}

function checkResponse(response) {
    check(response, {
        'status is 200': (r) => r.status === 200,
    });
    if (response.status !== 200) {
        console.error(`Unexpected status for second request: ${response.status}`);
    }
}

function getAccessToken() {
    const url = 'https://v2202402203466256255.megasrv.de/oidc/realms/tenant-0/protocol/openid-connect/token';
    const headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    };
    const body = {
        'username': 'user1',
        'password': 'User1user1',
        'grant_type': 'password',
        'client_id': 'oauth2-proxy',
        'scope': 'openid'
    };

    const response = http.post(url, body, { headers: headers });

    if (response.status !== 200) {
        console.error('Failed to retrieve access token', response.status, response.body);
        return null;
    }

    return JSON.parse(response.body).access_token;
}
