import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 1, // Number of virtual users
    duration: '1s', // Duration of the test
};

const token = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyT3RFb0VTSFp2bzFKUzMxWHlDVksxOVVRaGp1UHJVNmY4RXR3YmNaVlpVIn0.eyJleHAiOjE3MTkxNTg1ODMsImlhdCI6MTcxOTE1ODI4MywianRpIjoiMjQ3MjNkZDItNGRlNi00ZDFmLThmM2QtNmUxNWFkZDc1MjY0IiwiaXNzIjoiaHR0cHM6Ly92MjIwMjQwMjIwMzQ2NjI1NjI1NS5tZWdhc3J2LmRlL29pZGMvcmVhbG1zL3RlbmFudC0wIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImViNGVlODY2LWU1M2QtNDA1My1hMTEwLWI0YzQ4ODhkM2ZkZiIsInR5cCI6IkJlYXJlciIsImF6cCI6Im9hdXRoMi1wcm94eSIsInNlc3Npb25fc3RhdGUiOiJmNTk2YTBhZS1hNjczLTQzN2ItYTY3MS05MDFhYjMxOWNmNDMiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy10ZW5hbnQtMCIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgZW1haWwgcHJvZmlsZSIsInNpZCI6ImY1OTZhMGFlLWE2NzMtNDM3Yi1hNjcxLTkwMWFiMzE5Y2Y0MyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoidXNlcjEgdXNlcjEiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ1c2VyMSIsImdpdmVuX25hbWUiOiJ1c2VyMSIsImZhbWlseV9uYW1lIjoidXNlcjEiLCJlbWFpbCI6InVzZXIxQGV4YW1wbGUuY29tIn0.JqjfSoJeYWkDSdKfw-I37VcdIT1YLLHn_AEo2w_UtzNimeyBNK1xK3mplgNXztU9-y1USmfjp3Q0ouV2ojWaI5WqE--fI7hwJ7SoE1X-4mfeq6WTShIQ2FJHlVbYGJGx4iOqzDE5132-ukqeBB2si1wYqTZwC_EuVs8L8twu78zWH1DX51U2np1VBWB2ynDoPgxRLUCYfnCtY4EbxCUaLX2JWd_g0Lz0O-EHN5KISpI0RZ-GDPCeW6Abbb0WZlZynlfRLjcoHve7s_oeYs9BCe5xwHYN0SLktJCnG3rI0UK1B2Beq3Nths8U-4C2GWocneG3BtHieQgYFNQCciUEnw'

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