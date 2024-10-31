import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,  // Number of virtual users
  iterations: 100,  // Total number of requests
};

const esUrl = 'http://localhost:9200';  // Update this to your Elasticsearch URL
const indexName = 'persons';  // Update this to your desired index name

export default function () {
  // Generate random tenantId (1-10) and personId (1-10,000)
  const tenantId = Math.floor(Math.random() * 10) + 1;
  const personId = Math.floor(Math.random() * 100);

  // Define the search query to match tenantId and personId fields
  const query = JSON.stringify({
    query: {
      bool: {
        must: [
          { match: { tenantId: tenantId } },
          { match: { personId: personId } },
        ],
      },
    },
  });

  // Perform the search query on Elasticsearch
  const res = http.post(`${esUrl}/${indexName}/_search`, query, {
    headers: { 'Content-Type': 'application/json' },
  });

  // Check if the response was successful and found results
  check(res, {
    'status is 200': (r) => r.status === 200,
    'found results': (r) => JSON.parse(r.body).hits.total.value > 0,
  });

  sleep(0.5);  // Pause between requests
}
