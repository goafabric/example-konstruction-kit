import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 1, // Number of virtual users
    duration: '1s', // Duration of the test
};

//const token = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyT3RFb0VTSFp2bzFKUzMxWHlDVksxOVVRaGp1UHJVNmY4RXR3YmNaVlpVIn0.eyJleHAiOjE3MTkxNTc3OTQsImlhdCI6MTcxOTE1NzQ5NCwianRpIjoiOWJlYWYyNjgtZmNjMi00MGRjLTljNDUtMzE5ZmI0YzQ3NzQyIiwiaXNzIjoiaHR0cHM6Ly92MjIwMjQwMjIwMzQ2NjI1NjI1NS5tZWdhc3J2LmRlL29pZGMvcmVhbG1zL3RlbmFudC0wIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImViNGVlODY2LWU1M2QtNDA1My1hMTEwLWI0YzQ4ODhkM2ZkZiIsInR5cCI6IkJlYXJlciIsImF6cCI6Im9hdXRoMi1wcm94eSIsInNlc3Npb25fc3RhdGUiOiIxZTQ2NWEzOC1iMGQzLTQwZGUtYWVhZS01N2IzZDlmNmVkN2IiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy10ZW5hbnQtMCIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgZW1haWwgcHJvZmlsZSIsInNpZCI6IjFlNDY1YTM4LWIwZDMtNDBkZS1hZWFlLTU3YjNkOWY2ZWQ3YiIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoidXNlcjEgdXNlcjEiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ1c2VyMSIsImdpdmVuX25hbWUiOiJ1c2VyMSIsImZhbWlseV9uYW1lIjoidXNlcjEiLCJlbWFpbCI6InVzZXIxQGV4YW1wbGUuY29tIn0.jcRi31oiB-NQgwb6L3vCwoyKsPUYGJELlkLYz4PBpNxae4YzGjdmvZ4yZmwI8nQfskYHbyDy0TgtW1TvYXbI6r_6OmY69s1HaT1S1N-HvbFKM4P2L8KUCg4WniUNLegB9fmfQfj51zewp8eNuY6umzwGBLjKMVzzsUzwe_GCXJdqRnvTOcbclJGV6eSfPKhgAfXFLRcD3Sv6wiZa73MU-pEFxIHpUrMeE8dfDfRH_Rzv18m4r_7ElNVxU-0Fgi2cbEJRpK_W8Sa87L3IpKBoGkUts6LDmDJCaAEsWCOitDJecA8DsueC_0xFH1IVcJkeFKPYFCSCoj876NlFSgieRQ'
const token = ''

export default function () {
    const headers = {
        'Authorization': `Bearer ${token}`,
    };

    const response1 = http.get("https://v2202402203466256255.megasrv.de/core/patients/findByGivenName?givenName=S", { headers });
    check(response1, {
        'status is 200': (r) => r.status === 200,
    });

    const response2 = http.get("https://v2202402203466256255.megasrv.de/core/insurances/findByDisplay?display=a", { headers });
    check(response2, {
        'status is 200': (r) => r.status === 200,
    });
}

// https://k6.io/docs/get-started/running-k6/
// docker run --rm -i grafana/k6 run - < loadtest.js
// kubectl run -n core -i --rm k6 --image=grafana/k6 --restart=Never -- run - < ./loadtest.js ; kubectl delete pod k6 -n core