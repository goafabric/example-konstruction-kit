// https://k6.io/docs/get-started/running-k6/

import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 10, // Number of virtual users
    duration: '60s', // Duration of the test
};

const baseUrl = 'https://v2202402203466256255.megasrv.de'; //'https://kind.local'

export default function () {
    const requestOptions = getRequestOptions();
    checkResponse(http.get(`${baseUrl}/person/persons/findAll`, requestOptions));
}

function checkResponse(response) {
    check(response, {
        'status is 200': (r) => r.status === 200,
    });
    if (response.status !== 200) {
        console.error('Unexpected status for request', response.status, response.body);
    }
}

function getRequestOptions() {
    if (baseUrl != 'https://kind.local') {
        return {
            headers: {
                'Authorization': `Bearer ${getAccessToken()}`
            },
            redirects: 0, // Disable automatic following of redirects
        };
    } else {
        return null;
    }
}

function getAccessToken() {
    const url = `${baseUrl}/oidc/realms/tenant-0/protocol/openid-connect/token`;
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
