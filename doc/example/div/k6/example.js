// https://k6.io/docs/get-started/running-k6/

import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 5, // Number of virtual users
    duration: '3s', // Duration of the test
};

const baseUrl = 'http://localhost:50800'

export default function () {
    http.get(`${baseUrl}/persons?firstName=Homer&page=0&size=3`);
//    http.get(`${baseUrl}/persons/name?name=Heisenberg`);
}
