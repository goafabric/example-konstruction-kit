import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 10, // Number of virtual users
    duration: '5s', // Duration of the test
};

export default function () {
  http.get("http://core-application.core:8080/patients/findByGivenName?givenName=S");
  http.get("http://catalog-application.core:8080/insurances/findByDisplay?display=a");
}

// https://k6.io/docs/get-started/running-k6/
// docker run --rm -i grafana/k6 run - < loadtest.js
// kubectl run -n core -i --rm k6 --image=grafana/k6 --restart=Never -- run - < ./loadtest.js ; k delete pod k6 -n core