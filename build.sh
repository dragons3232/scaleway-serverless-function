export SCW_ACCESS_KEY="SCWR11NYHHSQJ05NDYCB"
export SCW_SECRET_KEY="cdf31324-3909-416e-a17d-49a29f8c08f5"

export TF_VAR_scw_access_key_id=$SCW_ACCESS_KEY
export TF_VAR_scw_secret_access_key=$SCW_SECRET_KEY
export TF_VAR_project_id="25997adc-9bec-4e3f-b0a3-142f2f5829d5"

export TF_VAR_any_var="Test VAR"
export TF_VAR_DATABASE_URL="postgresql://user:pasword@host:5432/schema"

cd ./function && npm install
rm -rf dist && npm run build && mv node_modules dist
cp package.json dist
cd ..

# terraform init
# terraform plan
terraform apply