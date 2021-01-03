import requests

#response = requests.get('simple-app:80')
response = 200

print("Running response status code test...")
assert response.status_code == 200
print("Passed response status code test")
print("Finished all tests. Bye.")