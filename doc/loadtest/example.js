// https://k6.io/docs/get-started/running-k6/
// kubectl get hpa --watch -n example

import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 10, // Number of virtual users
    duration: '10s', // Duration of the test
};

const baseUrl = 'https://v2202402203466256255.megasrv.de'; //'https://kind.local'

export default function () {
    http.get(`${baseUrl}/person/persons/findByFirstName?firstName=Homer`);
    http.get(`${baseUrl}/person/persons/name?name=Heisenberg`);
}
