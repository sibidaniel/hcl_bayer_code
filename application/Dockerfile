FROM public.ecr.aws/lambda/nodejs:18

COPY . .
# Expose the port the app runs on
RUN npm install
# Define the command to run the app
CMD [ "index.handler" ]