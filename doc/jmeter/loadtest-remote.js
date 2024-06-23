import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 1, // Number of virtual users
    duration: '1s', // Duration of the test
};

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

    const token = JSON.parse(response.body).access_token;
    return token;
}

export default function () {
    const token = getAccessToken();

    const headers = {
        'Authorization': `Bearer ${token}`,
    };

    const response1 = http.get("https://v2202402203466256255.megasrv.de/core/patients/findByGivenName?givenName=S", { headers });
    console.log(response1)
    check(response1, {
        'status is 200': (r) => r.status === 200,
    });

    const response2 = http.get("https://v2202402203466256255.megasrv.de/catalog/insurances/findByDisplay?display=a", { headers });
    check(response2, {
        'status is 200': (r) => r.status === 200,
    });
}
