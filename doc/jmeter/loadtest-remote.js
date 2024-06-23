import http from "k6/http";
import { check, sleep } from 'k6';

export const options = {
    vus: 1, // Number of virtual users
    duration: '1s', // Duration of the test
};

const token = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyT3RFb0VTSFp2bzFKUzMxWHlDVksxOVVRaGp1UHJVNmY4RXR3YmNaVlpVIn0.eyJleHAiOjE3MTkxNTkwODcsImlhdCI6MTcxOTE1ODc4NywianRpIjoiM2ZiNjJhOWMtMDZiMi00ZDU2LTg3OGYtMWJhYzA4Y2JiZDI0IiwiaXNzIjoiaHR0cHM6Ly92MjIwMjQwMjIwMzQ2NjI1NjI1NS5tZWdhc3J2LmRlL29pZGMvcmVhbG1zL3RlbmFudC0wIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6ImViNGVlODY2LWU1M2QtNDA1My1hMTEwLWI0YzQ4ODhkM2ZkZiIsInR5cCI6IkJlYXJlciIsImF6cCI6Im9hdXRoMi1wcm94eSIsInNlc3Npb25fc3RhdGUiOiI1NjIyMjNiMy1kOGQ5LTQ3OTEtYmU5NS1lNmNhMDZmYzE4MjEiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy10ZW5hbnQtMCIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgZW1haWwgcHJvZmlsZSIsInNpZCI6IjU2MjIyM2IzLWQ4ZDktNDc5MS1iZTk1LWU2Y2EwNmZjMTgyMSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoidXNlcjEgdXNlcjEiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ1c2VyMSIsImdpdmVuX25hbWUiOiJ1c2VyMSIsImZhbWlseV9uYW1lIjoidXNlcjEiLCJlbWFpbCI6InVzZXIxQGV4YW1wbGUuY29tIn0.MgPL4a6smtKXu7pWtqM_53rdo3pDSGRAVfKcZW_QLDATgLXu21QHWFaBt-gl3bTd7GuF_dwkswieZ2slRHBrVzl9VXkYr8MhY9sBVHGcX8dYJePXH9f9djabuEJWSrnw6_Bkl8VR-5Qk4YbHCgcnzAZkRA4WBp3mseLm1LsmaYnPCt9OKYLY6jxS4ivVMcYPE7SybG4gBQ2G-So8Tt-x_5DpVUNYRjdiXbOpUS8mFRQwxiB8771E6iT2_ddPtLhTPok-88JlOpVLM2cB_sMR9i-lFOJUU40HN7jX8EjmD9IObG7IW52TmWkp1gRhUmOhcBtPdvNj5AIqK0G-ymrHwQ'

export default function () {
    const headers = {
        'Authorization': `Bearer ${token}`,
    };

    const response1 = http.get("https://v2202402203466256255.megasrv.de/core/patients/findByGivenName?givenName=S", { headers });
    check(response1, {
        'status is 200': (r) => r.status === 200,
    });

    const response2 = http.get("https://v2202402203466256255.megasrv.de/catalog/insurances/findByDisplay?display=a", { headers });
    check(response2, {
        'status is 200': (r) => r.status === 200,
    });
}

// https://k6.io/docs/get-started/running-k6/
// docker run --rm -i grafana/k6 run - < loadtest.js
// kubectl run -n core -i --rm k6 --image=grafana/k6 --restart=Never -- run - < ./loadtest.js ; kubectl delete pod k6 -n core