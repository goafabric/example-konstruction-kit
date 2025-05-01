// https://k6.io/docs/get-started/running-k6/
// kubectl get hpa --watch -n example

import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 1, // Number of virtual users
    duration: '10s', // Duration of the test
};

const baseUrl = 'https://kind.local'

export default function () {
    http.get(`${baseUrl}/person/persons/findByFirstName?firstName=Homer`);
    http.get(`${baseUrl}/person/persons/sayMyName?name=Heisenberg`);
}
