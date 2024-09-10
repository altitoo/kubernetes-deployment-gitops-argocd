import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '15s', target: 200 }, // Ramp-up to 20 users over 30 seconds
        { duration: '1m', target: 3000 }, // Stay at 50 users for 1 minute
        { duration: '10s', target: 0 }, // Ramp-down to 0 users over 30 seconds
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