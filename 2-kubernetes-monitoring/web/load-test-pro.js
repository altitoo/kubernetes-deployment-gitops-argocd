import http from 'k6/http';
import { check, sleep } from 'k6';

// Define the test options
export let options = {
    stages: [
        { duration: '30s', target: 100 }, // Ramp-up to 100 users over 30 seconds
        { duration: '2m', target: 500 }, // Ramp-up to 1000 users over 2 minutes
        { duration: '3m', target: 800 }, // Hold steady at 2000 users for 3 minutes
        { duration: '5m', target: 300 }, // Ramp-down to 500 users over 1 minute
        { duration: '3m', target: 0 }, // Ramp-down to 0 users over 30 seconds
    ],
    thresholds: {
        http_req_duration: ['p(95)<2000'], // 95% of requests should be below 2 seconds
        http_req_failed: ['rate<0.01'], // Allow 1% of requests to fail
    },
};

// Define the test behavior
export default function() {
    // Replace with your Minikube endpoint or Ingress host
    let res = http.get('http://demo-webapp.com/');

    // Check if the response was successful
    check(res, {
        'status was 200': (r) => r.status === 200,
        'response time < 2s': (r) => r.timings.duration < 2000,
    });

    // Sleep to simulate real user interaction
    sleep(1);
}