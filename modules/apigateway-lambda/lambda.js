const AWS = require("aws-sdk");

// localstack docker setting for secret manager
const secretsManager = new AWS.SecretsManager({
  endpoint: process.env.LOCALSTACK_HOSTNAME
    ? `http://${process.env.LOCALSTACK_HOSTNAME}:4566`
    : undefined,
  region: process.env.AWS_REGION || "us-east-1",
  credentials: {
    accessKeyId: "test",
    secretAccessKey: "test",
  },
});

exports.handler = async (event) => {
  const secretId = process.env.SECRET_ID || "secret_token";

  console.log("Fetching secret with ID:", secretId);

  try {
    const body = JSON.parse(event.body || "{}");

    if (body.action === "update") {
      console.log("Updating secret with ID:", secretId);

      await secretsManager
        .putSecretValue({
          SecretId: secretId,
          SecretString: JSON.stringify(body.secret),
        })
        .promise();

      return {
        statusCode: 200,
        body: JSON.stringify({
          message: "Secret updated successfully",
        }),
      };
    } else if (body.action === "get") {
      console.log("Fetching secret with ID:", secretId);

      const secretValue = await secretsManager
        .getSecretValue({ SecretId: secretId })
        .promise();
      const secret = JSON.parse(secretValue.SecretString);

      return {
        statusCode: 200,
        body: JSON.stringify({
          message: "Secret retrieved successfully",
          secret: secret,
        }),
      };
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Invalid action. Use 'get' or 'update'.",
        }),
      };
    }
  } catch (error) {
    console.error("Error handling request:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to process request",
        error: error.message,
      }),
    };
  }
};
