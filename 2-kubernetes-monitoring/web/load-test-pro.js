import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '30s', target: 500 }, // Ramp-up to 20 users over 30 seconds
        { duration: '2m', target: 2000 }, // Stay at 50 users for 1 minute
        { duration: '1m', target: 10 }, // Ramp-down to 0 users over 30 seconds
    ],
};

export default function() {
    // Replace with your Minikube endpoint or Ingress host (http://dev.demo-webapp.local)
    let res = http.get('http://demo-webapp.com/');

    // Check for successful response status
    check(res, {
        'status was 200': (r) => r.status === 200,
    });
}