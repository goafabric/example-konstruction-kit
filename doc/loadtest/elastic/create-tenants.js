import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 100,  // Number of virtual users
  iterations: 100000,  // Total number of requests
};

const esUrl = 'http://localhost:9200';  // Update this to your Elasticsearch URL
let totalDocumentsCreated = 0;  // Global counter

// Generate person data with iteration-based tenantId, firstname, and lastname
function generatePersonData(iterationId) {
  const id = Math.floor(Math.random() * 1000000);
  return JSON.stringify({
    tenantId: iterationId,  // Use the iteration ID as the tenantId
    personId: id,
    firstname: `Homer ${id}`,  // Set firstname as 'Homer <id>'
    lastname: `Simpson ${id}`,  // Set lastname as 'Simpson <id>'
    age: Math.floor(Math.random() * 60) + 20,
    address: {
      street: `Street ${id}`,
      city: `City ${id}`,
      zipcode: `1000${id}`,
      country: `Country ${id % 10}`,
    },
  });
}

export default function () {
  totalDocumentsCreated++;
  
  const tenantId = __VU;

  const indexName = 'persons';
  //const indexName = `persons-${tenantId}`;

  const personData = generatePersonData(tenantId);  // Pass iteration ID as tenantId

  // Create a person document in Elasticsearch
  const res = http.post(`${esUrl}/${indexName}/_doc`, personData, {
    headers: { 'Content-Type': 'application/json' },
  });

  // Check if the response was successful
  check(res, {
    'status is 201': (r) => r.status === 201,
  });

  //sleep(0.5);  // Pause between requests
}

