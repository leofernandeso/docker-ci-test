# specifying base image and its phase
FROM python:3 as builder 
WORKDIR /usr/src/app
# Cached requirements file
COPY ./requirements.txt ./
# This will only run if the requirements file change
RUN pip install flask redis requests
COPY . .
# Command to run when the container is ran
CMD ["python", "app.py"]

# FROM nginx
# COPY --from==builder /usr/src/build /usr/share/nginx/html
