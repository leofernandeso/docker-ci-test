import requests

#response = requests.get('simple-app:80')
response = 200

print("Running response status code test...")
assert response == 200
assert False, "Did not pass this test."
print("Passed response status code test")
print("Finished all tests. Bye.")