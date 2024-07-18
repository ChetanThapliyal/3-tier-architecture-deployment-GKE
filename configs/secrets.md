#### First 3 variables are used for pushing images to database
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_KEY=
CLOUDINARY_SECRET=

<!--to view campground locations on map-->
MAPBOX_TOKEN=

<!--to connect to mongodb atlas database-->
DB_URL=
SECRET=


## MongoAtlasDB creds
username:
password:



---
Store above secrets in Kubernetes Secrets using:

```bash
    kubectl create secret generic yelp-camp-secrets \
    --from-literal=CLOUDINARY_CLOUD_NAME=my-cloud-name \
    --from-literal=CLOUDINARY_KEY=my-cloud-key \
    --from-literal=CLOUDINARY_SECRET=my-cloud-secret \
    --from-literal=MAPBOX_TOKEN=my-mapbox-token \
    --from-literal=DB_URL=my-db-url \
    --from-literal=SECRET=my-secret
```